import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../domain/entities/analytics_report_entity.dart';
import '../../utils/date_helpers.dart';

/// يبني كشف راتب وتقرير حضور PDF بالعربية من اليمين لليسار.
///
/// الخط مدمج في assets لأن `printing` لا يستطيع تحميل خط من الشبكة في
/// تطبيق يعمل بلا اتصال، والخطوط الافتراضية في حزمة `pdf` بلا محارف عربية.
class ReportPdfBuilder {
  ReportPdfBuilder._(this._theme);

  final pw.ThemeData _theme;

  static pw.ThemeData? _cachedTheme;

  static Future<ReportPdfBuilder> create() async {
    _cachedTheme ??= pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load('assets/fonts/Tajawal-Regular.ttf')),
      bold: pw.Font.ttf(await rootBundle.load('assets/fonts/Tajawal-Bold.ttf')),
    );
    return ReportPdfBuilder._(_cachedTheme!);
  }

  static const _accent = PdfColor.fromInt(0xFF6750A4);
  static const _positive = PdfColor.fromInt(0xFF2E7D32);
  static const _negative = PdfColor.fromInt(0xFFC62828);
  static const _muted = PdfColor.fromInt(0xFF6B6B6B);
  static const _rowAlt = PdfColor.fromInt(0xFFF4F1F8);

  Future<Uint8List> build(AnalyticsReport report) async {
    final document = pw.Document(
      theme: _theme,
      title: 'تقرير ${report.period.label}',
      author: report.employeeName,
    );

    document.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        textDirection: pw.TextDirection.rtl,
        margin: const pw.EdgeInsets.fromLTRB(28, 28, 28, 36),
        header: (context) =>
            context.pageNumber == 1 ? pw.SizedBox() : _runningHeader(report),
        footer: _footer,
        build: (context) => [
          _header(report),
          pw.SizedBox(height: 18),
          _salarySection(report),
          pw.SizedBox(height: 18),
          _attendanceSummary(report),
          pw.SizedBox(height: 18),
          _attendanceTable(report),
          pw.SizedBox(height: 18),
          if (report.finance.expenseByCategory.isNotEmpty) ...[
            _expenseSection(report),
            pw.SizedBox(height: 18),
          ],
          _signatures(),
        ],
      ),
    );

    return document.save();
  }

  // ── الرأس والتذييل ──────────────────────────────────────────────

  pw.Widget _header(AnalyticsReport report) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: const pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFEDE7F6),
        borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  report.companyName ?? 'كشف الراتب والدوام',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 4),
                pw.Text('${report.employeeName} — ${report.jobTitle}',
                    style: const pw.TextStyle(fontSize: 11)),
              ],
            ),
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(report.period.label,
                  style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 4),
              pw.Text(
                'صدر في ${DateHelpers.formatShortDate(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 9, color: _muted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _runningHeader(AnalyticsReport report) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.only(bottom: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _muted, width: 0.4)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(report.employeeName, style: const pw.TextStyle(fontSize: 9)),
          pw.Text(report.period.label, style: const pw.TextStyle(fontSize: 9)),
        ],
      ),
    );
  }

  pw.Widget _footer(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'صفحة ${context.pageNumber} من ${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 9, color: _muted),
      ),
    );
  }

  // ── الأقسام ─────────────────────────────────────────────────────

  pw.Widget _salarySection(AnalyticsReport report) {
    final salary = report.salary;
    final currency = report.currency;

    return _section('كشف الراتب', [
      _amountTable([
        ('الراتب الأساسي', salary.baseSalary, null),
        ('بدل العمل الإضافي', salary.overtimeValue, _positive),
        ('خصم العجز والغياب', -salary.deficitValue, _negative),
        ('بدلات وخصومات ثابتة', salary.adjustments,
            salary.adjustments >= 0 ? _positive : _negative),
      ], currency),
      pw.SizedBox(height: 6),
      _totalRow('إجمالي المستحق', salary.gross, currency, _accent),
      pw.SizedBox(height: 10),
      _amountTable([
        ('سداد ديون خلال الفترة', -salary.debtPayments, _negative),
        ('مصروفات شخصية', -salary.expenses, _negative),
      ], currency),
      pw.SizedBox(height: 6),
      _totalRow('الصافي بعد المصروفات', salary.net, currency,
          salary.net >= 0 ? _positive : _negative),
      pw.SizedBox(height: 10),
      pw.Text(
        'أجر الساعة ${salary.hourlyWage.toStringAsFixed(2)} $currency  •  أجر الساعة الإضافية ${salary.overtimeHourlyRate.toStringAsFixed(2)} $currency',
        style: const pw.TextStyle(fontSize: 9, color: _muted),
      ),
    ]);
  }

  pw.Widget _attendanceSummary(AnalyticsReport report) {
    final attendance = report.attendance;
    return _section('ملخص الدوام', [
      pw.Row(children: [
        _statBox('أيام العمل المطلوبة', '${attendance.expectedWorkingDays}'),
        _statBox('أيام الحضور', '${attendance.attendedDays}'),
        _statBox('أيام الغياب', '${attendance.absentDays}', _negative),
      ]),
      pw.SizedBox(height: 8),
      pw.Row(children: [
        _statBox('الساعات المنجزة',
            DateHelpers.formatDurationCompact(attendance.totalWorkedMinutes)),
        _statBox('الإضافي',
            DateHelpers.formatDurationCompact(attendance.totalOvertimeMinutes),
            _positive),
        _statBox('العجز',
            DateHelpers.formatDurationCompact(attendance.totalDeficitMinutes),
            _negative),
      ]),
      pw.SizedBox(height: 8),
      pw.Row(children: [
        _statBox('نسبة الالتزام',
            '${(attendance.punctualityRate * 100).toStringAsFixed(0)}%'),
        _statBox('متوسط الحضور', _clock(attendance.averageCheckInMinutes)),
        _statBox('متوسط الانصراف', _clock(attendance.averageCheckOutMinutes)),
      ]),
    ]);
  }

  pw.Widget _attendanceTable(AnalyticsReport report) {
    final rows = report.attendance.calendar
        .where((cell) => cell.status != DayStatus.future)
        .where((cell) =>
            cell.status != DayStatus.dayOff || cell.workedMinutes > 0)
        .toList();

    return _section('سجل الحضور التفصيلي', [
      pw.TableHelper.fromTextArray(
        headers: const [
          'اليوم',
          'التاريخ',
          'المطلوب',
          'المنجز',
          'إضافي',
          'عجز',
          'الحالة',
        ],
        data: [
          for (final cell in rows)
            [
              DateHelpers.getArabicDayName(cell.date),
              '${cell.date.day}/${cell.date.month}',
              DateHelpers.formatDurationCompact(cell.requiredMinutes),
              DateHelpers.formatDurationCompact(cell.workedMinutes),
              cell.overtimeMinutes == 0
                  ? '—'
                  : DateHelpers.formatDurationCompact(cell.overtimeMinutes),
              cell.deficitMinutes == 0
                  ? '—'
                  : DateHelpers.formatDurationCompact(cell.deficitMinutes),
              _statusLabel(cell.status),
            ],
        ],
        border: null,
        headerStyle: pw.TextStyle(
            fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: const pw.BoxDecoration(color: _accent),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellHeight: 20,
        cellAlignment: pw.Alignment.center,
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(color: _rowAlt, width: 0.8)),
        ),
        oddRowDecoration: const pw.BoxDecoration(color: _rowAlt),
      ),
    ]);
  }

  pw.Widget _expenseSection(AnalyticsReport report) {
    final finance = report.finance;
    return _section('المصروفات حسب الفئة', [
      pw.TableHelper.fromTextArray(
        headers: const ['الفئة', 'المبلغ', 'النسبة', 'عدد العمليات'],
        data: [
          for (final item in finance.expenseByCategory)
            [
              item.name,
              '${item.amount.toStringAsFixed(0)} ${report.currency}',
              '${(item.share * 100).toStringAsFixed(1)}%',
              '${item.transactionCount}',
            ],
        ],
        border: null,
        headerStyle: pw.TextStyle(
            fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.white),
        headerDecoration: const pw.BoxDecoration(color: _accent),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellHeight: 20,
        cellAlignment: pw.Alignment.center,
        oddRowDecoration: const pw.BoxDecoration(color: _rowAlt),
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        'إجمالي المصروفات ${finance.totalExpense.toStringAsFixed(0)} ${report.currency}  •  الدخل الإضافي ${finance.totalIncome.toStringAsFixed(0)} ${report.currency}  •  متوسط الصرف اليومي ${finance.dailyAverageExpense.toStringAsFixed(0)} ${report.currency}',
        style: const pw.TextStyle(fontSize: 9, color: _muted),
      ),
    ]);
  }

  pw.Widget _signatures() {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 24),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          _signatureLine('توقيع الموظف'),
          _signatureLine('توقيع المسؤول'),
        ],
      ),
    );
  }

  pw.Widget _signatureLine(String label) {
    return pw.Column(children: [
      pw.Container(width: 150, height: 0.8, color: _muted),
      pw.SizedBox(height: 5),
      pw.Text(label, style: const pw.TextStyle(fontSize: 9, color: _muted)),
    ]);
  }

  // ── لبنات مشتركة ────────────────────────────────────────────────

  pw.Widget _section(String title, List<pw.Widget> children) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(title,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 3),
        pw.Container(width: 44, height: 2, color: _accent),
        pw.SizedBox(height: 10),
        ...children,
      ],
    );
  }

  pw.Widget _amountTable(
      List<(String, double, PdfColor?)> rows, String currency) {
    return pw.Column(
      children: [
        for (final row in rows)
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 5),
            decoration: const pw.BoxDecoration(
              border:
                  pw.Border(bottom: pw.BorderSide(color: _rowAlt, width: 0.8)),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(row.$1, style: const pw.TextStyle(fontSize: 10)),
                pw.Text(
                  '${row.$2.toStringAsFixed(2)} $currency',
                  style: pw.TextStyle(fontSize: 10, color: row.$3),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _totalRow(
      String label, double value, String currency, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: color, width: 0.7),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label,
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
          pw.Text(
            '${value.toStringAsFixed(2)} $currency',
            style: pw.TextStyle(
                fontSize: 12, fontWeight: pw.FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  pw.Widget _statBox(String label, String value, [PdfColor? color]) {
    return pw.Expanded(
      child: pw.Container(
        margin: const pw.EdgeInsets.symmetric(horizontal: 3),
        padding: const pw.EdgeInsets.symmetric(vertical: 9, horizontal: 6),
        decoration: pw.BoxDecoration(
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          border: pw.Border.all(color: _rowAlt, width: 1.2),
        ),
        child: pw.Column(children: [
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: color ?? PdfColors.black)),
          pw.SizedBox(height: 3),
          pw.Text(label,
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 8, color: _muted)),
        ]),
      ),
    );
  }

  static String _clock(int? minutes) {
    if (minutes == null) return '—';
    return '${(minutes ~/ 60).toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')}';
  }

  static String _statusLabel(DayStatus status) {
    return switch (status) {
      DayStatus.worked => 'مكتمل',
      DayStatus.overtime => 'إضافي',
      DayStatus.deficit => 'عجز',
      DayStatus.absent => 'غياب',
      DayStatus.dayOff => 'عطلة',
      DayStatus.future => '—',
    };
  }
}
