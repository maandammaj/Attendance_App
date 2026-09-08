import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/routes.dart';
import '../../../../core/constants/design_tokens.dart';
import '../../../providers/company_provider.dart';

/// مدخل إلى دخل المستخدم من كل جهاته.
///
/// يظهر بجهتين فأكثر فقط: بجهة واحدة تكون اللوحة نفسها هي الإجمالي، فالرابط
/// يعد بشيء لا يضيف.
class AllWorkplacesLink extends ConsumerWidget {
  const AllWorkplacesLink({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(companiesProvider).value ?? const [];
    final active = companies.where((c) => !c.isArchived).length;
    if (active < 2) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.only(top: AppSpacing.lg),
      child: Card(
        margin: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () =>
              Navigator.pushNamed(context, AppRoutes.personalPayroll),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: palette.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.badge),
                  ),
                  child: Icon(Icons.account_balance_wallet_rounded,
                      color: palette.accent, size: AppIconSize.md),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('دخلك من كل الجهات',
                          style: theme.textTheme.titleSmall),
                      Text(
                        'هذه اللوحة تعرض جهة واحدة — اطّلع على مجموع $active جهات',
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: palette.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left_rounded,
                    color: palette.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
