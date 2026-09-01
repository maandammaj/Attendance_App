// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reminderSettingsHash() => r'cab030f6cc6c4f7d4a29c034a0716b27e75abf86';

/// See also [reminderSettings].
@ProviderFor(reminderSettings)
final reminderSettingsProvider =
    AutoDisposeFutureProvider<ReminderSettingsEntity>.internal(
      reminderSettings,
      name: r'reminderSettingsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reminderSettingsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReminderSettingsRef =
    AutoDisposeFutureProviderRef<ReminderSettingsEntity>;
String _$budgetLimitsHash() => r'bc0cc6349b38b93b93b50932093a1153cf040a71';

/// See also [budgetLimits].
@ProviderFor(budgetLimits)
final budgetLimitsProvider =
    AutoDisposeFutureProvider<List<BudgetLimitEntity>>.internal(
      budgetLimits,
      name: r'budgetLimitsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$budgetLimitsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BudgetLimitsRef = AutoDisposeFutureProviderRef<List<BudgetLimitEntity>>;
String _$budgetStatusHash() => r'220f1ae76c8100dd6e84139477f7b6c761fe0bb2';

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

/// See also [budgetStatus].
@ProviderFor(budgetStatus)
const budgetStatusProvider = BudgetStatusFamily();

/// See also [budgetStatus].
class BudgetStatusFamily extends Family<AsyncValue<List<BudgetStatusEntity>>> {
  /// See also [budgetStatus].
  const BudgetStatusFamily();

  /// See also [budgetStatus].
  BudgetStatusProvider call({required int year, required int month}) {
    return BudgetStatusProvider(year: year, month: month);
  }

  @override
  BudgetStatusProvider getProviderOverride(
    covariant BudgetStatusProvider provider,
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
  String? get name => r'budgetStatusProvider';
}

/// See also [budgetStatus].
class BudgetStatusProvider
    extends AutoDisposeFutureProvider<List<BudgetStatusEntity>> {
  /// See also [budgetStatus].
  BudgetStatusProvider({required int year, required int month})
    : this._internal(
        (ref) => budgetStatus(ref as BudgetStatusRef, year: year, month: month),
        from: budgetStatusProvider,
        name: r'budgetStatusProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$budgetStatusHash,
        dependencies: BudgetStatusFamily._dependencies,
        allTransitiveDependencies:
            BudgetStatusFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  BudgetStatusProvider._internal(
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
    FutureOr<List<BudgetStatusEntity>> Function(BudgetStatusRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BudgetStatusProvider._internal(
        (ref) => create(ref as BudgetStatusRef),
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
  AutoDisposeFutureProviderElement<List<BudgetStatusEntity>> createElement() {
    return _BudgetStatusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BudgetStatusProvider &&
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
mixin BudgetStatusRef
    on AutoDisposeFutureProviderRef<List<BudgetStatusEntity>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _BudgetStatusProviderElement
    extends AutoDisposeFutureProviderElement<List<BudgetStatusEntity>>
    with BudgetStatusRef {
  _BudgetStatusProviderElement(super.provider);

  @override
  int get year => (origin as BudgetStatusProvider).year;
  @override
  int get month => (origin as BudgetStatusProvider).month;
}

String _$reminderControllerHash() =>
    r'f72eca235da916c21bb97ddaad1f70d7e6086c4f';

/// See also [ReminderController].
@ProviderFor(ReminderController)
final reminderControllerProvider =
    AsyncNotifierProvider<ReminderController, void>.internal(
      ReminderController.new,
      name: r'reminderControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$reminderControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ReminderController = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
