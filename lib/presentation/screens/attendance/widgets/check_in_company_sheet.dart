import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/constants/theme.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../domain/entities/company_entity.dart';
import '../../../providers/company_provider.dart';

/// يسأل: في أي جهة تبدأ دوامك؟
///
/// يظهر فقط حين توجد أكثر من جهة. الاعتماد على الجهة "الفعّالة" ضمناً كان
/// يكتب الساعات لجهة خاطئة إن نسي المستخدم التبديل — والخطأ لا يظهر إلا في
/// كشف الراتب بعد أسابيع.
class CheckInCompanySheet extends ConsumerWidget {
  const CheckInCompanySheet({super.key});

  /// يعيد الجهة المختارة، أو null إن أُلغي الاختيار.
  static Future<CompanyEntity?> pick(BuildContext context) {
    return showModalBottomSheet<CompanyEntity>(
      context: context,
      showDragHandle: true,
      builder: (context) => const CheckInCompanySheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final companies = (ref.watch(companiesProvider).valueOrNull ?? const [])
        .where((company) => !company.isArchived)
        .toList();
    final active = ref.watch(activeCompanyProvider).valueOrNull;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أين تبدأ دوامك؟', style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'الساعات والراتب تُحتسب على الجهة التي تختارها.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: palette.onSurfaceVariant),
                ),
              ],
            ),
          ),
          for (final company in companies)
            _Option(
              company: company,
              isActive: company.id == active?.id,
              onTap: () => Navigator.pop(context, company),
            ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
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

    // نافذة اليوم من جدول الجهة — تساعد على اختيار الصحيحة دون تفكير.
    final today = company.workSchedule
        .where((day) => day.dayOfWeek == DateHelpers.scheduleDayOf(DateTime.now()))
        .firstOrNull;
    final window = today == null || today.startTime == null
        ? 'لا وردية محددة اليوم'
        : 'اليوم ${today.startTime} — ${today.endTime}';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xs),
      leading: Container(
        width: 44,
        height: 44,
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
      title: Row(
        children: [
          Flexible(
            child: Text(company.name,
                style: theme.textTheme.bodyLarge,
                overflow: TextOverflow.ellipsis),
          ),
          if (isActive) ...[
            const SizedBox(width: AppSpacing.sm),
            Text('المعروضة',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: palette.onSurfaceVariant)),
          ],
        ],
      ),
      subtitle: Text(window, style: theme.textTheme.bodySmall),
      trailing: Text(
        '${company.baseMonthlySalary.toStringAsFixed(0)} ${company.currency ?? ''}',
        style: theme.textTheme.labelMedium
            ?.copyWith(color: palette.onSurfaceVariant)
            .merge(tabularFigures),
      ),
    );
  }
}
