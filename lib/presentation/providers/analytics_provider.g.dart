// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.

@ProviderFor(SelectedPeriod)
final selectedPeriodProvider = SelectedPeriodProvider._();

/// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.
final class SelectedPeriodProvider
    extends $NotifierProvider<SelectedPeriod, ReportPeriod> {
  /// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.
  SelectedPeriodProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedPeriodProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedPeriodHash();

  @$internal
  @override
  SelectedPeriod create() => SelectedPeriod();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportPeriod value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportPeriod>(value),
    );
  }
}

String _$selectedPeriodHash() => r'e035601789cc0eb179a9bc0fe979bcc85c058a72';

/// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.

abstract class _$SelectedPeriod extends $Notifier<ReportPeriod> {
  ReportPeriod build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReportPeriod, ReportPeriod>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportPeriod, ReportPeriod>,
              ReportPeriod,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(analyticsReport)
final analyticsReportProvider = AnalyticsReportProvider._();

final class AnalyticsReportProvider
    extends
        $FunctionalProvider<
          AsyncValue<AnalyticsReport?>,
          AnalyticsReport?,
          FutureOr<AnalyticsReport?>
        >
    with $FutureModifier<AnalyticsReport?>, $FutureProvider<AnalyticsReport?> {
  AnalyticsReportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsReportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsReportHash();

  @$internal
  @override
  $FutureProviderElement<AnalyticsReport?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AnalyticsReport?> create(Ref ref) {
    return analyticsReport(ref);
  }
}

String _$analyticsReportHash() => r'ef9b1fcebf4cd3ba87573ae4ade9290efee4561c';

@ProviderFor(ExportController)
final exportControllerProvider = ExportControllerProvider._();

final class ExportControllerProvider
    extends $AsyncNotifierProvider<ExportController, void> {
  ExportControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportControllerHash();

  @$internal
  @override
  ExportController create() => ExportController();
}

String _$exportControllerHash() => r'2d9ea2aece43048b74939d29574efdfa2e680c7a';

abstract class _$ExportController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// أداء كل جهة خلال الفترة المختارة، مرتّباً بالعائد للساعة.
///
/// يُبنى فقط عند وجود أكثر من جهة: مقارنة جهة بنفسها لا تفيد.

@ProviderFor(companyComparison)
final companyComparisonProvider = CompanyComparisonProvider._();

/// أداء كل جهة خلال الفترة المختارة، مرتّباً بالعائد للساعة.
///
/// يُبنى فقط عند وجود أكثر من جهة: مقارنة جهة بنفسها لا تفيد.

final class CompanyComparisonProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CompanyPerformance>>,
          List<CompanyPerformance>,
          FutureOr<List<CompanyPerformance>>
        >
    with
        $FutureModifier<List<CompanyPerformance>>,
        $FutureProvider<List<CompanyPerformance>> {
  /// أداء كل جهة خلال الفترة المختارة، مرتّباً بالعائد للساعة.
  ///
  /// يُبنى فقط عند وجود أكثر من جهة: مقارنة جهة بنفسها لا تفيد.
  CompanyComparisonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyComparisonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyComparisonHash();

  @$internal
  @override
  $FutureProviderElement<List<CompanyPerformance>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CompanyPerformance>> create(Ref ref) {
    return companyComparison(ref);
  }
}

String _$companyComparisonHash() => r'f638eaf1fc77a010ca66368c3f33704d99282ba2';
