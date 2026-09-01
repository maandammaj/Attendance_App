import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../domain/entities/profile_entity.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/profile_provider.dart';
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
    
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('تقرير ${DateFormat('MMMM yyyy', 'ar').format(_selectedMonth)}'),
        centerTitle: true,
        actions: [
          IconButton(
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
      body: profileAsync.when(
        data: (profile) => recordsAsync.when(
          data: (records) => _buildReportTable(context, records, profile),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ في تحميل السجلات: $e')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ في تحميل الملف الشخصي: $e')),
      ),
    );
  }

  Widget _buildReportTable(BuildContext context, List<dynamic> records, ProfileEntity? profile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          showCheckboxColumn: false,
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryContainer),
          columns: const [
            DataColumn(label: Text('اليوم')),
            DataColumn(label: Text('الحضور')),
            DataColumn(label: Text('الانصراف')),
            DataColumn(label: Text('المطلوب')),
            DataColumn(label: Text('المحقق')),
            DataColumn(label: Text('زيادة')),
            DataColumn(label: Text('عجز')),
          ],
          rows: _buildRows(records, profile),
        ),
      ),
    );
  }

  List<DataRow> _buildRows(List<dynamic> records, ProfileEntity? profile) {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final now = DateTime.now();
    final List<DataRow> rows = [];

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
      final record = records.where((r) => DateHelpers.isSameDay(r.date, date)).firstOrNull;
      
      bool isMissingWorkDay = false;
      int reqHours = record?.requiredHours ?? 0;

      if (record == null && profile != null && date.isBefore(now)) {
        final dayConfig = profile.workSchedule.firstWhere(
          (d) => d.dayOfWeek == DateHelpers.scheduleDayOf(date),
          orElse: () => WorkDayConfigEntity(dayOfWeek: DateHelpers.scheduleDayOf(date), isWorkingDay: false, requiredHours: 0, requiredMinutes: 0, isHoliday: true),
        );
        if (dayConfig.isWorkingDay && !dayConfig.isHoliday) {
          isMissingWorkDay = true;
          reqHours = dayConfig.requiredHours;
        }
      }

      rows.add(
        DataRow(
          onSelectChanged: (selected) {
            if (record != null) {
              showDialog(
                context: context,
                builder: (context) => EditAttendanceDialog(record: record),
              );
            }
          },
          color: isMissingWorkDay ? WidgetStateProperty.all(Colors.red.withValues(alpha: 0.05)) : null,
          cells: [
            DataCell(Text(DateFormat('d (EEEE)', 'ar').format(date))),
            DataCell(Text(record?.checkIn != null ? DateHelpers.formatTime(record!.checkIn!) : (isMissingWorkDay ? 'غائب' : '-'))),
            DataCell(Text(record?.checkOut != null ? DateHelpers.formatTime(record!.checkOut!) : '-')),
            DataCell(Text('${reqHours}س')),
            DataCell(Text(record != null ? '${record.workedHours}س ${record.workedMinutes}د' : (isMissingWorkDay ? '0س' : '-'))),
            DataCell(
              Text(
                record != null && (record.overtimeHours + record.overtimeMinutes > 0)
                    ? '+${record.overtimeHours}س'
                    : '-',
                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ),
            DataCell(
              Text(
                isMissingWorkDay 
                    ? '-${reqHours}س' 
                    : (record != null && (record.deficitHours + record.deficitMinutes > 0)
                        ? '-${record.deficitHours}س'
                        : '-'),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }
}
