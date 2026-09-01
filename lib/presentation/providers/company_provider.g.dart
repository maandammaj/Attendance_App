// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companiesHash() => r'f7715666dc017dc21d138530eb724a9f4be7eb4a';

/// See also [companies].
@ProviderFor(companies)
final companiesProvider =
    AutoDisposeFutureProvider<List<CompanyEntity>>.internal(
      companies,
      name: r'companiesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companiesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CompaniesRef = AutoDisposeFutureProviderRef<List<CompanyEntity>>;
String _$activeCompanyHash() => r'6b7bda9dea8bfa05677f6a1c086dfbe0f1eeab52';

/// الجهة المعروضة حالياً. كل شاشة دوام أو راتب أو تقرير تقرأ منها.
///
/// تراقب `profileProvider` لأن المؤشر مخزَّن فيه: تبديل الجهة يحدّث الملف
/// فتُعاد قراءة هذه تلقائياً ومعها كل ما يعتمد عليها.
///
/// Copied from [activeCompany].
@ProviderFor(activeCompany)
final activeCompanyProvider =
    AutoDisposeFutureProvider<CompanyEntity?>.internal(
      activeCompany,
      name: r'activeCompanyProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$activeCompanyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActiveCompanyRef = AutoDisposeFutureProviderRef<CompanyEntity?>;
String _$companyControllerHash() => r'e5ebfcdadadff48614b5174f7ac1803be2ea4526';

/// See also [CompanyController].
@ProviderFor(CompanyController)
final companyControllerProvider =
    AsyncNotifierProvider<CompanyController, void>.internal(
      CompanyController.new,
      name: r'companyControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$companyControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CompanyController = AsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
