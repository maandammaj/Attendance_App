import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/profile/get_profile_usecase.dart';
import '../../domain/usecases/profile/update_profile_usecase.dart';

part 'profile_provider.g.dart';

final profileRepositoryProvider = Provider((ref) => ProfileRepositoryImpl());

final getProfileUseCaseProvider = Provider(
      (ref) => GetProfileUseCase(ref.read(profileRepositoryProvider)),
);

final updateProfileUseCaseProvider = Provider(
      (ref) => UpdateProfileUseCase(ref.read(profileRepositoryProvider)),
);

@riverpod
Future<ProfileEntity?> profile(Ref ref) async {
  final useCase = ref.read(getProfileUseCaseProvider);
  return await useCase();
}

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() => null;

  Future<void> saveProfile(ProfileEntity profile) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(updateProfileUseCaseProvider);
      await useCase(profile);
      ref.invalidate(profileProvider);
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
