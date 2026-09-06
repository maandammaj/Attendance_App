import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../domain/entities/overtime_policy_entity.dart';

/// حقل أجر إضافي واحد: نوعه وقيمته.
///
/// النوع صريح بدل أن يُستنتج من حجم الرقم — القاعدة القديمة كانت تقلب معنى
/// القيمة عند تجاوزها 2 بلا أن يرى المستخدم الحدّ.
class OvertimeRateField extends StatelessWidget {
  const OvertimeRateField({
    super.key,
    required this.label,
    required this.helper,
    required this.controller,
    required this.kind,
    required this.onKindChanged,
    this.enabled = true,
  });

  final String label;
  final String helper;
  final TextEditingController controller;
  final OvertimeRateKind kind;
  final ValueChanged<OvertimeRateKind> onKindChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller,
                enabled: enabled,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: label,
                  helperText: helper,
                  helperMaxLines: 2,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<OvertimeRateKind>(
                initialValue: kind,
                decoration: const InputDecoration(labelText: 'طريقة الاحتساب'),
                items: [
                  for (final k in OvertimeRateKind.values)
                    DropdownMenuItem(value: k, child: Text(k.label)),
                ],
                onChanged: enabled
                    ? (value) => value == null ? null : onKindChanged(value)
                    : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
