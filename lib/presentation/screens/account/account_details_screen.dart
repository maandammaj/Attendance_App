import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import '../../widgets/common/state_switcher.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/constants/theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/account_entity.dart';
import '../../providers/account_provider.dart';
import '../../providers/debt_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/profile_provider.dart';

class AccountDetailsScreen extends ConsumerWidget {
  final int accountId;

  const AccountDetailsScreen({super.key, required this.accountId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final accounts = ref.watch(allAccountsProvider);
    final account = accounts.whenData((list) => list.firstWhere((a) => a.id == accountId)).value;

    if (account == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('الحساب غير موجود')));
    }

    final profileAsync = ref.watch(profileProvider);
    final currency = profileAsync.value?.currency ?? 'ر.ي';

    final debts = ref.watch(allDebtsProvider);
    final transactions = ref.watch(monthlyTransactionsProvider(year: DateTime.now().year, month: DateTime.now().month));

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'تعديل',
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditAccountDialog(context, ref, account),
          ),
          IconButton(
              tooltip: 'حذف نهائي',
            icon: Icon(Icons.delete_forever, color: palette.negative),
            onPressed: () => _confirmDeleteAccount(context, ref, account),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _AccountHeader(account: account, currency: currency),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  Icon(Icons.history, color: palette.info),
                  const SizedBox(width: 8),
                  Text('السجل المالي', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          debts.when(
            data: (list) {
              final accountDebts = list.where((d) => d.accountId == accountId).toList();
              if (accountDebts.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _DebtTile(
                    debt: accountDebts[index],
                    currency: currency,
                    onDelete: () => _confirmDeleteDebt(
                        context, ref, accountDebts[index].id),
                  ),
                  childCount: accountDebts.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Skeleton(height: 72),
              ),
            ),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          transactions.when(
            data: (list) {
              final accountTrans = list.where((t) => t.accountId == accountId).toList();
              if (accountTrans.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _TransactionTile(
                    transaction: accountTrans[index],
                    currency: currency,
                    onDelete: () => _confirmDeleteTransaction(
                        context, ref, accountTrans[index].id),
                  ),
                  childCount: accountTrans.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref, AccountEntity account) {
  final palette = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحساب نهائياً'),
        content: Text('سيتم حذف الحساب "${account.name}" وكافة العمليات المرتبطة به. هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(accountControllerProvider.notifier).deleteAccount(account.id);
              if (ctx.mounted) {
                Navigator.pop(ctx);
                Navigator.pop(context);
              }
            },
            child: Text('حذف', style: TextStyle(color: palette.negative)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteDebt(BuildContext context, WidgetRef ref, int id) {
  final palette = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الدين'),
        content: const Text('هل أنت متأكد من حذف هذا السجل؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(debtControllerProvider.notifier).deleteDebt(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('حذف', style: TextStyle(color: palette.negative)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(BuildContext context, WidgetRef ref, int id) {
  final palette = context.palette;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحركة'),
        content: const Text('هل أنت متأكد؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(transactionControllerProvider.notifier).deleteTransaction(id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('حذف', style: TextStyle(color: palette.negative)),
          ),
        ],
      ),
    );
  }

  void _showEditAccountDialog(BuildContext context, WidgetRef ref, AccountEntity account) {
    final nameCtl = TextEditingController(text: account.name);
    AccountTypeEntity type = account.type;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('تعديل الحساب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: const InputDecoration(labelText: 'اسم الحساب'),
              ),
              const SizedBox(height: 16),
              DropdownButton<AccountTypeEntity>(
                value: type,
                isExpanded: true,
                items: AccountTypeEntity.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                    .toList(),
                onChanged: (v) => setState(() => type = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            TextButton(
              onPressed: () async {
                if (nameCtl.text.isNotEmpty) {
                  final updated = AccountEntity(
                    id: account.id,
                    name: nameCtl.text,
                    type: type,
                    totalBalance: account.totalBalance,
                    createdAt: account.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  await ref.read(accountControllerProvider.notifier).updateAccount(updated);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}

/// رصيد الحساب التراكمي — الرقم الوحيد الذي يفتح الشاشة.
class _AccountHeader extends StatelessWidget {
  const _AccountHeader({required this.account, required this.currency});

  final AccountEntity account;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isCredit = account.totalBalance >= 0;

    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: palette.outline),
      ),
      child: Column(
        children: [
          Text(
            isCredit ? 'لك عند هذا الحساب' : 'عليك لهذا الحساب',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: palette.onSurfaceVariant),
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '${account.totalBalance.abs().toStringAsFixed(0)} $currency',
              style: theme.textTheme.displaySmall
                  ?.copyWith(
                      color: isCredit ? palette.positive : palette.negative)
                  .merge(tabularFigures),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              Chip(
                label: Text(_typeLabel(account.type)),
                avatar: Icon(Icons.category_outlined, size: AppIconSize.sm),
                visualDensity: VisualDensity.compact,
              ),
              if (account.phoneNumber != null)
                Chip(
                  label: Text(account.phoneNumber!),
                  avatar: Icon(Icons.phone_outlined, size: AppIconSize.sm),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
      ),
    );
  }

  static String _typeLabel(AccountTypeEntity type) => switch (type) {
        AccountTypeEntity.supplier => 'مورّد',
        AccountTypeEntity.customer => 'عميل',
        AccountTypeEntity.friend => 'صديق',
        AccountTypeEntity.personal => 'شخصي',
      };
}

class _DebtTile extends StatelessWidget {
  const _DebtTile({
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
    final isOwe = debt.debtType == 'owe';
    final color = isOwe ? palette.negative : palette.positive;

    return _LedgerTile(
      color: color,
      icon: isOwe ? Icons.north_east_rounded : Icons.south_west_rounded,
      title: 'دين: ${debt.description ?? "بدون وصف"}',
      date: debt.createdAt,
      amount: debt.totalAmount,
      currency: currency,
      onDelete: onDelete,
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({
    required this.transaction,
    required this.currency,
    required this.onDelete,
  });

  final TransactionEntity transaction;
  final String currency;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final isExpense = transaction.type == TransactionTypeEntity.expense;

    return _LedgerTile(
      color: isExpense ? palette.warning : palette.info,
      icon: isExpense
          ? Icons.shopping_cart_outlined
          : Icons.add_card_outlined,
      title: transaction.categoryName,
      date: transaction.date,
      amount: transaction.amount,
      currency: currency,
      onDelete: onDelete,
    );
  }
}

/// صف دفتر واحد. مشترك بين الديون والحركات لأن بنيتهما واحدة؛ الاختلاف
/// في الأيقونة واللون فقط.
class _LedgerTile extends StatelessWidget {
  const _LedgerTile({
    required this.color,
    required this.icon,
    required this.title,
    required this.date,
    required this.amount,
    required this.currency,
    required this.onDelete,
  });

  final Color color;
  final IconData icon;
  final String title;
  final DateTime date;
  final double amount;
  final String currency;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.screen, 0, AppSpacing.screen, AppSpacing.sm),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsetsDirectional.fromSTEB(
              AppSpacing.md, AppSpacing.xs, AppSpacing.sm, AppSpacing.xs),
          leading: CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, color: color, size: AppIconSize.md),
          ),
          title: Text(title, style: theme.textTheme.bodyLarge),
          subtitle: Text(DateHelpers.formatShortDate(date)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${amount.toStringAsFixed(0)} $currency',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: palette.onSurface)
                    .merge(tabularFigures),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    size: AppIconSize.md),
                tooltip: 'حذف',
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
