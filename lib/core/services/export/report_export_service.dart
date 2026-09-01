import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../domain/entities/analytics_report_entity.dart';
import 'report_csv_builder.dart';
import 'report_pdf_builder.dart';

enum CsvDataset { attendance, finance, salary }

/// يحوّل [AnalyticsReport] إلى ملف على القرص ثم يفتح ورقة المشاركة.
///
/// الملفات تُكتب في مجلد مؤقت لا في مساحة المستندات: هي مشتقة بالكامل من
/// قاعدة البيانات، فلا معنى لاستمرارها بعد المشاركة.
class ReportExportService {
  const ReportExportService();

  Future<void> sharePdf(AnalyticsReport report) async {
    final builder = await ReportPdfBuilder.create();
    final bytes = await builder.build(report);
    final file = await _write(
      '${_slug(report)}.pdf',
      (path) => File(path).writeAsBytes(bytes),
    );

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: 'تقرير ${report.period.label}',
    );
  }

  /// يفتح معاينة الطباعة الأصلية للنظام.
  Future<void> printPdf(AnalyticsReport report) async {
    final builder = await ReportPdfBuilder.create();
    final bytes = await builder.build(report);
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: 'تقرير ${report.period.label}',
    );
  }

  Future<void> shareCsv(AnalyticsReport report, CsvDataset dataset) async {
    final content = switch (dataset) {
      CsvDataset.attendance => ReportCsvBuilder.attendance(report),
      CsvDataset.finance => ReportCsvBuilder.finance(report),
      CsvDataset.salary => ReportCsvBuilder.salary(report),
    };

    final name = switch (dataset) {
      CsvDataset.attendance => 'attendance',
      CsvDataset.finance => 'finance',
      CsvDataset.salary => 'salary',
    };

    final file = await _write(
      '${_slug(report)}-$name.csv',
      (path) => File(path).writeAsString(content),
    );

    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'تقرير ${report.period.label}',
    );
  }

  Future<File> _write(
      String fileName, Future<File> Function(String path) write) async {
    final directory = await getTemporaryDirectory();
    return write('${directory.path}/$fileName');
  }

  /// اسم ملف آمن: الفترة بالعربية لا تصلح لأسماء الملفات على كل الأنظمة.
  static String _slug(AnalyticsReport report) {
    final from = report.period.from;
    return 'report-${from.year}-${from.month.toString().padLeft(2, '0')}';
  }
}
