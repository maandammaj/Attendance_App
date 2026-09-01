import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
    final accounts = ref.watch(allAccountsProvider);
    final account = accounts.whenData((list) => list.firstWhere((a) => a.id == accountId)).valueOrNull;

    if (account == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('الحساب غير موجود')));
    }

    final profileAsync = ref.watch(profileProvider);
    final currency = profileAsync.valueOrNull?.currency ?? 'ر.ي';

    final debts = ref.watch(allDebtsProvider);
    final transactions = ref.watch(monthlyTransactionsProvider(year: DateTime.now().year, month: DateTime.now().month));

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditAccountDialog(context, ref, account),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () => _confirmDeleteAccount(context, ref, account),
          )
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context, account, currency),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.history, color: Colors.blue),
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
                  (context, index) => _buildDebtTile(context, ref, accountDebts[index], currency),
                  childCount: accountDebts.length,
                ),
              );
            },
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
          transactions.when(
            data: (list) {
              final accountTrans = list.where((t) => t.accountId == accountId).toList();
              if (accountTrans.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildTransactionTile(context, ref, accountTrans[index], currency),
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

  Widget _buildHeader(BuildContext context, AccountEntity account, String currency) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.surfaceContainerHighest,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Text('إجمالي الرصيد التراكمي', 
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7))),
          const SizedBox(height: 8),
          Text(
            '${account.totalBalance.toStringAsFixed(2)} $currency',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: account.totalBalance >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(account.type.name), avatar: const Icon(Icons.category, size: 16)),
              if (account.phoneNumber != null) 
                Chip(label: Text(account.phoneNumber!), avatar: const Icon(Icons.phone, size: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebtTile(BuildContext context, WidgetRef ref, dynamic debt, String currency) {
    final isOwe = debt.debtType == 'owe';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOwe ? Colors.red.shade50 : Colors.green.shade50,
          child: Icon(isOwe ? Icons.arrow_upward : Icons.arrow_downward, color: isOwe ? Colors.red : Colors.green),
        ),
        title: Text('دين: ${debt.description ?? "بدون وصف"}'),
        subtitle: Text(DateFormat('yyyy/MM/dd').format(debt.createdAt)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${debt.totalAmount.toStringAsFixed(2)} $currency', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _confirmDeleteDebt(context, ref, debt.id),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionTile(BuildContext context, WidgetRef ref, dynamic trans, String currency) {
    final isExpense = trans.type.name == 'expense';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense ? Colors.orange.shade50 : Colors.blue.shade50,
          child: Icon(isExpense ? Icons.shopping_cart : Icons.add_card, 
              color: isExpense ? Colors.orange : Colors.blue),
        ),
        title: Text('مشتريات: ${trans.categoryName}'),
        subtitle: Text(DateFormat('yyyy/MM/dd').format(trans.date)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${trans.amount.toStringAsFixed(2)} $currency', 
                style: const TextStyle(fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _confirmDeleteTransaction(context, ref, trans.id),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAccount(BuildContext context, WidgetRef ref, AccountEntity account) {
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
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteDebt(BuildContext context, WidgetRef ref, int id) {
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
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTransaction(BuildContext context, WidgetRef ref, int id) {
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
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
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
