// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(profile)
final profileProvider = ProfileProvider._();

final class ProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProfileEntity?>,
          ProfileEntity?,
          FutureOr<ProfileEntity?>
        >
    with $FutureModifier<ProfileEntity?>, $FutureProvider<ProfileEntity?> {
  ProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileHash();

  @$internal
  @override
  $FutureProviderElement<ProfileEntity?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProfileEntity?> create(Ref ref) {
    return profile(ref);
  }
}

String _$profileHash() => r'40f17f67f6e5c71aec1a8c1e1d685453c274b0f6';

@ProviderFor(ProfileController)
final profileControllerProvider = ProfileControllerProvider._();

final class ProfileControllerProvider
    extends $AsyncNotifierProvider<ProfileController, void> {
  ProfileControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileControllerHash();

  @$internal
  @override
  ProfileController create() => ProfileController();
}

String _$profileControllerHash() => r'd847dba3af4779331ea1107969809d1f8e685c20';

abstract class _$ProfileController extends $AsyncNotifier<void> {
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
