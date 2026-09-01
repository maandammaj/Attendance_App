import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../providers/debt_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/debt_item_card.dart';
import 'add_debt_screen.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(allDebtsProvider);
    final summary = ref.watch(debtSummaryProvider);
    final currency = ref.watch(profileProvider).valueOrNull?.currency ?? 'ر.ي';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إدارة الديون'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'عليك'),
              Tab(text: 'لك'),
            ],
          ),
        ),
        body: Column(
          children: [
            summary.when(
              data: (s) => _buildSummaryCard(context, s, currency),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Expanded(
              child: debts.when(
                data: (list) => TabBarView(
                  children: [
                    _DebtList(debts: list, currency: currency),
                    _DebtList(debts: list.where((d) => d.debtType == 'owe').toList(), currency: currency),
                    _DebtList(debts: list.where((d) => d.debtType == 'owed').toList(), currency: currency),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('خطأ: $err')),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'debts_fab',
          onPressed: () => UIHelpers.showModernBottomSheet(
            context: context,
            title: 'إضافة دين جديد',
            child: const AddDebtBottomSheet(),
          ),
          icon: const Icon(Icons.add),
          label: const Text('دين جديد'),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, dynamic summary, String currency) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDebtIndicator(
                  context,
                  label: 'عليك',
                  amount: summary.remainingOwe,
                  color: Theme.of(context).colorScheme.error,
                  icon: Icons.arrow_upward,
                  currency: currency,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildDebtIndicator(
                  context,
                  label: 'لك',
                  amount: summary.remainingOwed,
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icons.arrow_downward,
                  currency: currency,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('الموقف الصافي:'),
              Text(
                '${summary.netDebtPosition.toStringAsFixed(2)} $currency',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: summary.netDebtPosition >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebtIndicator(
      BuildContext context, {
        required String label,
        required double amount,
        required Color color,
        required IconData icon,
        required String currency,
      }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${amount.toStringAsFixed(2)} $currency',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DebtList extends ConsumerWidget {
  final List<DebtEntity> debts;
  final String currency;

  const _DebtList({required this.debts, required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (debts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد ديون مسجلة', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: debts.length,
      itemBuilder: (context, index) {
        final debt = debts[index];
        return Stack(
          children: [
            DebtItemCard(
              title: debt.description != null && debt.description!.isNotEmpty
                  ? '${debt.personName} (${debt.description})'
                  : debt.personName,
              amount: debt.remainingAmount,
              isDebt: debt.debtType == 'owe',
              date: debt.dueDate ?? debt.createdAt,
              currency: currency,
            ),
            Positioned(
              left: 24,
              top: 12,
              child: IconButton(
                icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                onPressed: () => _confirmDelete(context, ref, debt),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, DebtEntity debt) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الدين'),
        content: const Text('هل أنت متأكد من حذف هذا السجل؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(debtControllerProvider.notifier).deleteDebt(debt.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
