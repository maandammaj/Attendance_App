import 'dart:developer' as developer;

import 'package:isar_community/isar.dart';

import '../../models/attendance_model.dart';
import '../../models/company_model.dart';
import '../../models/profile_model.dart';

/// يحوّل قاعدة ما قبل تعدّد الجهات إلى واحدة تدعمه.
///
/// يبني جهة أولى من حقول `legacy*` في الملف الشخصي ويسند إليها كل سجلات
/// الدوام القائمة، فلا يفقد من رقّى التطبيق راتبه ولا جدوله ولا تاريخه.
/// يعمل عند كل `Isar.open` ولا يفعل شيئاً بعد أول مرة.
class CompanyMigration {
  CompanyMigration._();

  static Future<void> run(Isar isar) async {
    final profile = await isar.profileModels.get(0);
    if (profile == null) return;

    final hasCompany = await isar.companyModels.count() > 0;
    if (hasCompany) return;

    // لا شروط عمل قديمة: مستخدم جديد سينشئ جهته من شاشة الإعداد.
    if (profile.legacyBaseMonthlySalary == null &&
        profile.legacyWorkSchedule == null) {
      return;
    }

    final now = DateTime.now();
    final company = CompanyModel()
      ..name = profile.legacyCompanyName?.trim().isNotEmpty == true
          ? profile.legacyCompanyName!
          : 'جهة العمل'
      ..jobTitle = profile.legacyJobTitle ?? 'موظف'
      ..baseMonthlySalary = profile.legacyBaseMonthlySalary ?? 0
      ..hourlyRate = profile.legacyHourlyRate ?? 0
      ..overtimeRate = profile.legacyOvertimeRate ?? 1.5
      ..workSchedule = profile.legacyWorkSchedule ?? []
      ..adjustments = profile.legacyAdjustments ?? []
      ..currency = profile.currency
      ..employmentStartDate = profile.legacyEmploymentStartDate
      ..createdAt = now
      ..updatedAt = now;

    await isar.writeTxn(() async {
      final companyId = await isar.companyModels.put(company);

      // كل سجل قائم يخص الجهة الأولى بحكم أنه كُتب قبل وجود غيرها.
      final orphans =
          await isar.attendanceModels.filter().companyIdEqualTo(0).findAll();
      for (final record in orphans) {
        record.companyId = companyId;
      }
      if (orphans.isNotEmpty) {
        await isar.attendanceModels.putAll(orphans);
      }

      profile
        ..activeCompanyId = companyId
        ..legacyBaseMonthlySalary = null
        ..legacyHourlyRate = null
        ..legacyOvertimeRate = null
        ..legacyWorkSchedule = null
        ..legacyAdjustments = null
        ..legacyJobTitle = null
        ..legacyCompanyName = null
        ..legacyEmploymentStartDate = null
        ..updatedAt = now;
      await isar.profileModels.put(profile);

      developer.log(
        'رُحّلت البيانات إلى جهة واحدة: ${orphans.length} سجل دوام',
        name: 'db.migration',
        level: 500,
      );
    });
  }
}
