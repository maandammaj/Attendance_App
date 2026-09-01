import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/routes.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';
import '../../../domain/entities/company_entity.dart';
import '../../providers/company_provider.dart';

/// ورقة التبديل السريع بين جهات العمل.
///
/// التبديل يغيّر كل رقم في التطبيق، فالورقة تعرض ما يميّز كل جهة — الراتب
/// وساعات الأسبوع — حتى لا يُبدَّل بالاسم وحده.
class CompanySwitcherSheet extends ConsumerWidget {
  const CompanySwitcherSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final companies = ref.watch(companiesProvider).valueOrNull ?? const [];
    final active = ref.watch(activeCompanyProvider).valueOrNull;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final company in companies.where((c) => !c.isArchived))
          _CompanyTile(
            company: company,
            isActive: company.id == active?.id,
            onTap: () async {
              Navigator.pop(context);
              if (company.id == active?.id) return;
              await ref
                  .read(companyControllerProvider.notifier)
                  .switchTo(company.id);
            },
          ),
        const SizedBox(height: AppSpacing.sm),
        const Divider(height: 1),
        ListTile(
          leading: Icon(Icons.add_business_outlined, color: palette.primary),
          title: Text('إضافة جهة عمل', style: theme.textTheme.bodyLarge),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.companyEditor);
          },
        ),
        ListTile(
          leading: const Icon(Icons.tune_rounded),
          title: Text('إدارة الجهات', style: theme.textTheme.bodyLarge),
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, AppRoutes.companies);
          },
        ),
      ],
    );
  }
}

class _CompanyTile extends StatelessWidget {
  const _CompanyTile({
    required this.company,
    required this.isActive,
    required this.onTap,
  });

  final CompanyEntity company;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final color =
        palette.categorical[company.colorIndex % palette.categorical.length];

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        child: Text(
          company.name.characters.first,
          style: theme.textTheme.titleMedium?.copyWith(color: color),
        ),
      ),
      title: Text(company.name, style: theme.textTheme.bodyLarge),
      subtitle: Text(
        '${company.jobTitle} · ${company.weeklyHours.toStringAsFixed(0)} ساعة/أسبوع',
        style: theme.textTheme.bodySmall,
      ),
      trailing: isActive
          ? Icon(Icons.check_circle_rounded, color: palette.primary)
          : Text(
              '${company.baseMonthlySalary.toStringAsFixed(0)} ${company.currency ?? ''}',
              style: theme.textTheme.labelMedium
                  ?.copyWith(color: palette.onSurfaceVariant)
                  .merge(tabularFigures),
            ),
    );
  }
}
