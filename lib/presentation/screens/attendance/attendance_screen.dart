import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/common/state_switcher.dart';
import '../../../config/routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/design_tokens.dart';
import '../../../core/constants/theme.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/usecases/attendance/get_monthly_stats_usecase.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/attendance/live_session_card.dart';
import '../../widgets/attendance/session_timeline.dart';
import '../../widgets/common/section_header.dart';
import '../companies/widgets/company_title.dart';
import 'manual_attendance_dialog.dart';
import 'widgets/quick_action_row.dart';
import 'widgets/today_sessions_card.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final today = ref.watch(todayAttendanceProvider);
    final stats =
        ref.watch(attendanceStatsProvider(year: now.year, month: now.month));
    final currency = ref.watch(profileProvider).value?.currency ??
        AppConstants.defaultCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const CompanyTitle(fallback: 'الدوام'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            tooltip: 'التقارير والتحليلات',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.analytics),
          ),
          IconButton(
            icon: const Icon(Icons.table_chart_outlined),
            tooltip: 'التقرير الشهري',
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.monthlyReport),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayAttendanceProvider);
          ref.invalidate(attendanceStatsProvider);
        },
        child: ListView(
          // 140 كانت أقصر من الشريط وزر الحضور معاً، فكان الزر يجلس
          // فوق بطاقة ملخّص الشهر ويحجب رقم الصافي.
          padding: const EdgeInsetsDirectional.fromSTEB(
              16, 8, 16, AppSpacing.bottomFabInset + AppSpacing.lg),
          children: [
            const LiveSessionCard(),
            const SizedBox(height: 20),
            QuickActionRow(
              onManualEntry: () => UIHelpers.showModernBottomSheet(
                context: context,
                title: 'إضافة جلسة يدوياً',
                child: const ManualAttendanceDialog(),
              ),
              onHistory: () =>
                  Navigator.pushNamed(context, AppRoutes.attendanceHistory),
              onReminders: () =>
                  Navigator.pushNamed(context, AppRoutes.reminders),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'جلسات اليوم',
              subtitle: DateHelpers.formatShortDate(now),
            ),
            today.when(
              data: (record) => TodaySessionsCard(
                child: SessionTimeline(sessions: record?.sessions ?? const []),
              ),
              loading: () => const Skeleton(height: 120),
              error: (error, _) => _ErrorCard(message: '$error'),
            ),
            const SizedBox(height: 24),
            SectionHeader(
              title: 'ملخص الشهر',
              subtitle: DateHelpers.arabicMonths[now.month - 1],
              actionLabel: 'التفاصيل',
              onAction: () => Navigator.pushNamed(context, AppRoutes.analytics),
            ),
            stats.when(
              data: (data) => _MonthSummary(stats: data, currency: currency),
              loading: () => const Skeleton(height: 160),
              error: (error, _) => _ErrorCard(message: '$error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthSummary extends StatelessWidget {
  const _MonthSummary({required this.stats, required this.currency});

  final MonthlyStats stats;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final net = stats.netExtraValue;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _Cell(
                  label: 'أيام الحضور',
                  value: '${stats.actualWorkingDays}',
                  hint: 'من ${stats.expectedWorkingDays}',
                  color: theme.colorScheme.primary,
                ),
                _Cell(
                  label: 'الإضافي',
                  value: stats.totalOvertimeHours.toStringAsFixed(1),
                  hint: 'ساعة',
                  color: palette.positive,
                ),
                _Cell(
                  label: 'العجز',
                  value: (stats.totalLatenessHours + stats.totalAbsenceHours)
                      .toStringAsFixed(1),
                  hint: 'ساعة',
                  color: palette.negative,
                ),
              ],
            ),
            const Divider(height: 28),
            Row(
              children: [
                Expanded(
                  child: Text('صافي الإضافي بعد الخصم',
                      style: theme.textTheme.bodyMedium),
                ),
                Text(
                  '${net >= 0 ? '+' : ''}${net.toStringAsFixed(0)} $currency',
                  style: theme.textTheme.headlineSmall
                      ?.copyWith(
                        color: net >= 0 ? palette.accent : palette.negative,
                      )
                      .merge(tabularFigures),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({
    required this.label,
    required this.value,
    required this.hint,
    required this.color,
  });

  final String label;
  final String value;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value,
                style: theme.textTheme.headlineSmall?.copyWith(color: color)),
          ),
          Text(hint, style: theme.textTheme.labelSmall),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.error)),
            ),
          ],
        ),
      ),
    );
  }
}
