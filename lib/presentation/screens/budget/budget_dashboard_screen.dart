import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../providers/dashboard_provider.dart';
import '../../widgets/add_transaction_dialog.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../companies/widgets/company_title.dart';
import '../../widgets/common/state_switcher.dart';
import 'widgets/attendance_summary_card.dart';
import 'widgets/net_salary_hero.dart';
import 'widgets/salary_composition_chart.dart';
import 'widgets/spending_breakdown.dart';
import 'transaction_list_screen.dart';

/// أول شاشة يراها المستخدم: أين وصل راتبه هذا الشهر، وأين يذهب.
///
/// الترتيب مقصود — رقم واحد أولاً، ثم تفسيره، ثم تفاصيله. لا شبكة بطاقات
/// متساوية الوزن؛ فيها لا تعرف العين أين تبدأ.
class BudgetDashboardScreen extends ConsumerWidget {
  const BudgetDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        // العنوان يحمل اسم الجهة: كل رقم تحته يخصّها وحدها، فإخفاء الاسم
        // يجعل المستخدم يقرأ أرقام جهة ظانّاً أنها أخرى.
        title: const CompanyTitle(fallback: 'الميزانية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'سجل التنبيهات',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
          ),
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            tooltip: 'التقارير',
            onPressed: () => Navigator.pushNamed(context, AppRoutes.analytics),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardDataProvider),
        child: StateSwitcher<DashboardData>(
          value: dashboard,
          skeletonHeight: 220,
          onRetry: () => ref.invalidate(dashboardDataProvider),
          builder: (data) => _Body(data: data),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.data});

  final DashboardData data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final expenses = ref
        .watch(monthlyExpensesByCategoryProvider(
            year: now.year, month: now.month))
        .value;

    return ListView(
      padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screen, AppSpacing.sm, AppSpacing.screen, 190),
      children: [
        NetSalaryHero(data: data),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(
          title: 'دوامك هذا الشهر',
          subtitle: 'الأيام والساعات وأثرها على الراتب',
        ),
        AttendanceSummaryCard(data: data),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(
          title: 'من أين جاء الرقم',
          subtitle: 'ما أُضيف وما خُصم من الأساسي',
        ),
        SalaryCompositionChart(data: data),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'أين ذهب',
          subtitle: 'مصروفات ${_monthLabel(now)} حسب الفئة',
          actionLabel: 'الكل',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const TransactionListScreen(),
            ),
          ),
        ),
        if (expenses == null)
          const _InlineSkeleton()
        else if (expenses.isEmpty)
          const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'لا مصروفات هذا الشهر',
            message: 'سجّل مصروفاً ليظهر توزيعك هنا.',
          )
        else
          SpendingBreakdown(items: expenses, currency: data.currency),
        const SizedBox(height: AppSpacing.xl),
        // خياران صريحان: "حركة" وحدها تُلزم المستخدم بخطوة إضافية لاختيار
        // النوع داخل الورقة، والنوع هو أول ما يعرفه أصلاً.
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _add(context, TransactionTypeEntity.income),
                icon: const Icon(Icons.south_west_rounded, size: AppIconSize.md),
                label: const Text('دخل'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _add(context, TransactionTypeEntity.expense),
                icon: const Icon(Icons.north_east_rounded, size: AppIconSize.md),
                label: const Text('مصروف'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _add(BuildContext context, TransactionTypeEntity type) {
    UIHelpers.showModernBottomSheet(
      context: context,
      title: type == TransactionTypeEntity.income ? 'دخل جديد' : 'مصروف جديد',
      child: AddTransactionDialog(type: type),
    );
  }

  static String _monthLabel(DateTime date) => switch (date.month) {
        1 => 'يناير',
        2 => 'فبراير',
        3 => 'مارس',
        4 => 'أبريل',
        5 => 'مايو',
        6 => 'يونيو',
        7 => 'يوليو',
        8 => 'أغسطس',
        9 => 'سبتمبر',
        10 => 'أكتوبر',
        11 => 'نوفمبر',
        _ => 'ديسمبر',
      };
}

class _InlineSkeleton extends StatelessWidget {
  const _InlineSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: context.palette.surfaceAlt,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
    );
  }
}
