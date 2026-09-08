import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:attendance_budget_app/data/local/repositories/calendar_repository_impl.dart';
import 'package:attendance_budget_app/domain/entities/calendar_day_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  late AttendanceRepositoryImpl attendance;
  late CalendarRepositoryImpl calendar;

  // 2026-09-26 سبت — يوم عمل في الجدول الموحّد.
  final holiday = DateTime(2026, 9, 26);
  final from = DateTime(2026, 9, 1);
  final to = DateTime(2026, 9, 30);

  setUp(() async {
    db = await TestDatabase.open();
    attendance = AttendanceRepositoryImpl();
    calendar = CalendarRepositoryImpl();
  });

  tearDown(() async => db.close());

  test('العطلة تحوّل كل التواجد إلى إضافي', () async {
    final company = await db.addCompany(
        name: 'أ', hourlyRate: 10, hoursPerDay: 8,
        startTime: '08:00', endTime: '16:00');
    await db.setActiveCompany(company);

    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.publicHoliday);

    await attendance.addManualRecord(
      date: holiday,
      checkIn: DateTime(2026, 9, 26, 9),
      checkOut: DateTime(2026, 9, 26, 13),
    );

    final record =
        (await attendance.getRecordsForCompany(company, from, to)).single;

    // أربع ساعات في يوم عطلة: لا مطلوب فلا عجز، وكلها إضافي.
    expect(record.requiredMinutes + record.requiredHours * 60, 0);
    expect(record.deficitValue, 0);
    expect(record.overtimeHours, 4);
    expect(record.overtimeValue, closeTo(4 * 15, 0.001));
  });

  test('اليوم نفسه عطلة في جهة ودوام في أخرى', () async {
    final hospital = await db.addCompany(
        name: 'مستشفى', hourlyRate: 10, hoursPerDay: 8,
        startTime: '08:00', endTime: '16:00');
    final freelance = await db.addCompany(
        name: 'عمل حر', hourlyRate: 10, hoursPerDay: 8,
        startTime: '08:00', endTime: '16:00');

    // عطلة رسمية عامة، ثم استثناء يخصّ العمل الحر وحده.
    await db.setActiveCompany(hospital);
    await calendar.mark(
        date: holiday,
        kind: CalendarDayKindEntity.publicHoliday,
        appliesToAllCompanies: true);

    await db.setActiveCompany(freelance);
    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.specialWorkday);

    // نفس التواجد في الجهتين.
    await db.setActiveCompany(hospital);
    await attendance.addManualRecord(
      date: holiday,
      checkIn: DateTime(2026, 9, 26, 9),
      checkOut: DateTime(2026, 9, 26, 13),
    );

    await db.setActiveCompany(freelance);
    await attendance.addManualRecord(
      date: holiday,
      checkIn: DateTime(2026, 9, 26, 9),
      checkOut: DateTime(2026, 9, 26, 13),
    );

    final atHospital =
        (await attendance.getRecordsForCompany(hospital, from, to)).single;
    final atFreelance =
        (await attendance.getRecordsForCompany(freelance, from, to)).single;

    // المستشفى: عطلة — كل التواجد إضافي ولا عجز.
    expect(atHospital.overtimeHours, 4);
    expect(atHospital.deficitValue, 0);

    // العمل الحر: دوام عادي — أربع ساعات من ثماني، فأربع عجزاً.
    expect(atFreelance.overtimeHours, 0,
        reason: 'سرت العطلة العامة على جهة استثنتها');
    expect(atFreelance.deficitHours, 4);
  });

  test('تعليم اليوم مرّتين يستبدل ولا يضاعف', () async {
    final company = await db.addCompany(
        name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    await db.setActiveCompany(company);

    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.publicHoliday);
    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.workplaceHoliday);

    final entries = await calendar.getForDate(holiday);
    expect(entries, hasLength(1));
    expect(entries.single.kind, CalendarDayKindEntity.workplaceHoliday);
  });

  test('حذف يوم جهة أخرى يُرفض', () async {
    final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
    final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);

    await db.setActiveCompany(a);
    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.workplaceHoliday);
    final entry = (await calendar.getForDate(holiday)).single;

    await db.setActiveCompany(b);
    await expectLater(calendar.unmark(entry.id), throwsA(isA<Exception>()));

    await db.setActiveCompany(a);
    expect(await calendar.getForDate(holiday), hasLength(1));
  });

  test('تعليم يوم عطلةً بعد تسجيله يُعيد تصنيفه', () async {
    final company = await db.addCompany(
        name: 'أ', hourlyRate: 10, hoursPerDay: 8,
        startTime: '08:00', endTime: '16:00');
    await db.setActiveCompany(company);

    await attendance.addManualRecord(
      date: holiday,
      checkIn: DateTime(2026, 9, 26, 9),
      checkOut: DateTime(2026, 9, 26, 13),
    );

    var record =
        (await attendance.getRecordsForCompany(company, from, to)).single;
    expect(record.dayType, isNot('holiday'));

    // يُعلَّم عطلةً بعد أن سُجّل الدوام، ثم يُعاد حسابه بتعديله.
    await calendar.mark(
        date: holiday, kind: CalendarDayKindEntity.publicHoliday);
    await attendance.updateRecord(record);

    record = (await attendance.getRecordsForCompany(company, from, to)).single;
    expect(record.dayType, 'holiday',
        reason: 'بقي السجل مصنّفاً يوم عمل بعد صيرورته عطلة');
    expect(record.overtimeHours, 4);
  });
}
