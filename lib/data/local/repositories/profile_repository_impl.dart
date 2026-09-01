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
    if (model == null) return null;
    return _mapToEntity(model);
  }

  @override
  Future<void> updateProfile(ProfileEntity entity) async {
    final isar = await _db;
    final model = _mapToModel(entity);
    await isar.writeTxn(() async {
      await isar.profileModels.put(model);
    });
  }

  ProfileEntity _mapToEntity(ProfileModel m) {
    return ProfileEntity(
      id: m.id,
      fullName: m.fullName,
      jobTitle: m.jobTitle,
      baseMonthlySalary: m.baseMonthlySalary,
      hourlyRate: m.hourlyRate,
      overtimeRate: m.overtimeRate,
      workSchedule: m.workSchedule
          .map((w) => WorkDayConfigEntity(
        dayOfWeek: w.dayOfWeek,
        isWorkingDay: w.isWorkingDay,
        requiredHours: w.requiredHours,
        requiredMinutes: w.requiredMinutes,
        isHoliday: w.isHoliday,
        startTime: w.startTime,
        endTime: w.endTime,
        isCrossDay: w.isCrossDay,
      ))
          .toList(),
      adjustments: m.adjustments.map((a) => SalaryAdjustmentEntity(
        title: a.title,
        amount: a.amount,
        isAddition: a.isAddition,
      )).toList(),
      currency: m.currency,
      companyName: m.companyName,
      employmentStartDate: m.employmentStartDate,
      updatedAt: m.updatedAt,
    );
  }

  ProfileModel _mapToModel(ProfileEntity e) {
    final model = ProfileModel()
      ..id = e.id
      ..fullName = e.fullName
      ..jobTitle = e.jobTitle
      ..baseMonthlySalary = e.baseMonthlySalary
      ..hourlyRate = e.hourlyRate
      ..overtimeRate = e.overtimeRate
      ..currency = e.currency
      ..companyName = e.companyName
      ..employmentStartDate = e.employmentStartDate
      ..updatedAt = e.updatedAt;

    model.workSchedule = e.workSchedule
        .map((w) => WorkDayConfig()
      ..dayOfWeek = w.dayOfWeek
      ..isWorkingDay = w.isWorkingDay
      ..requiredHours = w.requiredHours
      ..requiredMinutes = w.requiredMinutes
      ..isHoliday = w.isHoliday
      ..startTime = w.startTime
      ..endTime = w.endTime
      ..isCrossDay = w.isCrossDay)
        .toList();
        
    model.adjustments = e.adjustments.map((a) => SalaryAdjustment()
      ..title = a.title
      ..amount = a.amount
      ..isAddition = a.isAddition).toList();

    return model;
  }
}