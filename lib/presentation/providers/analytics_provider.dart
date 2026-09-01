import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/services/export/report_export_service.dart';
import '../../domain/entities/analytics_report_entity.dart';
import '../../domain/usecases/reports/build_analytics_report_usecase.dart';
import 'attendance_provider.dart';
import 'debt_provider.dart';
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
  final profile = await ref.watch(profileProvider.future);
  if (profile == null) return null;

  return ref.read(buildAnalyticsReportUseCaseProvider)(
    period: ref.watch(selectedPeriodProvider),
    profile: profile,
  );
}

@riverpod
class ExportController extends _$ExportController {
  @override
  FutureOr<void> build() => null;

  Future<void> sharePdf(AnalyticsReport report) =>
      _run(() => ref.read(reportExportServiceProvider).sharePdf(report));

  Future<void> printPdf(AnalyticsReport report) =>
      _run(() => ref.read(reportExportServiceProvider).printPdf(report));

  Future<void> shareCsv(AnalyticsReport report, CsvDataset dataset) => _run(
      () => ref.read(reportExportServiceProvider).shareCsv(report, dataset));

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
