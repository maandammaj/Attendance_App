import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/common/state_switcher.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/attendance/session_timeline.dart';
import '../../widgets/common/animated_entrance.dart';
import '../../widgets/common/empty_state.dart';
import 'edit_attendance_dialog.dart';

/// سجل الأيام السابقة، كل يوم قابل للطيّ ليكشف جلساته.
class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState
    extends ConsumerState<AttendanceHistoryScreen> {
  DateTime _month = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final records = ref.watch(
      monthlyAttendanceProvider(year: _month.year, month: _month.month),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الدوام'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _MonthSwitcher(
            month: _month,
            onChanged: (value) => setState(() => _month = value),
          ),
        ),
      ),
      body: records.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(children: [Skeleton(height: 84), Skeleton(height: 84), Skeleton(height: 84)]),
        ),
        error: (error, _) => Center(child: Text('تعذّر التحميل: $error')),
        data: (list) {
          if (list.isEmpty) {
            return const EmptyState(
              icon: Icons.event_busy_rounded,
              title: 'لا سجلات في هذا الشهر',
              message: 'سجّل حضورك أو أضف جلسة يدوياً لتظهر هنا.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 32),
            itemCount: list.length,
            itemBuilder: (context, index) => AnimatedEntrance(
              index: index,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(bottom: 10),
                child: _DayCard(record: list[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MonthSwitcher extends StatelessWidget {
  const _MonthSwitcher({required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_right),
            tooltip: 'الشهر السابق',
            onPressed: () =>
                onChanged(DateTime(month.year, month.month - 1, 1)),
          ),
          Expanded(
            child: Text(
              '${DateHelpers.arabicMonths[month.month - 1]} ${month.year}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            tooltip: 'الشهر التالي',
            onPressed: () =>
                onChanged(DateTime(month.year, month.month + 1, 1)),
          ),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({required this.record});

  final AttendanceEntity record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final overtime =
        (record.overtimeHours * 60) + record.overtimeMinutes;
    final deficit = (record.deficitHours * 60) + record.deficitMinutes;
    final worked = (record.workedHours * 60) + record.workedMinutes;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // ExpansionTile يرسم فواصل خاصة به لا تتبع سمة البطاقة.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding:
              const EdgeInsetsDirectional.fromSTEB(16, 4, 12, 4),
          childrenPadding:
              const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          leading: _DayBadge(record: record),
          title: Text(
            '${record.date.day} ${DateHelpers.getArabicDayName(record.date)}',
            style: theme.textTheme.titleSmall,
          ),
          subtitle: Text(
            record.isAbsent
                ? 'غياب'
                : '${record.sessionCount} جلسة  •  ${DateHelpers.formatDurationCompact(worked)}',
            style: theme.textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (overtime > 0)
                Text('+${DateHelpers.formatDurationCompact(overtime)}',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: palette.positive)),
              if (deficit > 0)
                Text('-${DateHelpers.formatDurationCompact(deficit)}',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: palette.negative)),
            ],
          ),
          children: [
            SessionTimeline(sessions: record.sessions),
            const Divider(),
            Row(
              children: [
                if (record.notes != null && record.notes!.isNotEmpty)
                  Expanded(
                    child: Text(record.notes!,
                        style: theme.textTheme.bodySmall),
                  )
                else
                  const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('تعديل'),
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => EditAttendanceDialog(record: record),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayBadge extends StatelessWidget {
  const _DayBadge({required this.record});

  final AttendanceEntity record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final (color, icon) = switch (record) {
      _ when record.isAbsent => (palette.negative, Icons.close_rounded),
      _ when record.isOpen => (palette.positive, Icons.play_arrow_rounded),
      _ when record.deficitHours + record.deficitMinutes > 0 =>
        (palette.warning, Icons.trending_down_rounded),
      _ when record.overtimeHours + record.overtimeMinutes > 0 =>
        (palette.positive, Icons.trending_up_rounded),
      _ => (theme.colorScheme.primary, Icons.check_rounded),
    };

    return CircleAvatar(
      backgroundColor: color.withValues(alpha: 0.14),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
