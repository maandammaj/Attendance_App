// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allAccountsHash() => r'6b40abe319604361bcd3094c8394a4784d655230';

/// See also [allAccounts].
@ProviderFor(allAccounts)
final allAccountsProvider =
    AutoDisposeFutureProvider<List<AccountEntity>>.internal(
      allAccounts,
      name: r'allAccountsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allAccountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllAccountsRef = AutoDisposeFutureProviderRef<List<AccountEntity>>;
String _$accountControllerHash() => r'7e03eb357a006c303661e77bdfa0002fb69591fb';

/// See also [AccountController].
@ProviderFor(AccountController)
final accountControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountController, void>.internal(
      AccountController.new,
      name: r'accountControllerProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$accountControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountController = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
