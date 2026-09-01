import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/profile/get_profile_usecase.dart';
import '../../domain/usecases/profile/update_profile_usecase.dart';

part 'profile_provider.g.dart';

// مُصرَّح بنوع العقد لا التنفيذ، حتى تستطيع الاختبارات استبداله ببديل يدوي.
final profileRepositoryProvider =
    Provider<ProfileRepository>((ref) => ProfileRepositoryImpl());

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

// keepAlive: هذه المتحكّمات بعمر التطبيق لا بعمر شاشة. بدونها يُتلَف
// المتحكّم حين تُبدَّل شاشته أثناء عملية جارية — بوابة الإعداد تفعل ذلك فور
// إنشاء أول جهة — فتُكتب الحالة على مزوّد مُتلَف ويُرمى
// "Bad state: Future already completed".
@Riverpod(keepAlive: true)
class ProfileController extends _$ProfileController {
  @override
  FutureOr<void> build() => null;

  Future<void> saveProfile(ProfileEntity profile) async {
    state = const AsyncLoading();
    try {
      final useCase = ref.read(updateProfileUseCaseProvider);
      await useCase(profile);
      ref.invalidate(profileProvider);
      // لا إعادة جدولة هنا: جدول الدوام صار خاصية جهة، فـ CompanyController
      // يملك ذلك. وانتظار activeCompanyProvider بعد إبطال profileProvider —
      // وهو يراقبه — كان يُدخل المزوّد في حلقة ويرمي "Future already completed".
      state = const AsyncData(null);
    } catch (e, stack) {
      state = AsyncError(e, stack);
    }
  }
}
