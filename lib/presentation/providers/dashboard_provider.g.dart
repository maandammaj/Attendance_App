// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dashboardData)
final dashboardDataProvider = DashboardDataProvider._();

final class DashboardDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<DashboardData>,
          DashboardData,
          FutureOr<DashboardData>
        >
    with $FutureModifier<DashboardData>, $FutureProvider<DashboardData> {
  DashboardDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dashboardDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dashboardDataHash();

  @$internal
  @override
  $FutureProviderElement<DashboardData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DashboardData> create(Ref ref) {
    return dashboardData(ref);
  }
}

String _$dashboardDataHash() => r'2974b961215a9e7cf35e62a45251a3981e285762';

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.

@ProviderFor(monthlyExpensesByCategory)
final monthlyExpensesByCategoryProvider = MonthlyExpensesByCategoryFamily._();

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.

final class MonthlyExpensesByCategoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CategoryBreakdownItem>>,
          List<CategoryBreakdownItem>,
          FutureOr<List<CategoryBreakdownItem>>
        >
    with
        $FutureModifier<List<CategoryBreakdownItem>>,
        $FutureProvider<List<CategoryBreakdownItem>> {
  /// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
  ///
  /// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.
  MonthlyExpensesByCategoryProvider._({
    required MonthlyExpensesByCategoryFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'monthlyExpensesByCategoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyExpensesByCategoryHash();

  @override
  String toString() {
    return r'monthlyExpensesByCategoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<CategoryBreakdownItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CategoryBreakdownItem>> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return monthlyExpensesByCategory(
      ref,
      year: argument.year,
      month: argument.month,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyExpensesByCategoryProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyExpensesByCategoryHash() =>
    r'21915de1bc79ca00c48a1c2498a9ec2b3bf430be';

/// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
///
/// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.

final class MonthlyExpensesByCategoryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<CategoryBreakdownItem>>,
          ({int year, int month})
        > {
  MonthlyExpensesByCategoryFamily._()
    : super(
        retry: null,
        name: r'monthlyExpensesByCategoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// مصروفات شهر مجمّعة حسب الفئة، مرتّبة تنازلياً.
  ///
  /// مفصولة عن `dashboardData` حتى لا يعيد تغيّر الرسم حساب الراتب كله.

  MonthlyExpensesByCategoryProvider call({
    required int year,
    required int month,
  }) => MonthlyExpensesByCategoryProvider._(
    argument: (year: year, month: month),
    from: this,
  );

  @override
  String toString() => r'monthlyExpensesByCategoryProvider';
}
