// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dashboardDataHash() => r'339a5e422398e8078753b87c699ecf574cb536df';

/// See also [dashboardData].
@ProviderFor(dashboardData)
final dashboardDataProvider = AutoDisposeFutureProvider<DashboardData>.internal(
  dashboardData,
  name: r'dashboardDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dashboardDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DashboardDataRef = AutoDisposeFutureProviderRef<DashboardData>;
String _$monthlyExpensesByCategoryHash() =>
    r'21915de1bc79ca00c48a1c2498a9ec2b3bf430be';

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

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
///
/// Copied from [monthlyExpensesByCategory].
@ProviderFor(monthlyExpensesByCategory)
const monthlyExpensesByCategoryProvider = MonthlyExpensesByCategoryFamily();

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
///
/// Copied from [monthlyExpensesByCategory].
class MonthlyExpensesByCategoryFamily
    extends Family<AsyncValue<List<CategoryBreakdownItem>>> {
  /// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
  ///
  /// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
  ///
  /// Copied from [monthlyExpensesByCategory].
  const MonthlyExpensesByCategoryFamily();

  /// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
  ///
  /// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
  ///
  /// Copied from [monthlyExpensesByCategory].
  MonthlyExpensesByCategoryProvider call({
    required int year,
    required int month,
  }) {
    return MonthlyExpensesByCategoryProvider(year: year, month: month);
  }

  @override
  MonthlyExpensesByCategoryProvider getProviderOverride(
    covariant MonthlyExpensesByCategoryProvider provider,
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
  String? get name => r'monthlyExpensesByCategoryProvider';
}

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
///
/// Copied from [monthlyExpensesByCategory].
class MonthlyExpensesByCategoryProvider
    extends AutoDisposeFutureProvider<List<CategoryBreakdownItem>> {
  /// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
  ///
  /// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
  ///
  /// Copied from [monthlyExpensesByCategory].
  MonthlyExpensesByCategoryProvider({required int year, required int month})
    : this._internal(
        (ref) => monthlyExpensesByCategory(
          ref as MonthlyExpensesByCategoryRef,
          year: year,
          month: month,
        ),
        from: monthlyExpensesByCategoryProvider,
        name: r'monthlyExpensesByCategoryProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$monthlyExpensesByCategoryHash,
        dependencies: MonthlyExpensesByCategoryFamily._dependencies,
        allTransitiveDependencies:
            MonthlyExpensesByCategoryFamily._allTransitiveDependencies,
        year: year,
        month: month,
      );

  MonthlyExpensesByCategoryProvider._internal(
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
    FutureOr<List<CategoryBreakdownItem>> Function(
      MonthlyExpensesByCategoryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MonthlyExpensesByCategoryProvider._internal(
        (ref) => create(ref as MonthlyExpensesByCategoryRef),
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
  AutoDisposeFutureProviderElement<List<CategoryBreakdownItem>>
  createElement() {
    return _MonthlyExpensesByCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyExpensesByCategoryProvider &&
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
mixin MonthlyExpensesByCategoryRef
    on AutoDisposeFutureProviderRef<List<CategoryBreakdownItem>> {
  /// The parameter `year` of this provider.
  int get year;

  /// The parameter `month` of this provider.
  int get month;
}

class _MonthlyExpensesByCategoryProviderElement
    extends AutoDisposeFutureProviderElement<List<CategoryBreakdownItem>>
    with MonthlyExpensesByCategoryRef {
  _MonthlyExpensesByCategoryProviderElement(super.provider);

  @override
  int get year => (origin as MonthlyExpensesByCategoryProvider).year;
  @override
  int get month => (origin as MonthlyExpensesByCategoryProvider).month;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
