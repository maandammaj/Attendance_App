import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/calendar_day_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/common/state_switcher.dart';

/// تقويم العمل: أيام تخالف الجدول الأسبوعي في تاريخ بعينه.
class WorkCalendarScreen extends ConsumerWidget {
  const WorkCalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final daysAsync =
        ref.watch(monthCalendarProvider(year: now.year, month: now.month));

    return Scaffold(
      appBar: AppBar(
        title: const Text('تقويم العمل'),
        centerTitle: true,
      ),
      // حالة الفراغ تحمل الإجراء نفسه، فإظهار الزر معها يكرّره على شاشة واحدة.
      floatingActionButton: (daysAsync.value?.isEmpty ?? true)
          ? null
          : FloatingActionButton.extended(
              heroTag: 'add_calendar_day',
              onPressed: () => _markDay(context, ref),
              icon: const Icon(Icons.event_available_rounded),
              label: const Text('تعليم يوم'),
            ),
      body: StateSwitcher(
        value: daysAsync,
        skeletonHeight: 120,
        onRetry: () => ref.invalidate(monthCalendarProvider),
        builder: (days) {
          if (days.isEmpty) {
            return EmptyState(
              icon: Icons.event_note_rounded,
              title: 'لا أيام مُعلَّمة',
              message:
                  'علّم عطلة أو دواماً استثنائياً ليُحسب هذا اليوم بخلاف جدولك '
                  'الأسبوعي.',
              actionLabel: 'تعليم يوم',
              onAction: () => _markDay(context, ref),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 96),
            itemCount: days.length,
            itemBuilder: (context, index) => _DayTile(
              day: days[index],
              onDelete: () => _unmark(context, ref, days[index]),
            ),
          );
        },
      ),
    );
  }

  Future<void> _markDay(BuildContext context, WidgetRef ref) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (date == null || !context.mounted) return;

    final choice = await showModalBottomSheet<_MarkChoice>(
      context: context,
      builder: (_) => const _KindSheet(),
    );
    if (choice == null || !context.mounted) return;

    try {
      await ref.read(calendarRepositoryProvider).mark(
            date: date,
            kind: choice.kind,
            appliesToAllCompanies: choice.appliesToAll,
          );
      ref.invalidate(monthCalendarProvider);
      ref.invalidate(attendanceStatsProvider);
      if (context.mounted) {
        UIHelpers.showSuccessSnackBar(context, 'عُلِّم ${DateHelpers.formatShortDate(date)}');
      }
    } catch (error) {
      if (context.mounted) {
        UIHelpers.showErrorSnackBar(context, 'تعذّر التعليم: $error');
      }
    }
  }

  Future<void> _unmark(
      BuildContext context, WidgetRef ref, CalendarDayEntity day) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إزالة التعليم'),
        content: Text(
            'سيعود ${DateHelpers.formatShortDate(day.date)} إلى جدولك الأسبوعي.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('إلغاء')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('إزالة')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(calendarRepositoryProvider).unmark(day.id);
      ref.invalidate(monthCalendarProvider);
      ref.invalidate(attendanceStatsProvider);
    } catch (error) {
      if (context.mounted) {
        UIHelpers.showErrorSnackBar(context, '$error');
      }
    }
  }
}

class _DayTile extends StatelessWidget {
  const _DayTile({required this.day, required this.onDelete});

  final CalendarDayEntity day;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final isOff = day.kind.isOff;

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              (isOff ? palette.warning : palette.info).withValues(alpha: 0.12),
          child: Icon(
            isOff ? Icons.beach_access_rounded : Icons.work_history_rounded,
            color: isOff ? palette.warning : palette.info,
            size: AppIconSize.md,
          ),
        ),
        title: Text(DateHelpers.formatShortDate(day.date)),
        subtitle: Text(
          day.isWorkplaceSpecific
              ? day.kind.label
              : '${day.kind.label} — كل الجهات',
          style: theme.textTheme.bodySmall,
        ),
        trailing: IconButton(
          tooltip: 'إزالة',
          icon: Icon(Icons.close_rounded,
              color: palette.onSurfaceVariant, size: AppIconSize.md),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class _MarkChoice {
  const _MarkChoice(this.kind, this.appliesToAll);

  final CalendarDayKindEntity kind;
  final bool appliesToAll;
}

class _KindSheet extends StatefulWidget {
  const _KindSheet();

  @override
  State<_KindSheet> createState() => _KindSheetState();
}

class _KindSheetState extends State<_KindSheet> {
  bool _appliesToAll = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final kind in CalendarDayKindEntity.values)
              ListTile(
                title: Text(kind.label),
                onTap: () =>
                    Navigator.pop(context, _MarkChoice(kind, _appliesToAll)),
              ),
            const Divider(),
            SwitchListTile(
              value: _appliesToAll,
              title: const Text('يسري على كل جهات العمل'),
              subtitle: const Text('عيد وطني يُعلَّم مرّة لا مرّة لكل جهة'),
              onChanged: (v) => setState(() => _appliesToAll = v),
            ),
          ],
        ),
      ),
    );
  }
}
