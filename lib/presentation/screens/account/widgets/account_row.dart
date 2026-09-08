import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../../domain/entities/account_entity.dart';
import 'account_type_style.dart';

/// صف حساب واحد. الحذف بالسحب لا بزر في الطرف — الزر كان يزاحم الرصيد
/// على أضيق جزء من الصف ولا يبلغ حدّ اللمس 48.
class AccountRow extends StatelessWidget {
  const AccountRow({
    super.key,
    required this.account,
    required this.currency,
    required this.onTap,
    required this.onDelete,
  });

  final AccountEntity account;
  final String currency;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isPositive = account.totalBalance >= 0;
    final typeColor = account.type.color(palette);

    return Dismissible(
      key: ValueKey(account.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        onDelete();
        // الحذف يمرّ بحوار تأكيد ثم يُبطل المزوّد القائمة، فلا نُزيل الصف هنا.
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
        child: Material(
          color: palette.surface,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: palette.outline),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(AppRadius.field),
                    ),
                    child: Icon(account.type.icon,
                        color: typeColor, size: AppIconSize.md),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          account.name,
                          style: theme.textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          account.type.arabicLabel,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: palette.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${account.totalBalance.toStringAsFixed(0)} $currency',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(
                          color:
                              isPositive ? palette.positive : palette.negative,
                        )
                        .merge(tabularFigures),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
