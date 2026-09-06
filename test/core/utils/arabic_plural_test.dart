import 'package:attendance_budget_app/core/utils/arabic_plural.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('صياغة العدد بالعربية', () {
    test('جهات العمل', () {
      expect(ArabicPlural.workplaces(0), 'لا جهات');
      expect(ArabicPlural.workplaces(1), 'جهة واحدة');
      expect(ArabicPlural.workplaces(2), 'جهتين');
      expect(ArabicPlural.workplaces(3), '3 جهات');
      expect(ArabicPlural.workplaces(10), '10 جهات');
      // ما بعد العشرة يعود إلى المفرد في العربية.
      expect(ArabicPlural.workplaces(11), '11 جهة');
    });

    test('الأيام', () {
      expect(ArabicPlural.days(1), 'يوم واحد');
      expect(ArabicPlural.days(2), 'يومين');
      expect(ArabicPlural.days(5), '5 أيام');
      expect(ArabicPlural.days(30), '30 يوماً');
    });
  });
}
