import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../domain/usecases/debt/get_debts_summary_usecase.dart';
import '../../providers/debt_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/state_switcher.dart';
import '../../widgets/debt_item_card.dart';
import 'add_debt_screen.dart';

class DebtsScreen extends ConsumerWidget {
  const DebtsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debts = ref.watch(allDebtsProvider);
    final summary = ref.watch(debtSummaryProvider);
    final currency = ref.watch(profileProvider).valueOrNull?.currency ??
        AppConstants.defaultCurrency;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الديون'),
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
              data: (data) =>
                  _DebtSummaryCard(summary: data, currency: currency),
              loading: () => const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Skeleton(height: 132),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            Expanded(
              child: debts.when(
                data: (list) => TabBarView(
                  children: [
                    _DebtList(debts: list, currency: currency),
                    _DebtList(
                      debts: list.where((d) => d.debtType == 'owe').toList(),
                      currency: currency,
                    ),
                    _DebtList(
                      debts: list.where((d) => d.debtType == 'owed').toList(),
                      currency: currency,
                    ),
                  ],
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [Skeleton(height: 96), Skeleton(height: 96)],
                  ),
                ),
                error: (error, _) =>
                    Center(child: Text('تعذّر التحميل: $error')),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'debts_fab',
          onPressed: () => UIHelpers.showModernBottomSheet(
            context: context,
            title: 'دين جديد',
            child: const AddDebtBottomSheet(),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text('دين جديد'),
        ),
      ),
    );
  }
}

/// موقف الديون: ما عليك، وما لك، ثم الصافي.
class _DebtSummaryCard extends StatelessWidget {
  const _DebtSummaryCard({required this.summary, required this.currency});

  final DebtSummary summary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final net = summary.netDebtPosition;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.outline),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _Indicator(
                  label: 'عليك',
                  amount: summary.remainingOwe,
                  color: palette.negative,
                  icon: Icons.north_east_rounded,
                  currency: currency,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _Indicator(
                  label: 'لك',
                  amount: summary.remainingOwed,
                  color: palette.positive,
                  icon: Icons.south_west_rounded,
                  currency: currency,
                ),
              ),
            ],
          ),
          const Divider(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text('الموقف الصافي', style: theme.textTheme.bodyMedium),
              ),
              Text(
                '${net.toStringAsFixed(0)} $currency',
                style: theme.textTheme.titleMedium
                    ?.copyWith(
                        color: net >= 0 ? palette.positive : palette.negative)
                    .merge(tabularFigures),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  const _Indicator({
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
    required this.currency,
  });

  final String label;
  final double amount;
  final Color color;
  final IconData icon;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: AppIconSize.sm, color: color),
              const SizedBox(width: 6),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${amount.toStringAsFixed(0)} $currency',
              // الرقم بلون الحبر؛ الأيقونة والخلفية تحملان الدلالة، فلا
              // يتنافس اللون مع القراءة.
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: palette.onSurface)
                  .merge(tabularFigures),
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtList extends ConsumerWidget {
  const _DebtList({required this.debts, required this.currency});

  final List<DebtEntity> debts;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (debts.isEmpty) {
      return const EmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'لا ديون هنا',
        message: 'أضف ديناً لك أو عليك لتتبّع سداده وتذكيرك قبل استحقاقه.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsetsDirectional.fromSTEB(
          AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
      itemCount: debts.length,
      itemBuilder: (context, index) => _DebtRow(
        debt: debts[index],
        currency: currency,
        onDelete: () => _confirmDelete(context, ref, debts[index]),
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, DebtEntity debt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الدين'),
        content: Text('سيُحذف سجل «${debt.personName}» نهائياً.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await ref.read(debtControllerProvider.notifier).deleteDebt(debt.id);
  }
}

/// صف دين واحد. الحذف عبر السحب لا زر عائم فوق البطاقة، فالزر المطلق
/// كان يغطي جزءاً من المحتوى ولا يبلغ حد اللمس.
class _DebtRow extends StatelessWidget {
  const _DebtRow({
    required this.debt,
    required this.currency,
    required this.onDelete,
  });

  final DebtEntity debt;
  final String currency;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Dismissible(
      key: ValueKey(debt.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        // الحذف يمر بحوار تأكيد ثم يُبطل المزوّد القائمة، فلا نُزيل الصف هنا.
        return false;
      },
      background: Container(
        margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.xl),
        alignment: AlignmentDirectional.centerEnd,
        decoration: BoxDecoration(
          color: palette.negative.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Icon(Icons.delete_outline_rounded, color: palette.negative),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
        child: DebtItemCard(
          title: debt.description != null && debt.description!.isNotEmpty
              ? '${debt.personName} (${debt.description})'
              : debt.personName,
          amount: debt.remainingAmount,
          isDebt: debt.debtType == 'owe',
          date: debt.dueDate ?? debt.createdAt,
          currency: currency,
        ),
      ),
    );
  }
}
