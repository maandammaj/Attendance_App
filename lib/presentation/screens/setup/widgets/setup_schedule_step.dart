import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/date_helpers.dart';
import '../../../../domain/entities/profile_entity.dart';
import '../../schedule/widgets/schedule_presets.dart';
import 'setup_step_header.dart';

/// اختيار قالب دوام. الضبط التفصيلي متاح لاحقاً في شاشة جدول الدوام،
/// فالإعداد الأول يبقى قصيراً.
class SetupScheduleStep extends StatelessWidget {
  const SetupScheduleStep({
    super.key,
    required this.schedule,
    required this.weekOrder,
    required this.onChanged,
  });

  final List<WorkDayConfigEntity> schedule;
  final List<int> weekOrder;
  final ValueChanged<List<WorkDayConfigEntity>> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    final active =
        schedule.where((day) => day.isWorkingDay && !day.isHoliday).toList();
    final weeklyMinutes =
        active.fold(0, (sum, day) => sum + day.requiredMinutesTotal);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      children: [
        const SetupStepHeader(
          icon: Icons.event_note_rounded,
          title: 'متى تداوم؟',
          subtitle: 'اختر ما يقارب دوامك — يمكنك ضبط كل يوم لاحقاً.',
        ),
        for (final preset in SchedulePreset.all)
          _PresetOption(
            preset: preset,
            isSelected: _matches(preset),
            onTap: () => onChanged(preset.build(weekOrder)),
          ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: palette.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${active.length} أيام عمل — '
                  '${(weeklyMinutes / 60).toStringAsFixed(1)} ساعة أسبوعياً',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                '${((weeklyMinutes / 60) * 4.33).toStringAsFixed(0)} ساعة/شهر',
                style: theme.textTheme.titleSmall
                    ?.copyWith(color: palette.primary),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final day in active)
              Chip(
                label: Text(
                    DateHelpers.arabicDayNameOfScheduleDay(day.dayOfWeek)),
                visualDensity: VisualDensity.compact,
              ),
          ],
        ),
      ],
    );
  }

  /// القالب مُختار حين تطابق أيام عطلته وتوقيته ما هو معروض.
  bool _matches(SchedulePreset preset) {
    final offDays = schedule
        .where((day) => !day.isWorkingDay || day.isHoliday)
        .map((day) => day.dayOfWeek)
        .toSet();
    if (!setEquals(offDays, preset.offDays)) return false;

    final working = schedule.firstWhere(
      (day) => day.isWorkingDay && !day.isHoliday,
      orElse: () => schedule.first,
    );
    return working.startTime == preset.startTime &&
        working.endTime == preset.endTime;
  }

  static bool setEquals(Set<int> a, Set<int> b) =>
      a.length == b.length && a.containsAll(b);
}

class _PresetOption extends StatelessWidget {
  const _PresetOption({
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final SchedulePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      child: Material(
        color: isSelected
            ? palette.primary.withValues(alpha: 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.field),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.field),
          child: AnimatedContainer(
            duration: AppDurations.fast,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.field),
              border: Border.all(
                color: isSelected ? palette.primary : palette.outline,
                width: isSelected ? 1.6 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(preset.icon,
                    color: isSelected ? palette.primary : palette.onSurfaceVariant,
                    size: AppIconSize.lg),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(preset.name, style: theme.textTheme.titleSmall),
                      Text(preset.description,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: palette.onSurfaceVariant)),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle_rounded,
                      color: palette.primary, size: AppIconSize.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
