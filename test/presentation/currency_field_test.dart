import 'package:attendance_budget_app/core/constants/currencies.dart';
import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/presentation/widgets/common/currency_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('ar'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: child),
      ),
    );

void main() {
  group('منتقي العملة', () {
    testWidgets('يعرض الاسم العربي لا الرمز', (tester) async {
      await tester.pumpWidget(_wrap(
        CurrencyField(value: AppCurrency.yer.code, onChanged: (_) {}),
      ));

      expect(find.text('ريال يمني'), findsOneWidget);
      // الرموز القديمة يجب ألا تظهر للمستخدم إطلاقاً.
      for (final symbol in ['ر.ي', 'ر.س', 'د.إ', 'ج.م']) {
        expect(find.text(symbol), findsNothing);
      }
    });

    testWidgets('يقبل كتابة قديمة مخزّنة دون أن يسقط', (tester) async {
      // القيمة المخزّنة قبل التوحيد. المنتقي السابق كان يرمي assert عليها
      // لأن عناصره كانت ['ر.ي','SAR','USD','EGP','AED'].
      for (final legacy in ['ر.س', 'SAR', 'ج.م', 'د.إ', 'USD', 'ر.ي']) {
        await tester.pumpWidget(
          _wrap(CurrencyField(value: legacy, onChanged: (_) {})),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'سقط على «$legacy»');
      }
    });

    testWidgets('قيمة مجهولة تقع على الافتراضي بدل الانهيار', (tester) async {
      await tester.pumpWidget(
        _wrap(CurrencyField(value: 'عملة محذوفة', onChanged: (_) {})),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text(AppCurrency.fallback.fullName), findsOneWidget);
    });

    testWidgets('يبلّغ بالرمز لا بالاسم المعروض', (tester) async {
      String? picked;
      await tester.pumpWidget(_wrap(
        CurrencyField(value: 'ر.ي', onChanged: (code) => picked = code),
      ));

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('دولار أمريكي').last);
      await tester.pumpAndSettle();

      expect(picked, AppCurrency.usd.code);
    });
  });
}
