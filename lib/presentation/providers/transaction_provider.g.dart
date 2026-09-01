// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$transactionRepositoryHash() =>
    r'a2dbdcb2a01b77037ab59d95440c7488275b1566';

/// See also [transactionRepository].
@ProviderFor(transactionRepository)
final transactionRepositoryProvider =
    AutoDisposeProvider<TransactionRepositoryImpl>.internal(
      transactionRepository,
      name: r'transactionRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$transactionRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionRepositoryRef =
    AutoDisposeProviderRef<TransactionRepositoryImpl>;
String _$monthlyTransactionsHash() =>
    r'85270718b3c268d437ac3133239a8d9a05200f09';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [monthlyTransactions].
@ProviderFor(monthlyTransactions)
const monthlyTransactionsProvider = MonthlyTransactionsFamily();

/// See also [monthlyTransactions].
class MonthlyTransactionsFamily
    extends Family<AsyncValue<List<TransactionEntity>>> {
  /// See also [monthlyTransactions].
  const MonthlyTransactionsFamily();

  /// See also [monthlyTransactions].
  MonthlyTransactionsProvider call({required int year, required int month}) {
    return MonthlyTransactionsProvider(year: year, month: month);
  }

  @override
  MonthlyTransactionsProvider getProviderOverride(
    covariant MonthlyTransactionsProvider provider,
  ) {
    return call(year: provider.year, month: provider.month);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'monthlyTransactionsProvider';
}

/// See also [monthlyTransactions].
class MonthlyTransactionsProvider
    extends AutoDisposeFutureProvider<List<TransactionEntity>> {
  /// See also [monthlyTransactions].
  MonthlyTransactionsProvider({required int year, required int month})
    : this._internal(
        (ref) => monthlyTransactions(
          ref as MonthlyTransactionsRef,
          year: year,
          month: month,
        ),
        from: monthlyTransactionsProvider,
        name: r'monthlyTransactionsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$monthlyTransactionsHash,
        dependencies: MonthlyTransactionsFamily._dependencies,
        allTransitiveDependencies:
            MonthlyTransactionsFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlyTransactionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.year,
    required this.month,
  }) : super.internal();

  final int year;
  final int month;

  @override
  Override overrideWith(
    FutureOr<List<TransactionEntity>> Function(MonthlyTransactionsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyTransactionsProvider._internal(
        (ref) => create(ref as MonthlyTransactionsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        year: year,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<TransactionEntity>> createElement() {
    return _MonthlyTransactionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyTransactionsProvider &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, year.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MonthlyTransactionsRef
    on AutoDisposeFutureProviderRef<List<TransactionEntity>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyTransactionsProviderElement
    extends AutoDisposeFutureProviderElement<List<TransactionEntity>>
    with MonthlyTransactionsRef {
  _MonthlyTransactionsProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyTransactionsProvider).year;
  @override
  int get month => (origin as MonthlyTransactionsProvider).month;
}

String _$transactionControllerHash() =>
    r'ae938f046019b4ded989e722b1d48459c4c98327';

/// See also [TransactionController].
@ProviderFor(TransactionController)
final transactionControllerProvider =
    AutoDisposeAsyncNotifierProvider<TransactionController, void>.internal(
      TransactionController.new,
      name: r'transactionControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$transactionControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TransactionController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
