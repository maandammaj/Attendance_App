import 'package:attendance_budget_app/data/local/repositories/attendance_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_database.dart';

void main() {
  late TestDatabase db;
  late AttendanceRepositoryImpl repository;

  setUp(() async {
    db = await TestDatabase.open();
    repository = AttendanceRepositoryImpl();
  });

  tearDown(() async => db.close());

  group('تعديل سجل قديم يستخدم شروط جهته هو', () {
    test('تبديل الجهة بعد الحضور لا يغيّر قيمة السجل السابق', () async {
      // أجر الساعة يختلف عشرة أضعاف بين الجهتين، فأي خلط يظهر في الرقم.
      final cheap = await db.addCompany(
          name: 'المستشفى', hourlyRate: 10, hoursPerDay: 8);
      final rich = await db.addCompany(
          name: 'عمل حر', hourlyRate: 100, hoursPerDay: 4);
      await db.setActiveCompany(cheap);

      final day = DateTime(2026, 3, 2, 8);
      await repository.checkIn(day, companyId: cheap);
      await repository.checkOut(day.add(const Duration(hours: 10)));

      final before = (await repository.getRecordsForCompany(
              cheap, DateTime(2026, 3, 1), DateTime(2026, 3, 31)))
          .single;
      // ساعتان إضافيتان × (10 × 1.5) = 30
      expect(before.overtimeValue, closeTo(30, 0.001));

      // المستخدم ينتقل إلى الجهة الأخرى ثم يعدّل ملاحظة اليوم القديم.
      await db.setActiveCompany(rich);
      await repository.updateRecord(before);

      final after = (await repository.getRecordsForCompany(
              cheap, DateTime(2026, 3, 1), DateTime(2026, 3, 31)))
          .single;

      // بأجر الجهة الفعّالة كانت ستصير 2 × 150 = 300.
      expect(after.overtimeValue, closeTo(30, 0.001),
          reason: 'أُعيد الحساب بأجر جهة أخرى');
      expect(after.companyId, cheap);
    });

    test('السجل يبقى في جهته بعد التعديل', () async {
      final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
      final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);
      await db.setActiveCompany(a);

      final day = DateTime(2026, 3, 3, 9);
      await repository.checkIn(day, companyId: a);
      await repository.checkOut(day.add(const Duration(hours: 8)));

      final record = (await repository.getRecordsForCompany(
              a, DateTime(2026, 3, 1), DateTime(2026, 3, 31)))
          .single;

      await db.setActiveCompany(b);
      await repository.updateRecord(record);

      expect(
        await repository.getRecordsForCompany(
            b, DateTime(2026, 3, 1), DateTime(2026, 3, 31)),
        isEmpty,
        reason: 'هاجر السجل إلى الجهة الفعّالة',
      );
      expect(
        await repository.getRecordsForCompany(
            a, DateTime(2026, 3, 1), DateTime(2026, 3, 31)),
        hasLength(1),
      );
    });
  });

  group('عزل الجهات في الاستعلامات', () {
    test('كل جهة ترى سجلاتها وحدها', () async {
      final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
      final b = await db.addCompany(name: 'ب', hourlyRate: 20, hoursPerDay: 4);

      await db.setActiveCompany(a);
      await repository.checkIn(DateTime(2026, 3, 4, 8), companyId: a);
      await repository.checkOut(DateTime(2026, 3, 4, 16));

      await db.setActiveCompany(b);
      await repository.checkIn(DateTime(2026, 3, 4, 18), companyId: b);
      await repository.checkOut(DateTime(2026, 3, 4, 22));

      final from = DateTime(2026, 3, 1);
      final to = DateTime(2026, 3, 31);
      expect(await repository.getRecordsForCompany(a, from, to), hasLength(1));
      expect(await repository.getRecordsForCompany(b, from, to), hasLength(1));

      // الجهة الفعّالة هي ب: القراءة غير المقيّدة يجب أن تراها وحدها.
      final scoped = await repository.getRecordsBetween(from, to);
      expect(scoped, hasLength(1));
      expect(scoped.single.companyId, b);
    });

    test('الانصراف يغلق جلسة الجهة التي فُتحت فيها بعد التبديل', () async {
      final a = await db.addCompany(name: 'أ', hourlyRate: 10, hoursPerDay: 8);
      final b = await db.addCompany(name: 'ب', hourlyRate: 10, hoursPerDay: 8);

      await db.setActiveCompany(a);
      await repository.checkIn(DateTime(2026, 3, 5, 8), companyId: a);

      // المستخدم يبدّل الجهة ثم يضغط انصراف.
      await db.setActiveCompany(b);
      await repository.checkOut(DateTime(2026, 3, 5, 16));

      final record = (await repository.getRecordsForCompany(
              a, DateTime(2026, 3, 1), DateTime(2026, 3, 31)))
          .single;
      expect(record.isOpen, isFalse);
      expect(record.workedHours, 8);
    });
  });
}
