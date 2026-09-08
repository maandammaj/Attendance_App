import 'package:attendance_budget_app/core/constants/app_constants.dart';
import 'package:attendance_budget_app/core/constants/currencies.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('العملة', () {
    test('كل عملة تُعرض بكلمة عربية لا برمز', () {
      final symbolish = RegExp(r'[.ـ$]|^[A-Za-z]+$');
      for (final currency in AppCurrency.all) {
        expect(currency.word, isNotEmpty);
        expect(symbolish.hasMatch(currency.word), isFalse,
            reason: '«${currency.word}» ما زالت رمزاً لا كلمة');
        expect(currency.fullName, isNotEmpty);
        expect(symbolish.hasMatch(currency.fullName), isFalse);
      }
    });

    test('الرموز القديمة المخزّنة تُفهم ولا تُسقط الصف', () {
      // صفوف كُتبت قبل توحيد العملات.
      expect(AppCurrency.resolve('ر.ي'), AppCurrency.yer);
      expect(AppCurrency.resolve('ر.س'), AppCurrency.sar);
      expect(AppCurrency.resolve('د.إ'), AppCurrency.aed);
      expect(AppCurrency.resolve('ج.م'), AppCurrency.egp);
      // والكتابة الإنجليزية التي كانت في شاشة الملف.
      expect(AppCurrency.resolve('SAR'), AppCurrency.sar);
      expect(AppCurrency.resolve('EGP'), AppCurrency.egp);
      expect(AppCurrency.resolve('AED'), AppCurrency.aed);
      expect(AppCurrency.resolve('USD'), AppCurrency.usd);
    });

    test('قيمة مجهولة أو فارغة ترجع للافتراضي بدل أن ترمي', () {
      expect(AppCurrency.resolve(null), AppCurrency.fallback);
      expect(AppCurrency.resolve(''), AppCurrency.fallback);
      expect(AppCurrency.resolve('   '), AppCurrency.fallback);
      expect(AppCurrency.resolve('عملة محذوفة'), AppCurrency.fallback);
    });

    test('التطبيع يعطي رمزاً ثابتاً مهما كانت الكتابة المخزّنة', () {
      for (final written in ['ر.س', 'SAR', 'sar', 'ريال سعودي']) {
        expect(AppCurrency.codeOf(written), 'SAR', reason: 'من «$written»');
      }
    });

    test('كل كتابة سابقة تُطبَّع إلى عنصر موجود في المنتقي', () {
      // هذا هو الخطأ الذي كان: «ر.س» مختارة في شاشة الإعداد لا يجدها منتقي
      // شاشة الملف، و`DropdownButtonFormField` يرمي assert على قيمة بلا عنصر.
      final codes = AppCurrency.all.map((c) => c.code).toSet();
      final everyWrittenForm = [
        for (final currency in AppCurrency.all) ...[
          currency.code,
          currency.word,
          currency.fullName,
          ...currency.aliases,
        ],
      ];

      for (final written in everyWrittenForm) {
        expect(codes, contains(AppCurrency.codeOf(written)),
            reason: '«$written» تُنتج رمزاً لا عنصر له في المنتقي');
      }
    });

    test('لا رمزان متطابقان ولا اسمان كاملان متطابقان', () {
      expect(AppCurrency.all.map((c) => c.code).toSet().length,
          AppCurrency.all.length);
      expect(AppCurrency.all.map((c) => c.fullName).toSet().length,
          AppCurrency.all.length);
    });

    test('الافتراضي في AppConstants رمز معروف', () {
      expect(AppCurrency.codeOf(AppConstants.defaultCurrency),
          AppCurrency.fallback.code);
    });
  });
}
