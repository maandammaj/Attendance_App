// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(transactionRepository)
final transactionRepositoryProvider = TransactionRepositoryProvider._();

final class TransactionRepositoryProvider
    extends
        $FunctionalProvider<
          TransactionRepositoryImpl,
          TransactionRepositoryImpl,
          TransactionRepositoryImpl
        >
    with $Provider<TransactionRepositoryImpl> {
  TransactionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransactionRepositoryImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransactionRepositoryImpl create(Ref ref) {
    return transactionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransactionRepositoryImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransactionRepositoryImpl>(value),
    );
  }
}

String _$transactionRepositoryHash() =>
    r'a2dbdcb2a01b77037ab59d95440c7488275b1566';

@ProviderFor(monthlyTransactions)
final monthlyTransactionsProvider = MonthlyTransactionsFamily._();

final class MonthlyTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionEntity>>,
          List<TransactionEntity>,
          FutureOr<List<TransactionEntity>>
        >
    with
        $FutureModifier<List<TransactionEntity>>,
        $FutureProvider<List<TransactionEntity>> {
  MonthlyTransactionsProvider._({
    required MonthlyTransactionsFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'monthlyTransactionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyTransactionsHash();

  @override
  String toString() {
    return r'monthlyTransactionsProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<TransactionEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TransactionEntity>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return monthlyTransactions(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTransactionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyTransactionsHash() =>
    r'85270718b3c268d437ac3133239a8d9a05200f09';

final class MonthlyTransactionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TransactionEntity>>,
          ({int year, int month})
        > {
  MonthlyTransactionsFamily._()
    : super(
        retry: null,
        name: r'monthlyTransactionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlyTransactionsProvider call({required int year, required int month}) =>
      MonthlyTransactionsProvider._(
        argument: (year: year, month: month),
        from: this,
      );

  @override
  String toString() => r'monthlyTransactionsProvider';
}

@ProviderFor(TransactionController)
final transactionControllerProvider = TransactionControllerProvider._();

final class TransactionControllerProvider
    extends $AsyncNotifierProvider<TransactionController, void> {
  TransactionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transactionControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transactionControllerHash();

  @$internal
  @override
  TransactionController create() => TransactionController();
}

String _$transactionControllerHash() =>
    r'ae938f046019b4ded989e722b1d48459c4c98327';

abstract class _$TransactionController extends $AsyncNotifier<void> {
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
