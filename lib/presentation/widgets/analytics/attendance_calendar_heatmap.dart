import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/analytics_report_entity.dart';
import '../common/chart_empty.dart';

/// خريطة حرارية تقويمية بأسبوع يبدأ بالسبت.
///
/// شدة اللون تتبع نسبة الإنجاز مقابل المطلوب، فيقرأ المستخدم شهراً كاملاً
/// دفعة واحدة بدل تصفّح جدول.
class AttendanceCalendarHeatmap extends StatelessWidget {
  const AttendanceCalendarHeatmap({super.key, required this.cells});

  final List<CalendarDayCell> cells;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (cells.isEmpty) {
      return const ChartEmpty(
        message: 'لا أيام في هذه الفترة',
        icon: Icons.calendar_month_rounded,
        height: 100,
      );
    }

    // خانات فارغة قبل أول يوم حتى يقع كل يوم تحت عموده الصحيح.
    final leading = DateHelpers.arabicDayIndex(cells.first.date);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (final day in AppConstants.arabicDays)
              Expanded(
                child: Text(
                  day.substring(0, day.length > 3 ? 3 : day.length),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leading + cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            if (index < leading) return const SizedBox.shrink();
            return _DayTile(cell: cells[index - leading]);
          },
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            for (final status in const [
              DayStatus.worked,
              DayStatus.overtime,
              DayStatus.deficit,
              DayStatus.absent,
              DayStatus.dayOff,
            ])
              _LegendChip(status: status),
          ],
        ),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.cell});

  final CalendarDayCell cell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final base = statusColor(cell.status, theme, palette);
    // الأيام المنجزة تتدرج مع نسبة الإنجاز؛ البقية بلون ثابت.
    final opacity = cell.status == DayStatus.worked ||
            cell.status == DayStatus.overtime
        ? (0.28 + (cell.completion.clamp(0.0, 1.5) / 1.5) * 0.62)
        : 0.5;

    return Tooltip(
      message: _tooltip(cell),
      child: Container(
        decoration: BoxDecoration(
          color: base.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(6),
          border: cell.status == DayStatus.future
              ? Border.all(color: theme.dividerColor.withValues(alpha: 0.4))
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '${cell.date.day}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: cell.status == DayStatus.future
                ? theme.disabledColor
                : (opacity > 0.55 ? Colors.white : null),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  static String _tooltip(CalendarDayCell cell) {
    final date = DateHelpers.formatShortDate(cell.date);
    return switch (cell.status) {
      DayStatus.future => '$date — لم يحن بعد',
      DayStatus.dayOff => '$date — عطلة',
      DayStatus.absent => '$date — غياب',
      _ =>
        '$date\nالمنجز ${DateHelpers.formatDurationCompact(cell.workedMinutes)} من ${DateHelpers.formatDurationCompact(cell.requiredMinutes)}'
            '${cell.overtimeMinutes > 0 ? "\nإضافي ${DateHelpers.formatDurationCompact(cell.overtimeMinutes)}" : ""}'
            '${cell.deficitMinutes > 0 ? "\nعجز ${DateHelpers.formatDurationCompact(cell.deficitMinutes)}" : ""}',
    };
  }
}

Color statusColor(DayStatus status, ThemeData theme, AppPalette palette) {
  return switch (status) {
    DayStatus.worked => theme.colorScheme.primary,
    DayStatus.overtime => palette.positive,
    DayStatus.deficit => palette.warning,
    DayStatus.absent => theme.colorScheme.error,
    DayStatus.dayOff => theme.disabledColor,
    DayStatus.future => Colors.transparent,
  };
}

String statusLabel(DayStatus status) {
  return switch (status) {
    DayStatus.worked => 'مكتمل',
    DayStatus.overtime => 'إضافي',
    DayStatus.deficit => 'عجز',
    DayStatus.absent => 'غياب',
    DayStatus.dayOff => 'عطلة',
    DayStatus.future => 'قادم',
  };
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.status});

  final DayStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor(status, theme, palette).withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(statusLabel(status), style: theme.textTheme.bodySmall),
      ],
    );
  }
}
