import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../widgets/app_button.dart';
import '../../../domain/entities/account_entity.dart';
import '../../providers/account_provider.dart';
import '../../providers/profile_provider.dart';
import 'account_details_screen.dart';

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(allAccountsProvider);
    final currency = ref.watch(profileProvider).valueOrNull?.currency ?? 'ر.ي';

    return Scaffold(
      appBar: AppBar(
        title: const Text('الحسابات'),
        centerTitle: true,
      ),
      body: accounts.when(
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('لا توجد حسابات مضافة'));
          }
          return ListView.builder(
            itemCount: list.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final account = list[index];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.account_balance)),
                  title: Text(account.name),
                  subtitle: Text(account.type.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${account.totalBalance.toStringAsFixed(2)} $currency',
                        style: TextStyle(
                          color: account.totalBalance >= 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey, size: 20),
                        onPressed: () => _confirmDelete(context, ref, account),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AccountDetailsScreen(accountId: account.id)),
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('خطأ: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'accounts_fab',
        onPressed: () => UIHelpers.showModernBottomSheet(
          context: context,
          title: 'إضافة حساب جديد',
          child: const _AddAccountBottomSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, AccountEntity account) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: Text('هل أنت متأكد من حذف الحساب "${account.name}"؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              await ref.read(accountControllerProvider.notifier).deleteAccount(account.id);
              if (ctx.mounted) Navigator.pop(ctx);
              if (context.mounted) UIHelpers.showSuccessSnackBar(context, 'تم حذف الحساب');
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _AddAccountBottomSheet extends ConsumerStatefulWidget {
  const _AddAccountBottomSheet();

  @override
  ConsumerState<_AddAccountBottomSheet> createState() => _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState extends ConsumerState<_AddAccountBottomSheet> {
  final nameCtl = TextEditingController();
  AccountTypeEntity type = AccountTypeEntity.supplier;

  @override
  void dispose() {
    nameCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountState = ref.watch(accountControllerProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: nameCtl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'اسم الحساب (الشخص أو الجهة)',
            prefixIcon: Icon(Icons.account_box_outlined),
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<AccountTypeEntity>(
          value: type,
          decoration: const InputDecoration(
            labelText: 'تصنيف الحساب',
            prefixIcon: Icon(Icons.category_outlined),
          ),
          items: AccountTypeEntity.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
              .toList(),
          onChanged: (v) => setState(() => type = v!),
        ),
        const SizedBox(height: 32),
        AppButton(
          label: 'إنشاء الحساب',
          icon: Icons.add_business_outlined,
          isLoading: accountState is AsyncLoading,
          onPressed: () async {
            final name = nameCtl.text.trim();
            if (name.isNotEmpty) {
              final now = DateTime.now();
              final acc = AccountEntity(
                id: 0,
                name: name,
                type: type,
                totalBalance: 0,
                createdAt: now,
                updatedAt: now,
              );
              await ref.read(accountControllerProvider.notifier).saveAccount(acc);
              
              if (mounted) {
                final state = ref.read(accountControllerProvider);
                if (state is! AsyncError) {
                  Navigator.pop(context);
                  UIHelpers.showSuccessSnackBar(context, 'تم إضافة الحساب بنجاح');
                } else {
                  UIHelpers.showErrorSnackBar(context, 'فشل الإضافة: ${state.error}');
                }
              }
            }
          },
        ),
      ],
    );
  }
}
