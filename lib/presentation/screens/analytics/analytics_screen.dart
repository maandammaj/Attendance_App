import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../domain/entities/analytics_report_entity.dart';
import '../../providers/analytics_provider.dart';
import '../../widgets/analytics/analytics_card.dart';
import '../../widgets/analytics/attendance_calendar_heatmap.dart';
import '../../widgets/analytics/cash_flow_line_chart.dart';
import '../../widgets/analytics/category_pie_chart.dart';
import '../../widgets/analytics/hours_bar_chart.dart';
import '../../widgets/analytics/metric_tile.dart';
import '../../widgets/analytics/period_selector.dart';
import '../../widgets/analytics/weekday_radar_chart.dart';
import '../../../core/constants/app_constants.dart';
import '../companies/widgets/company_title.dart';
import 'widgets/company_comparison.dart';
import 'widgets/export_sheet.dart';
import 'widgets/monthly_comparison_chart.dart';
import 'widgets/salary_waterfall.dart';
import '../../widgets/common/chart_empty.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final reportAsync = ref.watch(analyticsReportProvider);
    final period = ref.watch(selectedPeriodProvider);
    final exportState = ref.watch(exportControllerProvider);

    ref.listen(exportControllerProvider, (_, next) {
      if (next is AsyncError) {
        UIHelpers.showErrorSnackBar(context, 'تعذّر التصدير: ${next.error}');
      }
    });

    return Scaffold(
      appBar: AppBar(
        // العنوان يحمل اسم الجهة: التقرير يخصّها وحدها، وقراءته منسوباً
        // لغيرها خطأ لا يظهر في الأرقام.
        title: const CompanyTitle(fallback: 'التقارير'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            tooltip: 'تصدير',
            onPressed: reportAsync.valueOrNull == null
                ? null
                : () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      builder: (_) => ExportSheet(report: reportAsync.value!),
                    ),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => ref.invalidate(analyticsReportProvider),
            child: ListView(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 32),
              children: [
                PeriodSelector(
                  period: period,
                  onChanged: (value) =>
                      ref.read(selectedPeriodProvider.notifier).set(value),
                ),
                const SizedBox(height: 16),
                // المقارنة قبل التفاصيل: بجهتين فأكثر هذا أول ما يُسأل عنه.
                ref.watch(companyComparisonProvider).maybeWhen(
                      data: (entries) => entries.length < 2
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  bottom: AppSpacing.lg),
                              child: CompanyComparison(
                                entries: entries,
                                currency: reportAsync.valueOrNull?.currency ??
                                    AppConstants.defaultCurrency,
                              ),
                            ),
                      orElse: () => const SizedBox.shrink(),
                    ),
                reportAsync.when(
                  data: (report) => report == null
                      ? const _NoProfile()
                      : _ReportBody(report: report),
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Center(child: Text('تعذّر بناء التقرير: $error')),
                  ),
                ),
              ],
            ),
          ),
          if (exportState is AsyncLoading)
            ColoredBox(
              color: palette.scrim,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final attendance = report.attendance;
    final finance = report.finance;
    final currency = report.currency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnalyticsCard(
          title: 'نظرة عامة',
          subtitle: report.period.label,
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 0.98,
            children: [
              MetricTile(
                label: 'صافي الراتب',
                value: report.salary.net.toStringAsFixed(0),
                hint: currency,
                icon: Icons.account_balance_wallet_rounded,
                color: report.salary.net >= 0
                    ? palette.positive
                    : theme.colorScheme.error,
              ),
              MetricTile(
                label: 'الساعات المنجزة',
                value: (attendance.totalWorkedMinutes / 60).toStringAsFixed(1),
                hint: 'ساعة',
                icon: Icons.timer_outlined,
              ),
              MetricTile(
                label: 'الإضافي',
                value:
                    (attendance.totalOvertimeMinutes / 60).toStringAsFixed(1),
                hint: 'ساعة',
                icon: Icons.trending_up_rounded,
                color: palette.positive,
              ),
              MetricTile(
                label: 'العجز والغياب',
                value: (attendance.totalDeficitMinutes / 60).toStringAsFixed(1),
                hint: 'ساعة',
                icon: Icons.trending_down_rounded,
                color: theme.colorScheme.error,
              ),
              MetricTile(
                label: 'نسبة الحضور',
                value: '${(attendance.attendanceRate * 100).toStringAsFixed(0)}%',
                hint: '${attendance.attendedDays}/${attendance.expectedWorkingDays} يوم',
                icon: Icons.event_available_rounded,
              ),
              MetricTile(
                label: 'نسبة الالتزام',
                value:
                    '${(attendance.punctualityRate * 100).toStringAsFixed(0)}%',
                hint: 'أيام بلا عجز',
                icon: Icons.verified_outlined,
                color: palette.positive,
              ),
              MetricTile(
                label: 'المصروفات',
                value: finance.totalExpense.toStringAsFixed(0),
                hint: currency,
                icon: Icons.shopping_cart_outlined,
                color: theme.colorScheme.error,
              ),
              MetricTile(
                label: 'الدخل الإضافي',
                value: finance.totalIncome.toStringAsFixed(0),
                hint: currency,
                icon: Icons.savings_outlined,
                color: palette.positive,
              ),
              MetricTile(
                label: 'أطول التزام',
                value: '${attendance.longestStreak}',
                hint: 'يوم متتالٍ',
                icon: Icons.local_fire_department_outlined,
                color: palette.warning,
              ),
            ],
          ),
        ),
        AnalyticsCard(
          title: 'كشف الراتب',
          subtitle: 'من الأساسي إلى الصافي',
          child: SalaryWaterfall(salary: report.salary, currency: currency),
        ),
        AnalyticsCard(
          title: 'الساعات اليومية',
          subtitle: 'الرسمي بلون التطبيق والإضافي بالأخضر',
          child: HoursBarChart(points: attendance.dailySeries),
        ),
        AnalyticsCard(
          title: 'خريطة الحضور',
          subtitle: 'شدة اللون تتبع نسبة الإنجاز مقابل المطلوب',
          child: AttendanceCalendarHeatmap(cells: attendance.calendar),
        ),
        AnalyticsCard(
          title: 'توزيع العبء على أيام الأسبوع',
          subtitle: 'متوسط الساعات لكل يوم',
          child: WeekdayRadarChart(averageHours: attendance.averageByWeekday),
        ),
        AnalyticsCard(
          title: 'أوقات الحضور والانصراف',
          child: Row(
            children: [
              Expanded(
                child: MetricTile(
                  label: 'متوسط الحضور',
                  value: _clock(attendance.averageCheckInMinutes),
                  icon: Icons.login_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricTile(
                  label: 'متوسط الانصراف',
                  value: _clock(attendance.averageCheckOutMinutes),
                  icon: Icons.logout_rounded,
                  color: palette.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricTile(
                  label: 'أيام الغياب',
                  value: '${attendance.absentDays}',
                  icon: Icons.event_busy_rounded,
                  color: theme.colorScheme.error,
                ),
              ),
            ],
          ),
        ),
        AnalyticsCard(
          title: 'التدفق النقدي',
          subtitle:
              'الصافي ${finance.netFlow.toStringAsFixed(0)} $currency  •  معدل الادخار ${(finance.savingsRate * 100).toStringAsFixed(0)}%',
          child: CashFlowLineChart(
            points: finance.series,
            currency: currency,
          ),
        ),
        AnalyticsCard(
          title: 'المصروفات حسب الفئة',
          subtitle: finance.largestExpense == null
              ? null
              : 'الأكبر: ${finance.largestExpense!.name} — ${(finance.largestExpense!.share * 100).toStringAsFixed(0)}% من الإنفاق',
          child: CategoryPieChart(
            items: finance.expenseByCategory,
            currency: currency,
          ),
        ),
        AnalyticsCard(
          title: 'مقارنة آخر ٦ أشهر',
          subtitle: 'إجمالي المستحق مقابل المصروف',
          child: MonthlyComparisonChart(
            points: report.monthlyComparison,
            currency: currency,
          ),
        ),
        AnalyticsCard(
          title: 'السجل التفصيلي',
          subtitle: 'كل يوم عمل في الفترة',
          child: _DetailTable(report: report),
        ),
      ],
    );
  }

  static String _clock(int? minutes) {
    if (minutes == null) return '—';
    return '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
  }
}

class _DetailTable extends StatelessWidget {
  const _DetailTable({required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final rows = report.attendance.calendar
        .where((cell) => cell.status != DayStatus.future)
        .where((cell) =>
            cell.status != DayStatus.dayOff || cell.workedMinutes > 0)
        .toList()
        .reversed
        .toList();

    if (rows.isEmpty) {
      return const ChartEmpty(
        message: 'لا أيام عمل في هذه الفترة',
        icon: Icons.table_rows_rounded,
        height: 100,
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 18,
        headingRowHeight: 40,
        dataRowMinHeight: 40,
        dataRowMaxHeight: 46,
        headingRowColor:
            WidgetStateProperty.all(theme.colorScheme.primaryContainer),
        columns: const [
          DataColumn(label: Text('اليوم')),
          DataColumn(label: Text('المطلوب')),
          DataColumn(label: Text('المنجز')),
          DataColumn(label: Text('إضافي')),
          DataColumn(label: Text('عجز')),
          DataColumn(label: Text('الحالة')),
        ],
        rows: [
          for (final cell in rows)
            DataRow(cells: [
              DataCell(Text(
                '${cell.date.day} ${DateHelpers.getArabicDayName(cell.date)}',
                style: theme.textTheme.bodySmall,
              )),
              DataCell(Text(
                  DateHelpers.formatDurationCompact(cell.requiredMinutes),
                  style: theme.textTheme.bodySmall)),
              DataCell(Text(
                  DateHelpers.formatDurationCompact(cell.workedMinutes),
                  style: theme.textTheme.bodySmall)),
              DataCell(Text(
                cell.overtimeMinutes == 0
                    ? '—'
                    : DateHelpers.formatDurationCompact(cell.overtimeMinutes),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: palette.positive),
              )),
              DataCell(Text(
                cell.deficitMinutes == 0
                    ? '—'
                    : DateHelpers.formatDurationCompact(cell.deficitMinutes),
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error),
              )),
              DataCell(Container(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(8, 3, 8, 3),
                decoration: BoxDecoration(
                  color:
                      statusColor(cell.status, theme, palette).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel(cell.status),
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: statusColor(cell.status, theme, palette)),
                ),
              )),
            ]),
        ],
      ),
    );
  }
}

class _NoProfile extends StatelessWidget {
  const _NoProfile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.analytics_outlined,
              size: 64, color: Theme.of(context).disabledColor),
          const SizedBox(height: 16),
          Text('أكمل ملفك الشخصي أولاً',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            'التقارير تُبنى على راتبك وجدول دوامك. افتح شاشة الملف الشخصي وأدخلهما.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
