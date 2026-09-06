import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  late AttendanceRepositoryImpl repository;
  late int companyA;

  final from = DateTime(2026, 7, 1);
  final to = DateTime(2026, 7, 31);

  setUp(() async {
    db = await TestDatabase.open();
    companyA = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    await db.setActiveCompany(companyA);
    repository = AttendanceRepositoryImpl();
  });

  tearDown(() async => db.close());

  test('جلسة يدوية متداخلة تُرفض ولا تُكتب', () async {
    await repository.addManualRecord(
      date: DateTime(2026, 7, 6),
      checkIn: DateTime(2026, 7, 6, 9),
      checkOut: DateTime(2026, 7, 6, 13),
    );

    await expectLater(
      repository.addManualRecord(
        date: DateTime(2026, 7, 6),
        checkIn: DateTime(2026, 7, 6, 12),
        checkOut: DateTime(2026, 7, 6, 17),
      ),
      throwsA(predicate((e) => '$e'.contains('تتداخل'))),
    );

    final record =
        (await repository.getRecordsForCompany(companyA, from, to)).single;
    expect(record.sessions, hasLength(1), reason: 'كُتبت جلسة متداخلة');
    expect(record.totalPresenceMinutes, 240);
  });

  test('جلسة يدوية متتالية تُقبل وتُجمع', () async {
    await repository.addManualRecord(
      date: DateTime(2026, 7, 7),
      checkIn: DateTime(2026, 7, 7, 8),
      checkOut: DateTime(2026, 7, 7, 12),
    );
    await repository.addManualRecord(
      date: DateTime(2026, 7, 7),
      checkIn: DateTime(2026, 7, 7, 13),
      checkOut: DateTime(2026, 7, 7, 17),
    );

    final record =
        (await repository.getRecordsForCompany(companyA, from, to)).single;
    expect(record.sessions, hasLength(2));
    expect(record.totalPresenceMinutes, 480);
  });

  test('التداخل عبر جهتين مسموح — لا تراه القاعدة أصلاً', () async {
    final companyB = await db.addCompany(name: 'ب', hourlyRate: 20, hoursPerDay: 4);

    await repository.addManualRecord(
      date: DateTime(2026, 7, 8),
      checkIn: DateTime(2026, 7, 8, 9),
      checkOut: DateTime(2026, 7, 8, 17),
    );

    await db.setActiveCompany(companyB);
    await repository.addManualRecord(
      date: DateTime(2026, 7, 8),
      checkIn: DateTime(2026, 7, 8, 16),
      checkOut: DateTime(2026, 7, 8, 20),
    );

    expect(await repository.getRecordsForCompany(companyA, from, to), hasLength(1));
    expect(await repository.getRecordsForCompany(companyB, from, to), hasLength(1));
  });
}
