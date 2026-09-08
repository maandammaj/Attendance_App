import 'package:isar_community/isar.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../models/profile_model.dart';
import '../database/isar_database.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  Future<Isar> get _db async => await IsarDatabase.instance;

  @override
  Future<ProfileEntity?> getProfile() async {
    final isar = await _db;
    final model = await isar.profileModels.get(0);
    return model == null ? null : _mapToEntity(model);
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      // نقرأ الصف القائم لنحفظ `activeCompanyId` وحقول الترحيل: الكيان لا
      // يحمل كل ما في النموذج، والكتابة الكاملة كانت ستمحوها.
      final model = await isar.profileModels.get(0) ?? ProfileModel();
      model
        ..id = 0
        ..fullName = profile.fullName
        ..currency = profile.currency
        ..activeCompanyId = profile.activeCompanyId ?? model.activeCompanyId
        ..updatedAt = DateTime.now();
      await isar.profileModels.put(model);
    });
  }

  ProfileEntity _mapToEntity(ProfileModel m) {
    return ProfileEntity(
      id: m.id,
      fullName: m.fullName,
      activeCompanyId: m.activeCompanyId,
      currency: m.currency,
      updatedAt: m.updatedAt,
    );
  }
}
