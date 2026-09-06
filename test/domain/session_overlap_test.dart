import 'package:attendance_budget_app/domain/services/attendance_calculation_service.dart';
import 'package:attendance_budget_app/domain/services/session_overlap_rule.dart';
import 'package:flutter_test/flutter_test.dart';

SessionInput _s(int fromHour, int? toHour) => SessionInput(
      checkIn: DateTime(2026, 9, 5, fromHour),
      checkOut: toHour == null ? null : DateTime(2026, 9, 5, toHour),
    );

void main() {
  group('تداخل جلسات اليوم الواحد', () {
    test('جلستان متتاليتان بلا تداخل', () {
      expect(SessionOverlapRule.firstOverlap([_s(8, 12), _s(13, 17)]), isNull);
    });

    test('التلامس ليس تداخلاً', () {
      // تنتهي 12:00 وتبدأ 12:00 — لا دقيقة مشتركة.
      expect(SessionOverlapRule.firstOverlap([_s(8, 12), _s(12, 16)]), isNull);
    });

    test('تداخل صريح يُكتشف', () {
      expect(SessionOverlapRule.firstOverlap([_s(9, 13), _s(12, 17)]), isNotNull);
    });

    test('التداخل يُكتشف مهما كان ترتيب الإدخال', () {
      expect(SessionOverlapRule.firstOverlap([_s(12, 17), _s(9, 13)]), isNotNull);
    });

    test('جلسة داخل أخرى تماماً', () {
      expect(SessionOverlapRule.firstOverlap([_s(8, 18), _s(10, 12)]), isNotNull);
    });

    test('جلسة مفتوحة تتداخل مع لاحقة لها', () {
      // مفتوحة من 9، وجلسة مغلقة تنتهي 13 — أربع ساعات مشتركة.
      expect(SessionOverlapRule.firstOverlap([_s(9, null), _s(10, 13)]), isNotNull);
    });

    test('جلسة مفتوحة بعد جلسة مغلقة سليمة', () {
      expect(SessionOverlapRule.firstOverlap([_s(8, 12), _s(13, null)]), isNull);
    });

    test('قائمة فارغة أو جلسة واحدة سليمة', () {
      expect(SessionOverlapRule.firstOverlap(const []), isNull);
      expect(SessionOverlapRule.firstOverlap([_s(8, 16)]), isNull);
    });

    test('assertNoOverlap يرمي برسالة عربية', () {
      expect(
        () => SessionOverlapRule.assertNoOverlap([_s(9, 13), _s(12, 17)]),
        throwsA(predicate((e) => '$e'.contains('تتداخل'))),
      );
      expect(
        () => SessionOverlapRule.assertNoOverlap([_s(8, 12), _s(13, 17)]),
        returnsNormally,
      );
    });
  });
}
