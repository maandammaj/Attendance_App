import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/account_entity.dart';
import '../../providers/account_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';
import '../../widgets/common/above_nav_fab_location.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/state_switcher.dart';
import 'account_details_screen.dart';
import 'widgets/account_row.dart';
import 'widgets/account_type_selector.dart';
import 'widgets/accounts_summary_card.dart';

/// دفتر الحسابات: الموقف العام أولاً، ثم الحسابات التي كوّنته.
class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(allAccountsProvider);
    final currency = ref.watch(profileProvider).value?.currency ??
        AppConstants.defaultCurrency;

    return Scaffold(
      appBar: AppBar(title: const Text('الحسابات'), centerTitle: true),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(allAccountsProvider),
        child: StateSwitcher<List<AccountEntity>>(
          value: accounts,
          skeletonHeight: 132,
          onRetry: () => ref.invalidate(allAccountsProvider),
          builder: (list) => list.isEmpty
              ? EmptyState(
                  icon: Icons.account_balance_rounded,
                  title: 'لا حسابات بعد',
                  message: 'أضف حساباً لتربط به دخلك ومصروفاتك وتتابع رصيده.',
                  actionLabel: 'إضافة حساب',
                  onAction: () => _openAddSheet(context),
                )
              : _Body(accounts: list, currency: currency),
        ),
      ),
      floatingActionButtonLocation: aboveNavFabLocation,
      // حالة الفراغ تحمل الإجراء نفسه، فإظهار الزر معها يكرّره مرّتين على
      // شاشة واحدة بلا مقابل.
      floatingActionButton: (accounts.value?.isEmpty ?? true)
          ? null
          : FloatingActionButton.extended(
              heroTag: 'accounts_fab',
              onPressed: () => _openAddSheet(context),
              icon: const Icon(Icons.add_rounded),
              label: const Text('حساب جديد'),
            ),
    );
  }

  static void _openAddSheet(BuildContext context) =>
      UIHelpers.showModernBottomSheet(
        context: context,
        title: 'إضافة حساب جديد',
        child: const _AddAccountBottomSheet(),
      );
}

class _Body extends ConsumerWidget {
  const _Body({required this.accounts, required this.currency});

  final List<AccountEntity> accounts;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.screen,
        AppSpacing.sm,
        AppSpacing.screen,
        context.navBarFabClearance,
      ),
      children: [
        AccountsSummaryCard(accounts: accounts, currency: currency),
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'الحسابات',
          subtitle: '${accounts.length} حساب — اسحب للحذف',
        ),
        for (final account in accounts)
          AccountRow(
            account: account,
            currency: currency,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => AccountDetailsScreen(accountId: account.id),
              ),
            ),
            onDelete: () => _confirmDelete(context, ref, account),
          ),
      ],
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, AccountEntity account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب'),
        content: Text('سيُحذف حساب «${account.name}» نهائياً.'),
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
    await ref.read(accountControllerProvider.notifier).deleteAccount(account.id);
    if (!context.mounted) return;
    UIHelpers.showSuccessSnackBar(context, 'تم حذف الحساب');
  }
}

class _AddAccountBottomSheet extends ConsumerStatefulWidget {
  const _AddAccountBottomSheet();

  @override
  ConsumerState<_AddAccountBottomSheet> createState() =>
      _AddAccountBottomSheetState();
}

class _AddAccountBottomSheetState
    extends ConsumerState<_AddAccountBottomSheet> {
  final _nameController = TextEditingController();
  AccountTypeEntity _type = AccountTypeEntity.supplier;

  @override
  void dispose() {
    _nameController.dispose();
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
          controller: _nameController,
          autofocus: true,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'اسم الحساب (الشخص أو الجهة)',
            prefixIcon: Icon(Icons.account_box_outlined),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AccountTypeSelector(
          selected: _type,
          onChanged: (type) => setState(() => _type = type),
        ),
        const SizedBox(height: AppSpacing.xxl),
        AppButton(
          label: 'إنشاء الحساب',
          icon: Icons.add_business_outlined,
          isLoading: accountState is AsyncLoading,
          onPressed: _submit,
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      UIHelpers.showErrorSnackBar(context, 'أدخل اسم الحساب أولاً');
      return;
    }

    final now = DateTime.now();
    await ref.read(accountControllerProvider.notifier).saveAccount(
          AccountEntity(
            id: 0,
            name: name,
            type: _type,
            totalBalance: 0,
            createdAt: now,
            updatedAt: now,
          ),
        );

    if (!mounted) return;
    final state = ref.read(accountControllerProvider);
    if (state is AsyncError) {
      UIHelpers.showErrorSnackBar(context, 'فشل الإضافة: ${state.error}');
      return;
    }
    Navigator.pop(context);
    UIHelpers.showSuccessSnackBar(context, 'تم إضافة الحساب بنجاح');
  }
}
