import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../providers/dashboard_provider.dart';
import 'transaction_list_screen.dart';
import '../../widgets/add_transaction_dialog.dart';
import '../../../domain/entities/transaction_entity.dart';

class BudgetDashboardScreen extends ConsumerWidget {
  const BudgetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('الميزانية والتحليل'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Navigator.pushNamed(context, '/notification-history'),
          ),
        ],
      ),
      body: dashboard.when(
        data: (data) {
          if (!data.isProfileSetup) {
            return const Center(
              child: Text('يرجى إعداد الملف الشخصي أولاً'),
            );
          }
          return _buildDashboard(context, data);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, dynamic data) {
    final sections = <PieChartSectionData>[];
    final colors = [
      Theme.of(context).colorScheme.primary,
      Colors.green,
      Colors.red,
      Colors.orange,
      Colors.purple,
    ];

    final items = [
      ('الراتب الأساسي', data.baseSalary),
      ('الإضافي', data.totalOvertimeValue),
      ('البدلات/الخصومات', data.totalAdjustments),
      ('الخصومات (تأخير)', -data.totalDeficitValue),
      ('الديون المدفوعة', -data.totalDebtPayments),
      ('المصاريف الأخرى', -data.totalTransactionsExpenses),
      ('المتبقي الصافي', data.netSalary),
    ];

    double total = items.fold(0, (sum, item) => sum + (item.$2 as double).abs());

    for (int i = 0; i < items.length; i++) {
      final value = (items[i].$2 as double).abs();
      if (value <= 0) continue;
      final percentage = total > 0 ? (value / total) * 100 : 0;

      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.tertiary,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                const Text(
                  'الراتب الصافي المتوقع',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  '${data.netSalary.toStringAsFixed(2)} ${data.currency}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 280,
            child: PieChart(
              PieChartData(
                sections: sections,
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('تفاصيل الحركات', style: Theme.of(context).textTheme.titleMedium),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransactionListScreen()),
                  ),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => UIHelpers.showModernBottomSheet(
                      context: context,
                      title: 'إضافة مصروف جديد',
                      child: const AddTransactionDialog(type: TransactionTypeEntity.expense),
                    ),
                    icon: const Icon(Icons.remove_circle_outline),
                    label: const Text('إضافة مصروف'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        UIHelpers.showModernBottomSheet(
                      context: context,
                      title: 'إضافة دخل جديد',
                      child: const AddTransactionDialog(type: TransactionTypeEntity.income),
                    ),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('إضافة دخل'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade50, foregroundColor: Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final item = items[index];
                final color = colors[index % colors.length];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.2),
                    child: Icon(Icons.circle, color: color, size: 12),
                  ),
                  title: Text(item.$1),
                  trailing: Text(
                    '${(item.$2 as double).toStringAsFixed(2)} ${data.currency}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: (item.$2 as double) < 0 ? Colors.red : null,
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: data.debtToSalaryRatio > 0.3
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'نسبة الديون من الراتب',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${(data.debtToSalaryRatio * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: data.debtToSalaryRatio > 0.3
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (data.debtToSalaryRatio as double).clamp(0.0, 1.0),
                  backgroundColor: Colors.grey.shade300,
                  color: data.debtToSalaryRatio > 0.3 ? Colors.red : Colors.green,
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                Text(
                  data.debtToSalaryRatio > 0.3
                      ? 'تحذير: نسبة الديون مرتفعة وتتجاوز الحد الآمن (30%)'
                      : 'وضع الديون في الحدود الآمنة',
                  style: TextStyle(
                    fontSize: 12,
                    color: data.debtToSalaryRatio > 0.3
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}