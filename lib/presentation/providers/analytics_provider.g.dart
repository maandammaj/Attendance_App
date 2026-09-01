// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsReportHash() => r'f17fca39ece73cd9309b8af10686c5920b7ec0ec';

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
