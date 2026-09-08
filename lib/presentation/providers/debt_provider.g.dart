// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(allDebts)
final allDebtsProvider = AllDebtsProvider._();

final class AllDebtsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DebtEntity>>,
          List<DebtEntity>,
          FutureOr<List<DebtEntity>>
        >
    with $FutureModifier<List<DebtEntity>>, $FutureProvider<List<DebtEntity>> {
  AllDebtsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allDebtsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allDebtsHash();

  @$internal
  @override
  $FutureProviderElement<List<DebtEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DebtEntity>> create(Ref ref) {
    return allDebts(ref);
  }
}

String _$allDebtsHash() => r'6e6f46b3ff9215edc004415622177c91642b4745';

@ProviderFor(debtSummary)
final debtSummaryProvider = DebtSummaryProvider._();

final class DebtSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<DebtSummary>,
          DebtSummary,
          FutureOr<DebtSummary>
        >
    with $FutureModifier<DebtSummary>, $FutureProvider<DebtSummary> {
  DebtSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtSummaryHash();

  @$internal
  @override
  $FutureProviderElement<DebtSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DebtSummary> create(Ref ref) {
    return debtSummary(ref);
  }
}

String _$debtSummaryHash() => r'7ff18f71a6d474666ec9c41b8fc66fec2729901a';

@ProviderFor(DebtController)
final debtControllerProvider = DebtControllerProvider._();

final class DebtControllerProvider
    extends $AsyncNotifierProvider<DebtController, void> {
  DebtControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debtControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$debtControllerHash();

  @$internal
  @override
  DebtController create() => DebtController();
}

String _$debtControllerHash() => r'90d43b1bde23411b66005822388ed3ae1e62130e';

abstract class _$DebtController extends $AsyncNotifier<void> {
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
