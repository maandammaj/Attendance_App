import '../../../domain/entities/analytics_report_entity.dart';
import '../../utils/date_helpers.dart';

/// يبني ملفات CSV تفتحها Excel مباشرة.
///
/// البادئة `﻿` مطلوبة: بدونها تقرأ Excel على ويندوز الملف بترميز
/// النظام المحلي فيظهر النص العربي مشوّهاً.
class ReportCsvBuilder {
  ReportCsvBuilder._();

  static const String _bom = '﻿';

  /// سجل الحضور يوماً بيوم.
  static String attendance(AnalyticsReport report) {
    final rows = <List<String>>[
      [
        'التاريخ',
        'اليوم',
        'الحضور',
        'الانصراف',
        'الساعات المطلوبة',
        'الساعات المنجزة',
        'دقائق إضافي',
        'دقائق عجز',
        'الحالة',
      ],
    ];

    final byDate = {
      for (final cell in report.attendance.calendar)
        DateHelpers.startOfDay(cell.date): cell,
    };

    for (final entry in byDate.entries) {
      final cell = entry.value;
      if (cell.status == DayStatus.future) continue;
      rows.add([
        _isoDate(cell.date),
        DateHelpers.getArabicDayName(cell.date),
        '',
        '',
        '${cell.requiredMinutes}',
        '${cell.workedMinutes}',
        '${cell.overtimeMinutes}',
        '${cell.deficitMinutes}',
        _statusLabel(cell.status),
      ]);
    }

    return _encode(rows);
  }

  /// المصروفات والدخل مجمّعة حسب الفئة.
  static String finance(AnalyticsReport report) {
    final rows = <List<String>>[
      ['النوع', 'الفئة', 'المبلغ', 'النسبة من الإجمالي', 'عدد العمليات'],
    ];

    for (final item in report.finance.incomeByCategory) {
      rows.add([
        'دخل',
        item.name,
        item.amount.toStringAsFixed(2),
        '${(item.share * 100).toStringAsFixed(1)}%',
        '${item.transactionCount}',
      ]);
    }
    for (final item in report.finance.expenseByCategory) {
      rows.add([
        'مصروف',
        item.name,
        item.amount.toStringAsFixed(2),
        '${(item.share * 100).toStringAsFixed(1)}%',
        '${item.transactionCount}',
      ]);
    }

    return _encode(rows);
  }

  /// كشف الراتب كصفوف بند/قيمة.
  static String salary(AnalyticsReport report) {
    final salary = report.salary;
    return _encode([
      ['البند', 'القيمة (${report.currency})'],
      ['الفترة', report.period.label],
      ['الموظف', report.employeeName],
      ['الراتب الأساسي', salary.baseSalary.toStringAsFixed(2)],
      ['بدل العمل الإضافي', salary.overtimeValue.toStringAsFixed(2)],
      ['خصم العجز والغياب', (-salary.deficitValue).toStringAsFixed(2)],
      ['بدلات وخصومات ثابتة', salary.adjustments.toStringAsFixed(2)],
      ['إجمالي المستحق', salary.gross.toStringAsFixed(2)],
      ['سداد ديون', (-salary.debtPayments).toStringAsFixed(2)],
      ['مصروفات شخصية', (-salary.expenses).toStringAsFixed(2)],
      ['الصافي', salary.net.toStringAsFixed(2)],
      ['أجر الساعة', salary.hourlyWage.toStringAsFixed(2)],
      ['أجر الساعة الإضافية', salary.overtimeHourlyRate.toStringAsFixed(2)],
    ]);
  }

  static String _encode(List<List<String>> rows) {
    final buffer = StringBuffer(_bom);
    for (final row in rows) {
      buffer.writeln(row.map(_escape).join(','));
    }
    return buffer.toString();
  }

  static String _escape(String value) {
    if (!value.contains(RegExp('[",\n]'))) return value;
    return '"${value.replaceAll('"', '""')}"';
  }

  static String _isoDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  static String _statusLabel(DayStatus status) {
    return switch (status) {
      DayStatus.worked => 'مكتمل',
      DayStatus.overtime => 'إضافي',
      DayStatus.deficit => 'عجز',
      DayStatus.absent => 'غياب',
      DayStatus.dayOff => 'عطلة',
      DayStatus.future => '',
    };
  }
}
