import 'dart:developer' as developer;

import 'package:isar_community/isar.dart';

import '../../models/attendance_model.dart';
import '../../models/transaction_model.dart';
import '../../models/debt_model.dart';
import '../../models/account_model.dart';
import '../../models/budget_limit_model.dart';
import '../../models/company_model.dart';
import '../../models/profile_model.dart';

/// يحوّل قاعدة ما قبل تعدّد الجهات إلى واحدة تدعمه.
///
/// يبني جهة أولى من حقول `legacy*` في الملف الشخصي ويسند إليها كل سجلات
/// الدوام القائمة، فلا يفقد من رقّى التطبيق راتبه ولا جدوله ولا تاريخه.
/// يعمل عند كل `Isar.open` ولا يفعل شيئاً بعد أول مرة.
class CompanyMigration {
  CompanyMigration._();

  /// يتبنّى السجلات التي تحمل `companyId = 0`.
  ///
  /// نسخة سابقة من `_newRecord` لم تكن تختم السجل بجهته، فكُتبت سجلات لا
  /// تنتمي لأي جهة. هي غير مرئية لكل استعلام مُرشَّح بالجهة: تظهر الجلسة
  /// مفتوحة في الواجهة بينما لا يجدها الانصراف — "لا توجد جلسة دوام مفتوحة".
  /// تُسنَد للجهة الفعّالة، فبياناتها تعود للظهور بدل أن تُفقد.
  static Future<void> _adoptOrphans(Isar isar, ProfileModel profile) async {
    final attendance =
        await isar.attendanceModels.filter().companyIdEqualTo(0).findAll();
    final transactions =
        await isar.transactionModels.filter().companyIdEqualTo(0).findAll();
    final debts = await isar.debtModels.filter().companyIdEqualTo(0).findAll();
    final accounts =
        await isar.accountModels.filter().companyIdEqualTo(0).findAll();
    final limits =
        await isar.budgetLimitModels.filter().companyIdEqualTo(0).findAll();

    if (attendance.isEmpty &&
        transactions.isEmpty &&
        debts.isEmpty &&
        accounts.isEmpty &&
        limits.isEmpty) {
      return;
    }

    final target = profile.activeCompanyId ??
        (await isar.companyModels
                .filter()
                .isArchivedEqualTo(false)
                .findFirst())
            ?.id;
    if (target == null) return;

    await isar.writeTxn(() async {
      for (final r in attendance) {
        r.companyId = target;
      }
      for (final r in transactions) {
        r.companyId = target;
      }
      for (final r in debts) {
        r.companyId = target;
      }
      for (final r in accounts) {
        r.companyId = target;
      }
      for (final r in limits) {
        r.companyId = target;
      }
      if (attendance.isNotEmpty) await isar.attendanceModels.putAll(attendance);
      if (transactions.isNotEmpty) {
        await isar.transactionModels.putAll(transactions);
      }
      if (debts.isNotEmpty) await isar.debtModels.putAll(debts);
      if (accounts.isNotEmpty) await isar.accountModels.putAll(accounts);
      if (limits.isNotEmpty) await isar.budgetLimitModels.putAll(limits);
    });

    developer.log(
      'تُبنّيت سجلات بلا جهة: ${attendance.length} دوام، '
      '${transactions.length} حركة، ${debts.length} دين',
      name: 'db.migration',
      level: 900,
    );
  }

  static Future<void> run(Isar isar) async {
    final profile = await isar.profileModels.get(0);
    if (profile == null) return;

    final hasCompany = await isar.companyModels.count() > 0;
    if (hasCompany) {
      await _adoptOrphans(isar, profile);
      return;
    }

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
      final attendance =
          await isar.attendanceModels.filter().companyIdEqualTo(0).findAll();
      for (final record in attendance) {
        record.companyId = companyId;
      }
      if (attendance.isNotEmpty) {
        await isar.attendanceModels.putAll(attendance);
      }

      final transactions =
          await isar.transactionModels.filter().companyIdEqualTo(0).findAll();
      for (final record in transactions) {
        record.companyId = companyId;
      }
      if (transactions.isNotEmpty) {
        await isar.transactionModels.putAll(transactions);
      }

      final debts =
          await isar.debtModels.filter().companyIdEqualTo(0).findAll();
      for (final record in debts) {
        record.companyId = companyId;
      }
      if (debts.isNotEmpty) await isar.debtModels.putAll(debts);

      final accounts =
          await isar.accountModels.filter().companyIdEqualTo(0).findAll();
      for (final record in accounts) {
        record.companyId = companyId;
      }
      if (accounts.isNotEmpty) await isar.accountModels.putAll(accounts);

      final limits =
          await isar.budgetLimitModels.filter().companyIdEqualTo(0).findAll();
      for (final record in limits) {
        record.companyId = companyId;
      }
      if (limits.isNotEmpty) await isar.budgetLimitModels.putAll(limits);

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
        'رُحّلت البيانات إلى جهة واحدة: ${attendance.length} دوام، '
        '${transactions.length} حركة، ${debts.length} دين، '
        '${accounts.length} حساب',
        name: 'db.migration',
        level: 500,
      );
    });
  }
}
