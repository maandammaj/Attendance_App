// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(companies)
final companiesProvider = CompaniesProvider._();

final class CompaniesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CompanyEntity>>,
          List<CompanyEntity>,
          FutureOr<List<CompanyEntity>>
        >
    with
        $FutureModifier<List<CompanyEntity>>,
        $FutureProvider<List<CompanyEntity>> {
  CompaniesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companiesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companiesHash();

  @$internal
  @override
  $FutureProviderElement<List<CompanyEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CompanyEntity>> create(Ref ref) {
    return companies(ref);
  }
}

String _$companiesHash() => r'f7715666dc017dc21d138530eb724a9f4be7eb4a';

/// الجهة المعروضة حالياً. كل شاشة دوام أو راتب أو تقرير تقرأ منها.
///
/// تراقب `profileProvider` لأن المؤشر مخزَّن فيه: تبديل الجهة يحدّث الملف
/// فتُعاد قراءة هذه تلقائياً ومعها كل ما يعتمد عليها.

@ProviderFor(activeCompany)
final activeCompanyProvider = ActiveCompanyProvider._();

/// الجهة المعروضة حالياً. كل شاشة دوام أو راتب أو تقرير تقرأ منها.
///
/// تراقب `profileProvider` لأن المؤشر مخزَّن فيه: تبديل الجهة يحدّث الملف
/// فتُعاد قراءة هذه تلقائياً ومعها كل ما يعتمد عليها.

final class ActiveCompanyProvider
    extends
        $FunctionalProvider<
          AsyncValue<CompanyEntity?>,
          CompanyEntity?,
          FutureOr<CompanyEntity?>
        >
    with $FutureModifier<CompanyEntity?>, $FutureProvider<CompanyEntity?> {
  /// الجهة المعروضة حالياً. كل شاشة دوام أو راتب أو تقرير تقرأ منها.
  ///
  /// تراقب `profileProvider` لأن المؤشر مخزَّن فيه: تبديل الجهة يحدّث الملف
  /// فتُعاد قراءة هذه تلقائياً ومعها كل ما يعتمد عليها.
  ActiveCompanyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeCompanyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeCompanyHash();

  @$internal
  @override
  $FutureProviderElement<CompanyEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<CompanyEntity?> create(Ref ref) {
    return activeCompany(ref);
  }
}

String _$activeCompanyHash() => r'2891313d63cc0020d20dabe5f98e7658344a80d7';

@ProviderFor(CompanyController)
final companyControllerProvider = CompanyControllerProvider._();

final class CompanyControllerProvider
    extends $AsyncNotifierProvider<CompanyController, void> {
  CompanyControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'companyControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$companyControllerHash();

  @$internal
  @override
  CompanyController create() => CompanyController();
}

String _$companyControllerHash() => r'a8f428edf789cbab1aee3fd32de0272be812716c';

abstract class _$CompanyController extends $AsyncNotifier<void> {
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
