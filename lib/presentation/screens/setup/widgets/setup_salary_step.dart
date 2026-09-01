import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import 'setup_step_header.dart';

class SetupSalaryStep extends StatelessWidget {
  const SetupSalaryStep({
    super.key,
    required this.formKey,
    required this.baseSalary,
    required this.hourlyRate,
    required this.overtimeRate,
    required this.currency,
    required this.onCurrencyChanged,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController baseSalary;
  final TextEditingController hourlyRate;
  final TextEditingController overtimeRate;
  final String currency;
  final ValueChanged<String> onCurrencyChanged;

  static const _currencies = ['ر.ي', 'ر.س', 'د.إ', 'ج.م', 'USD'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SetupStepHeader(
            icon: Icons.payments_outlined,
            title: 'كم راتبك؟',
            subtitle: 'منه يُشتقّ أجر الساعة، وعليه تُحسب قيمة الإضافي والعجز.',
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: baseSalary,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'الراتب الشهري الأساسي',
                  ),
                  validator: (value) {
                    final amount = double.tryParse(value?.trim() ?? '');
                    if (amount == null || amount <= 0) {
                      return 'أدخل مبلغاً صحيحاً';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: currency,
                  decoration: const InputDecoration(labelText: 'العملة'),
                  items: [
                    for (final code in _currencies)
                      DropdownMenuItem(value: code, child: Text(code)),
                  ],
                  onChanged: (value) =>
                      value == null ? null : onCurrencyChanged(value),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: hourlyRate,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'أجر الساعة (اختياري)',
              helperText: 'اتركه فارغاً ليُحسب من الراتب وجدول دوامك',
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: overtimeRate,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'معامل الساعة الإضافية',
              helperText: '1.5 يعني ساعة ونصف أجراً لكل ساعة إضافية',
            ),
            validator: (value) {
              final rate = double.tryParse(value?.trim() ?? '');
              if (rate == null || rate <= 0) return 'أدخل معاملاً صحيحاً';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: palette.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppRadius.field),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: AppIconSize.sm, color: palette.info),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'قيمة أكبر من 2 تُعامَل كأجر مطلق للساعة الإضافية، لا كمعامل.',
                    style: theme.textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
