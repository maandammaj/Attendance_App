import 'package:flutter/material.dart';
import '../../../core/constants/design_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/attendance_entity.dart';
import '../../../domain/entities/company_entity.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/company_provider.dart';
import 'edit_attendance_dialog.dart';

class MonthlyReportScreen extends ConsumerStatefulWidget {
  const MonthlyReportScreen({super.key});

  @override
  ConsumerState<MonthlyReportScreen> createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends ConsumerState<MonthlyReportScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(monthlyAttendanceProvider(
      year: _selectedMonth.year,
      month: _selectedMonth.month,
    ));
    
    final companyAsync = ref.watch(activeCompanyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('تقرير ${DateFormat('MMMM yyyy', 'ar').format(_selectedMonth)}'),
        centerTitle: true,
        actions: [
          IconButton(
              tooltip: 'اختيار الشهر',
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedMonth,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() => _selectedMonth = picked);
              }
            },
          )
        ],
      ),
      body: companyAsync.when(
        data: (company) => recordsAsync.when(
          data: (records) => _ReportTable(
            records: records,
            company: company,
            month: _selectedMonth,
            onEdit: (record) => showDialog<void>(
              context: context,
              builder: (_) => EditAttendanceDialog(record: record),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ في تحميل السجلات: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ في تحميل الملف الشخصي: $e')),
      ),
    );
  }
}

/// جدول الشهر يوماً بيوم. ويدجت مستقل لأن `DataTable` يعيد بناء كل صفوفه
/// عند أي تغيّر في الشاشة الحاضنة؛ فصله يحصر إعادة البناء فيه.
class _ReportTable extends StatelessWidget {
  const _ReportTable({
    required this.records,
    required this.company,
    required this.month,
    required this.onEdit,
  });

  final List<AttendanceEntity> records;
  final CompanyEntity? company;
  final DateTime month;
  final ValueChanged<AttendanceEntity> onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columnSpacing: 20,
          headingRowColor:
              WidgetStatePropertyAll(palette.surfaceAlt),
          headingTextStyle: theme.textTheme.labelMedium,
          dataTextStyle: theme.textTheme.bodySmall,
          columns: const [
            DataColumn(label: Text('اليوم')),
            DataColumn(label: Text('جلسات')),
            DataColumn(label: Text('الحضور')),
            DataColumn(label: Text('الانصراف')),
            DataColumn(label: Text('المطلوب')),
            DataColumn(label: Text('المحقق')),
            DataColumn(label: Text('زيادة')),
            DataColumn(label: Text('عجز')),
          ],
          rows: _rows(context, palette),
        ),
      ),
    );
  }

  List<DataRow> _rows(BuildContext context, AppPalette palette) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final now = DateTime.now();
    final rows = <DataRow>[];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      final record = records
          .where((r) => DateHelpers.isSameDay(r.date, date))
          .firstOrNull;

      var isMissingWorkDay = false;
      var requiredHours = record?.requiredHours ?? 0;

      if (record == null && company != null && date.isBefore(now)) {
        final config = company!.workSchedule.firstWhere(
          (d) => d.dayOfWeek == DateHelpers.scheduleDayOf(date),
          orElse: () => WorkDayConfigEntity(
            dayOfWeek: DateHelpers.scheduleDayOf(date),
            isWorkingDay: false,
            requiredHours: 0,
            requiredMinutes: 0,
            isHoliday: true,
          ),
        );
        if (config.isWorkingDay && !config.isHoliday) {
          isMissingWorkDay = true;
          requiredHours = config.requiredHours;
        }
      }

      final overtime =
          record == null ? 0 : (record.overtimeHours * 60) + record.overtimeMinutes;
      final deficit =
          record == null ? 0 : (record.deficitHours * 60) + record.deficitMinutes;

      rows.add(DataRow(
        onSelectChanged:
            record == null ? null : (_) => onEdit(record),
        color: isMissingWorkDay
            ? WidgetStatePropertyAll(palette.negative.withValues(alpha: 0.06))
            : null,
        cells: [
          DataCell(Text(
              '$day ${DateHelpers.getArabicDayName(date)}')),
          DataCell(Text(record == null ? '—' : '${record.sessionCount}')),
          DataCell(Text(record?.checkIn == null
              ? (isMissingWorkDay ? 'غائب' : '—')
              : DateHelpers.formatTime(record!.checkIn!))),
          DataCell(Text(record?.checkOut == null
              ? '—'
              : DateHelpers.formatTime(record!.checkOut!))),
          DataCell(Text('$requiredHoursس')),
          DataCell(Text(record == null
              ? (isMissingWorkDay ? '0س' : '—')
              : DateHelpers.formatDurationCompact(
                  (record.workedHours * 60) + record.workedMinutes))),
          DataCell(Text(
            overtime == 0 ? '—' : '+${DateHelpers.formatDurationCompact(overtime)}',
            style: TextStyle(color: palette.positive),
          )),
          DataCell(Text(
            isMissingWorkDay
                ? '-$requiredHoursس'
                : (deficit == 0
                    ? '—'
                    : '-${DateHelpers.formatDurationCompact(deficit)}'),
            style: TextStyle(color: palette.negative),
          )),
        ],
      ));
    }
    return rows;
  }
}
