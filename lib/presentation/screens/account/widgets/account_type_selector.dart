import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../domain/entities/account_entity.dart';
import 'account_type_style.dart';

/// اختيار تصنيف الحساب.
///
/// شرائح لا قائمة منسدلة: أربع قيم ثابتة تُقرأ كلها دفعة واحدة، والمنسدلة
/// كانت تُخفيها خلف نقرة وتعرض أسماءها الإنجليزية.
class AccountTypeSelector extends StatelessWidget {
  const AccountTypeSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final AccountTypeEntity selected;
  final ValueChanged<AccountTypeEntity> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تصنيف الحساب', style: theme.textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final type in AccountTypeEntity.values)
              ChoiceChip(
                selected: selected == type,
                onSelected: (_) => onChanged(type),
                // بلا علامة صحّ: مادّة ترسمها *فوق* الأيقونة لا بدلاً منها،
                // فيتراكب الرمزان. التحديد تحمله تعبئة اللون وحدّه.
                showCheckmark: false,
                selectedColor: type.color(palette).withValues(alpha: 0.18),
                side: BorderSide(
                  color: selected == type
                      ? type.color(palette)
                      : palette.outline,
                ),
                avatar: Icon(
                  type.icon,
                  size: AppIconSize.sm,
                  color: type.color(palette),
                ),
                label: Text(type.arabicLabel),
              ),
          ],
        ),
      ],
    );
  }
}
