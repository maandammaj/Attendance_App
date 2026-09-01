// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsReportHash() => r'ef9b1fcebf4cd3ba87573ae4ade9290efee4561c';

/// See also [analyticsReport].
@ProviderFor(analyticsReport)
final analyticsReportProvider =
    AutoDisposeFutureProvider<AnalyticsReport?>.internal(
      analyticsReport,
      name: r'analyticsReportProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$analyticsReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsReportRef = AutoDisposeFutureProviderRef<AnalyticsReport?>;
String _$companyComparisonHash() => r'f638eaf1fc77a010ca66368c3f33704d99282ba2';

/// أداء كل جهة خلال الفترة المختارة، مرتّباً بالعائد للساعة.
///
/// يُبنى فقط عند وجود أكثر من جهة: مقارنة جهة بنفسها لا تفيد.
///
/// Copied from [companyComparison].
@ProviderFor(companyComparison)
final companyComparisonProvider =
    AutoDisposeFutureProvider<List<CompanyPerformance>>.internal(
      companyComparison,
      name: r'companyComparisonProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyComparisonHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompanyComparisonRef =
    AutoDisposeFutureProviderRef<List<CompanyPerformance>>;
String _$selectedPeriodHash() => r'e035601789cc0eb179a9bc0fe979bcc85c058a72';

/// المدى المعروض في شاشة التحليلات. تغييره يعيد بناء التقرير وحده.
///
/// Copied from [SelectedPeriod].
@ProviderFor(SelectedPeriod)
final selectedPeriodProvider =
    AutoDisposeNotifierProvider<SelectedPeriod, ReportPeriod>.internal(
      SelectedPeriod.new,
      name: r'selectedPeriodProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$selectedPeriodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedPeriod = AutoDisposeNotifier<ReportPeriod>;
String _$exportControllerHash() => r'9530867b263bef1804468790b9ae17a738362ad6';

/// See also [ExportController].
@ProviderFor(ExportController)
final exportControllerProvider =
    AutoDisposeAsyncNotifierProvider<ExportController, void>.internal(
      ExportController.new,
      name: r'exportControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$exportControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExportController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
