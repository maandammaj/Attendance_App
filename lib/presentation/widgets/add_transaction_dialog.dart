import 'package:flutter/material.dart';
import '../../core/constants/design_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../../core/utils/ui_helpers.dart';
import '../providers/transaction_provider.dart';
import '../providers/account_provider.dart';
import '../providers/profile_provider.dart';
import 'app_button.dart';

class AddTransactionDialog extends ConsumerStatefulWidget {
  final TransactionTypeEntity type;

  const AddTransactionDialog({super.key, required this.type});

  @override
  ConsumerState<AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends ConsumerState<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  int? _selectedAccountId;

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final accountsAsync = ref.watch(allAccountsProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final isExpense = widget.type == TransactionTypeEntity.expense;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _amountController,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'المبلغ',
              prefixIcon: const Icon(Icons.attach_money),
              suffixText: ref.watch(profileProvider).valueOrNull?.currency ?? 'ر.ي',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) => (v == null || double.tryParse(v) == null) ? 'الرجاء إدخال مبلغ صحيح' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'التصنيف',
              prefixIcon: Icon(Icons.category_outlined),
              hintText: 'طعام، وقود، إيجار...',
            ),
            validator: (v) => (v == null || v.isEmpty) ? 'الرجاء إدخال التصنيف' : null,
          ),
          const SizedBox(height: 16),
          accountsAsync.when(
            data: (accounts) => DropdownButtonFormField<int>(
              value: _selectedAccountId,
              decoration: const InputDecoration(
                labelText: 'ربط بحساب (اختياري)',
                prefixIcon: Icon(Icons.account_balance_outlined),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('بدون حساب')),
                ...accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))),
              ],
              onChanged: (v) => setState(() => _selectedAccountId = v),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              labelText: 'ملاحظات إضافية',
              prefixIcon: Icon(Icons.note_alt_outlined),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 32),
          AppButton(
            label: isExpense ? 'إضافة مصروف' : 'إضافة دخل',
            icon: isExpense ? Icons.remove_circle_outline : Icons.add_circle_outline,
            backgroundColor: isExpense ? palette.negative : palette.positive,
            isLoading: transactionState is AsyncLoading,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final amount = double.parse(_amountController.text);
                final trans = TransactionEntity(
                  id: 0,
                  amount: amount,
                  date: DateTime.now(),
                  categoryName: _categoryController.text.trim(),
                  categoryId: 0,
                  accountId: _selectedAccountId,
                  note: _noteController.text.trim(),
                  type: widget.type,
                );
                
                await ref.read(transactionControllerProvider.notifier).addTransaction(trans);
                
                if (mounted) {
                  final state = ref.read(transactionControllerProvider);
                  if (state is! AsyncError) {
                    Navigator.pop(context);
                    UIHelpers.showSuccessSnackBar(context, 'تمت الإضافة بنجاح');
                  } else {
                    UIHelpers.showErrorSnackBar(context, 'حدث خطأ أثناء الإضافة');
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
