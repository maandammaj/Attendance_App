import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/debt_entity.dart';
import '../../providers/debt_provider.dart';
import '../../providers/account_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/app_button.dart';

class AddDebtBottomSheet extends ConsumerStatefulWidget {
  const AddDebtBottomSheet({super.key});

  @override
  ConsumerState<AddDebtBottomSheet> createState() => _AddDebtBottomSheetState();
}

class _AddDebtBottomSheetState extends ConsumerState<AddDebtBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  String _debtType = 'owe';
  int? _selectedAccountId;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(allAccountsProvider);
    final debtState = ref.watch(debtControllerProvider);
    final currency = ref.watch(profileProvider).valueOrNull?.currency ?? 'ر.ي';

    // الاستماع لحالة الحفظ والتعامل مع النجاح أو الفشل
    ref.listen<AsyncValue<void>>(
      debtControllerProvider,
          (previous, next) {
        next.whenOrNull(
          data: (_) {
            if (context.mounted) {
              Navigator.pop(context);
              UIHelpers.showSuccessSnackBar(context, 'تم إضافة الدين بنجاح');
            }
          },
          error: (error, _) {
            if (context.mounted) {
              UIHelpers.showErrorSnackBar(context, 'فشل الإضافة: $error');
            }
          },
        );
      },
    );

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, // دفع النافذة فوق الكيبورد
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(
                      value: 'owe',
                      label: Text('عليك'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                    ButtonSegment(
                      value: 'owed',
                      label: Text('لك'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                  ],
                  selected: {_debtType},
                  onSelectionChanged: (set) => setState(() => _debtType = set.first),
                  style: SegmentedButton.styleFrom(
                    selectedBackgroundColor: _debtType == 'owe' ? Colors.red.shade100 : Colors.green.shade100,
                    selectedForegroundColor: _debtType == 'owe' ? Colors.red.shade900 : Colors.green.shade900,
                  ),
                ),
                const SizedBox(height: 24),
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
                    onChanged: (v) {
                      setState(() => _selectedAccountId = v);
                      if (v != null) {
                        final acc = accounts.firstWhere((a) => a.id == v);
                        _nameController.text = acc.name;
                      }
                    },
                  ),
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'الاسم / الجهة',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'الرجاء إدخال الاسم' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: 'المبلغ الإجمالي',
                    prefixIcon: const Icon(Icons.attach_money_outlined),
                    suffixText: currency,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => (v == null || double.tryParse(v) == null) ? 'الرجاء إدخال مبلغ صحيح' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف / التفاصيل',
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'حفظ الدين',
                  icon: Icons.save_rounded,
                  isLoading: debtState.isLoading,
                  backgroundColor: _debtType == 'owe' ? Colors.red.shade700 : Colors.blue.shade700,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final amount = double.parse(_amountController.text);
                      final debt = DebtEntity(
                        id: 0,
                        debtType: _debtType,
                        personName: _nameController.text.trim(),
                        accountId: _selectedAccountId,
                        totalAmount: amount,
                        paidAmount: 0,
                        remainingAmount: amount,
                        createdAt: DateTime.now(),
                        description: _descController.text.trim(),
                        status: 'active',
                        paymentHistory: [],
                      );

                      ref.read(debtControllerProvider.notifier).addDebt(debt);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}