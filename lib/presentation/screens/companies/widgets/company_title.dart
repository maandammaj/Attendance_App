import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/ui_helpers.dart';
import '../../../providers/company_provider.dart';
import '../company_switcher_sheet.dart';

/// عنوان شريط التطبيق: اسم الجهة الفعّالة، ونقره يفتح المبدّل.
///
/// يظهر السهم فقط حين توجد أكثر من جهة — بجهة واحدة لا شيء يُبدَّل إليه،
/// والسهم حينها يعد بما لا يحدث.
class CompanyTitle extends ConsumerWidget {
  const CompanyTitle({super.key, required this.fallback});

  final String fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final company = ref.watch(activeCompanyProvider).value;
    final count =
        (ref.watch(companiesProvider).value ?? const []).length;

    if (company == null) return Text(fallback);

    final canSwitch = count > 1;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: canSwitch
          ? () => UIHelpers.showModernBottomSheet(
                context: context,
                title: 'جهات العمل',
                child: const CompanySwitcherSheet(),
              )
          : null,
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                company.name,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge,
              ),
            ),
            if (canSwitch) ...[
              const SizedBox(width: AppSpacing.xs),
              Icon(Icons.expand_more_rounded,
                  size: AppIconSize.md, color: palette.onSurfaceVariant),
            ],
          ],
        ),
      ),
    );
  }
}
