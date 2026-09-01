import 'package:flutter/widgets.dart' show Rect;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/export/report_export_service.dart';
import '../../domain/entities/analytics_report_entity.dart';
import '../../domain/usecases/reports/build_analytics_report_usecase.dart';
import 'attendance_provider.dart';
import 'debt_provider.dart';
import '../../domain/usecases/reports/compare_companies_usecase.dart';
import 'company_provider.dart';
import 'profile_provider.dart';
import 'transaction_provider.dart';

part 'analytics_provider.g.dart';

final buildAnalyticsReportUseCaseProvider = Provider(
  (ref) => BuildAnalyticsReportUseCase(
    attendanceRepository: ref.read(attendanceRepositoryProvider),
    transactionRepository: ref.read(transactionRepositoryProvider),
    debtRepository: ref.read(debtRepositoryProvider),
  ),
);

final reportExportServiceProvider =
    Provider((ref) => const ReportExportService());

/// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.
@riverpod
class SelectedPeriod extends _$SelectedPeriod {
  @override
  ReportPeriod build() => ReportPeriod.month(DateTime.now());

  void set(ReportPeriod period) => state = period;
}

@riverpod
Future<AnalyticsReport?> analyticsReport(Ref ref) async {
  final company = await ref.watch(activeCompanyProvider.future);
  final profile = await ref.watch(profileProvider.future);
  if (company == null || profile == null) return null;

  return ref.read(buildAnalyticsReportUseCaseProvider)(
    period: ref.watch(selectedPeriodProvider),
    company: company,
    employeeName: profile.fullName,
  );
}

@riverpod
class ExportController extends _$ExportController {
  @override
  FutureOr<void> build() => null;

  Future<void> sharePdf(AnalyticsReport report, {Rect? origin}) => _run(
      () => ref.read(reportExportServiceProvider).sharePdf(report, origin: origin));

  Future<void> printPdf(AnalyticsReport report) =>
      _run(() => ref.read(reportExportServiceProvider).printPdf(report));

  Future<void> shareCsv(
    AnalyticsReport report,
    CsvDataset dataset, {
    Rect? origin,
  }) =>
      _run(() => ref
          .read(reportExportServiceProvider)
          .shareCsv(report, dataset, origin: origin));

  Future<void> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }
}

final compareCompaniesUseCaseProvider = Provider(
  (ref) => CompareCompaniesUseCase(ref.read(attendanceRepositoryProvider)),
);

/// أداء كل جهة خلال الفترة المختارة، مرتّباً بالعائد للساعة.
///
/// يُبنى فقط عند وجود أكثر من جهة: مقارنة جهة بنفسها لا تفيد.
@riverpod
Future<List<CompanyPerformance>> companyComparison(Ref ref) async {
  final companies = (await ref.watch(companiesProvider.future))
      .where((company) => !company.isArchived)
      .toList();
  if (companies.length < 2) return const [];

  return await ref.read(compareCompaniesUseCaseProvider)(
    companies: companies,
    period: ref.watch(selectedPeriodProvider),
  );
}
