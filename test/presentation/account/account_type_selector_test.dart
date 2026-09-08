import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/domain/entities/account_entity.dart';
import 'package:attendance_budget_app/presentation/screens/account/widgets/account_type_selector.dart';
import 'package:attendance_budget_app/presentation/screens/account/widgets/account_type_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      locale: const Locale('ar'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: child),
      ),
    );

void main() {
  group('منتقي تصنيف الحساب', () {
    testWidgets('يعرض التصنيفات الأربعة بأسمائها العربية', (tester) async {
      await tester.pumpWidget(_wrap(
        AccountTypeSelector(
          selected: AccountTypeEntity.supplier,
          onChanged: (_) {},
        ),
      ));

      for (final type in AccountTypeEntity.values) {
        expect(find.text(type.arabicLabel), findsOneWidget);
        // الاسم الإنجليزي للـenum يجب ألا يظهر في واجهة عربية.
        expect(find.text(type.name), findsNothing);
      }
    });

    testWidgets('الشريحة المحدّدة لا ترسم علامة صحّ فوق الأيقونة',
        (tester) async {
      await tester.pumpWidget(_wrap(
        AccountTypeSelector(
          selected: AccountTypeEntity.customer,
          onChanged: (_) {},
        ),
      ));

      final chips = tester.widgetList<ChoiceChip>(find.byType(ChoiceChip));
      expect(chips, hasLength(AccountTypeEntity.values.length));
      for (final chip in chips) {
        expect(chip.showCheckmark, isFalse,
            reason: 'علامة الصحّ تتراكب مع أيقونة التصنيف');
        expect(chip.avatar, isNotNull);
      }
      expect(chips.where((c) => c.selected), hasLength(1));
    });

    testWidgets('النقر على تصنيف يبلّغ به', (tester) async {
      AccountTypeEntity? picked;
      await tester.pumpWidget(_wrap(
        AccountTypeSelector(
          selected: AccountTypeEntity.supplier,
          onChanged: (type) => picked = type,
        ),
      ));

      await tester.tap(find.text(AccountTypeEntity.friend.arabicLabel));
      await tester.pumpAndSettle();

      expect(picked, AccountTypeEntity.friend);
    });

    testWidgets('يبني في الوضعين دون فيض', (tester) async {
      for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
        await tester.pumpWidget(_wrap(
          AccountTypeSelector(
            selected: AccountTypeEntity.personal,
            onChanged: (_) {},
          ),
          theme: theme,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
    });
  });
}
