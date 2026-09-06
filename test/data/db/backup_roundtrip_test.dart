import 'dart:convert';

import 'package:attendance_budget_app/core/services/backup/backup_payload.dart';
import 'package:attendance_budget_app/core/services/backup/backup_service.dart';
import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/calendar_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/leave_repository_impl.dart';
import 'package:attendance_budget_app/domain/entities/calendar_day_entity.dart';
import 'package:attendance_budget_app/data/models/attendance_model.dart';
import 'package:attendance_budget_app/data/models/company_model.dart';
import 'package:attendance_budget_app/domain/entities/leave_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  const service = BackupService();

  setUp(() async => db = await TestDatabase.open());
  tearDown(() async => db.close());

  Future<void> seed() async {
    final company = await db.addCompany(
        name: 'أ', hourlyRate: 10, hoursPerDay: 8, annualLeaveDays: 20);
    await db.setActiveCompany(company);

    await AttendanceRepositoryImpl().addManualRecord(
      date: DateTime(2026, 8, 3),
      checkIn: DateTime(2026, 8, 3, 8),
      checkOut: DateTime(2026, 8, 3, 16),
    );
    await CalendarRepositoryImpl().mark(
        date: DateTime(2026, 8, 10),
        kind: CalendarDayKindEntity.publicHoliday);
    await LeaveRepositoryImpl().add(
      from: DateTime(2026, 8, 17),
      to: DateTime(2026, 8, 18),
      type: LeaveTypeEntity.annual,
    );
  }

  test('دورة كاملة: تصدير ثم استعادة تُعيد نفس الأعداد', () async {
    await seed();
    final before = await service.export();
    final json = jsonEncode(before.toJson());

    final report = await service.restoreJson(json);

    expect(report.isClean, isTrue,
        reason: 'نسخة سليمة أبلغت عن مشاكل');
    expect(report.rowsDropped, 0);
    expect(report.isVerified, isTrue,
        reason: 'ما في القاعدة يخالف ما كُتب');

    final after = await service.export();
    expect(after.rowCount, before.rowCount);
  });

  test('صفوف تشير إلى جهة محذوفة تُسقط ولا تصير بيانات غير مرئية', () async {
    await seed();
    final payload = await service.export();

    // نسخة معطوبة: سجل دوام لجهة لا وجود لها.
    final tables = {
      for (final e in payload.tables.entries) e.key: [...e.value],
    };
    tables['attendance']!.add({
      ...tables['attendance']!.first,
      'id': 9999,
      'companyId': 424242,
    });

    final report = await service.restore(BackupPayload(
      version: BackupPayload.currentVersion,
      createdAt: payload.createdAt,
      appVersion: payload.appVersion,
      tables: tables,
    ));

    expect(report.rowsDropped, 1);
    expect(report.issues.single.message, contains('سجلات الدوام'));

    // الصف المعطوب لم يُكتب: القاعدة تحوي سجل الدوام الأصلي وحده.
    expect(await db.isar.attendanceModels.count(), 1);
    expect(report.isVerified, isTrue);
  });

  test('نسخة من إصدار أحدث تُرفض قبل مسح أي شيء', () async {
    await seed();
    final countBefore = await db.isar.attendanceModels.count();

    final future = service.restoreJson(jsonEncode({
      'version': BackupPayload.currentVersion + 1,
      'createdAt': DateTime(2026).toIso8601String(),
      'appVersion': '9.9.9',
      'tables': <String, dynamic>{},
    }));

    await expectLater(future, throwsA(isA<BackupFormatException>()));
    expect(await db.isar.attendanceModels.count(), countBefore,
        reason: 'مُسحت البيانات قبل رفض النسخة');
  });

  test('نسخة بلا جهات تُرفض ولا تمسّ القاعدة', () async {
    await seed();
    final countBefore = await db.isar.companyModels.count();

    final future = service.restore(BackupPayload(
      version: BackupPayload.currentVersion,
      createdAt: DateTime(2026),
      appVersion: '1.0.0',
      tables: {
        'attendance': [
          {'id': 1, 'companyId': 1, 'date': DateTime(2026).toIso8601String()}
        ],
      },
    ));

    await expectLater(future, throwsA(isA<BackupFormatException>()));
    expect(await db.isar.companyModels.count(), countBefore);
  });
}
