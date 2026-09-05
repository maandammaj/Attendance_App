import 'dart:io';

import 'package:attendance_budget_app/data/local/database/isar_database.dart';
import 'package:attendance_budget_app/data/models/company_model.dart';
import 'package:attendance_budget_app/data/models/profile_model.dart';
import 'package:isar_community/isar.dart';

/// قاعدة حقيقية على القرص لكل اختبار، محقونة في [IsarDatabase].
///
/// المستودعات تصل إلى القاعدة عبر مفرد ساكن، فاختبارها بلا قاعدة فعلية
/// يعني اختبار محاكاة لها — وهي بالضبط الطبقة التي ظهرت فيها أعطال الفصل
/// بين الجهات.
class TestDatabase {
  TestDatabase._(this.isar, this._dir);

  final Isar isar;
  final Directory _dir;

  static Future<TestDatabase> open() async {
    await Isar.initializeIsarCore(download: true);
    final dir = await Directory.systemTemp.createTemp('attendance_test');
    final isar = await Isar.open(
      IsarDatabase.schemas,
      directory: dir.path,
      inspector: false,
    );
    IsarDatabase.overrideInstance(isar);
    return TestDatabase._(isar, dir);
  }

  Future<void> close() async {
    IsarDatabase.overrideInstance(null);
    await isar.close(deleteFromDisk: true);
    if (_dir.existsSync()) _dir.deleteSync(recursive: true);
  }

  /// جهة عمل بجدول موحّد لكل أيام الأسبوع، ليبقى الحساب متوقّعاً.
  Future<int> addCompany({
    required String name,
    required double hourlyRate,
    required int hoursPerDay,
    double overtimeRate = 1.5,
    double baseMonthlySalary = 0,
    String? startTime,
    String? endTime,
  }) async {
    final company = CompanyModel()
      ..name = name
      ..jobTitle = 'موظف'
      ..baseMonthlySalary = baseMonthlySalary
      ..hourlyRate = hourlyRate
      ..overtimeRate = overtimeRate
      ..workSchedule = [
        for (var day = 1; day <= 7; day++)
          WorkDayConfig()
            ..dayOfWeek = day
            ..isWorkingDay = true
            ..requiredHours = hoursPerDay
            ..requiredMinutes = 0
            ..isHoliday = false
            ..startTime = startTime
            ..endTime = endTime
            ..isCrossDay = false,
      ]
      ..adjustments = []
      ..createdAt = DateTime(2026)
      ..updatedAt = DateTime(2026);

    late int id;
    await isar.writeTxn(() async {
      id = await isar.companyModels.put(company);
    });
    return id;
  }

  Future<void> setActiveCompany(int companyId) async {
    await isar.writeTxn(() async {
      await isar.profileModels.put(ProfileModel()
        ..id = 0
        ..fullName = 'مستخدم'
        ..activeCompanyId = companyId
        ..updatedAt = DateTime(2026));
    });
  }
}
