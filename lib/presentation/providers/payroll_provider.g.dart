// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payroll_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// دخل المستخدم من كل جهاته في شهر.
///
/// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
/// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».

@ProviderFor(personalPayroll)
final personalPayrollProvider = PersonalPayrollFamily._();

/// دخل المستخدم من كل جهاته في شهر.
///
/// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
/// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».

final class PersonalPayrollProvider
    extends
        $FunctionalProvider<
          AsyncValue<PersonalPayroll>,
          PersonalPayroll,
          FutureOr<PersonalPayroll>
        >
    with $FutureModifier<PersonalPayroll>, $FutureProvider<PersonalPayroll> {
  /// دخل المستخدم من كل جهاته في شهر.
  ///
  /// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
  /// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».
  PersonalPayrollProvider._({
    required PersonalPayrollFamily super.from,
    required ({int year, int month}) super.argument,
  }) : super(
         retry: null,
         name: r'personalPayrollProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$personalPayrollHash();

  @override
  String toString() {
    return r'personalPayrollProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<PersonalPayroll> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PersonalPayroll> create(Ref ref) {
    final argument = this.argument as ({int year, int month});
    return personalPayroll(ref, year: argument.year, month: argument.month);
  }

  @override
  bool operator ==(Object other) {
    return other is PersonalPayrollProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$personalPayrollHash() => r'897c2d3da2ba85154ea363ed9f129486ce235502';

/// دخل المستخدم من كل جهاته في شهر.
///
/// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
/// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».

final class PersonalPayrollFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PersonalPayroll>,
          ({int year, int month})
        > {
  PersonalPayrollFamily._()
    : super(
        retry: null,
        name: r'personalPayrollProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// دخل المستخدم من كل جهاته في شهر.
  ///
  /// المزوّد الوحيد الذي يقرأ الجهات كلها عمداً — بقية القراءات مُرشَّحة بجهة
  /// واحدة، وهذه تجيب سؤالاً لا معنى له داخل جهة: «كم دخلي هذا الشهر».

  PersonalPayrollProvider call({required int year, required int month}) =>
      PersonalPayrollProvider._(
        argument: (year: year, month: month),
        from: this,
      );

  @override
  String toString() => r'personalPayrollProvider';
}
