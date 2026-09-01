// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allDebtsHash() => r'9237469965d6bd9891c36bd60e0ec8046239750c';

/// See also [allDebts].
@ProviderFor(allDebts)
final allDebtsProvider = AutoDisposeFutureProvider<List<DebtEntity>>.internal(
  allDebts,
  name: r'allDebtsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allDebtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllDebtsRef = AutoDisposeFutureProviderRef<List<DebtEntity>>;
String _$debtSummaryHash() => r'c1c410ee338c53bba7943681b1ea353bce94de62';

/// See also [debtSummary].
@ProviderFor(debtSummary)
final debtSummaryProvider = AutoDisposeFutureProvider<DebtSummary>.internal(
  debtSummary,
  name: r'debtSummaryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$debtSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DebtSummaryRef = AutoDisposeFutureProviderRef<DebtSummary>;
String _$debtControllerHash() => r'90d43b1bde23411b66005822388ed3ae1e62130e';

/// See also [DebtController].
@ProviderFor(DebtController)
final debtControllerProvider =
    AutoDisposeAsyncNotifierProvider<DebtController, void>.internal(
      DebtController.new,
      name: r'debtControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$debtControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DebtController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
