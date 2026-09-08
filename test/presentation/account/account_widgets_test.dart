import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/domain/entities/account_entity.dart';
import 'package:attendance_budget_app/presentation/screens/account/widgets/account_row.dart';
import 'package:attendance_budget_app/presentation/screens/account/widgets/accounts_summary_card.dart';
import 'package:attendance_budget_app/presentation/screens/profile/widgets/profile_identity_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(
  Widget child, {
  required ThemeData theme,
  double textScale = 1.0,
  Size size = const Size(360, 800),
}) {
  return MaterialApp(
    theme: theme,
    locale: const Locale('ar'),
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}

AccountEntity _account({
  int id = 1,
  String name = 'شركة التوريدات المتحدة',
  AccountTypeEntity type = AccountTypeEntity.supplier,
  double balance = 12500,
}) {
  final now = DateTime(2026, 9, 6);
  return AccountEntity(
    id: id,
    name: name,
    type: type,
    totalBalance: balance,
    createdAt: now,
    updatedAt: now,
  );
}

final _themes = {'فاتح': AppTheme.lightTheme, 'داكن': AppTheme.darkTheme};

void main() {
  group('صف الحساب', () {
    for (final entry in _themes.entries) {
      testWidgets('يبني في الوضع ${entry.key} بلا فيض', (tester) async {
        await tester.pumpWidget(_wrap(
          AccountRow(
            account: _account(),
            currency: 'ر.ي',
            onTap: () {},
            onDelete: () {},
          ),
          theme: entry.value,
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('يصمد عند تكبير الخط مع اسم طويل', (tester) async {
      await tester.pumpWidget(_wrap(
        AccountRow(
          account: _account(
            name: 'مؤسسة التجارة والتوريدات العامة المحدودة للمقاولات',
          ),
          currency: 'ر.ي',
          onTap: () {},
          onDelete: () {},
        ),
        theme: AppTheme.lightTheme,
        textScale: 2.0,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('يعرض التصنيف العربي والرصيد', (tester) async {
      await tester.pumpWidget(_wrap(
        AccountRow(
          account: _account(type: AccountTypeEntity.friend, balance: 500),
          currency: 'ر.ي',
          onTap: () {},
          onDelete: () {},
        ),
        theme: AppTheme.lightTheme,
      ));
      expect(find.text('صديق'), findsOneWidget);
      expect(find.text('500 ر.ي'), findsOneWidget);
    });
  });

  group('ملخّص الحسابات', () {
    testWidgets('يفصل الموجب عن السالب ويجمع الصافي', (tester) async {
      await tester.pumpWidget(_wrap(
        AccountsSummaryCard(
          accounts: [
            _account(id: 1, balance: 1000),
            _account(id: 2, balance: 500),
            _account(id: 3, balance: -300),
          ],
          currency: 'ر.ي',
        ),
        theme: AppTheme.lightTheme,
        size: const Size(400, 800),
      ));
      await tester.pumpAndSettle();

      expect(find.text('1500 ر.ي'), findsOneWidget); // لك
      expect(find.text('300 ر.ي'), findsOneWidget); // عليك
      expect(find.text('1200 ر.ي'), findsOneWidget); // الصافي
      expect(tester.takeException(), isNull);
    });

    for (final entry in _themes.entries) {
      testWidgets('يبني في الوضع ${entry.key}', (tester) async {
        await tester.pumpWidget(_wrap(
          AccountsSummaryCard(
            accounts: [_account(balance: -800)],
            currency: 'ر.ي',
          ),
          theme: entry.value,
          size: const Size(400, 800),
        ));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  });

  group('بطاقة هوية الملف', () {
    testWidgets('تشتق أول حرفين من الاسم', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProfileIdentityCard(
          fullName: 'أحمد سمير',
          jobTitle: 'مهندس برمجيات',
          companyName: 'توصيل وَن',
        ),
        theme: AppTheme.lightTheme,
      ));
      expect(find.text('أس'), findsOneWidget); // أحمد + سمير
      expect(find.text('أحمد سمير'), findsOneWidget);
      expect(find.text('توصيل وَن'), findsOneWidget);
    });

    testWidgets('اسم من كلمة واحدة يعطي حرفاً واحداً', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProfileIdentityCard(
          fullName: 'أحمد',
          jobTitle: 'موظف',
          companyName: null,
        ),
        theme: AppTheme.lightTheme,
      ));
      expect(find.text('أ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('تصمد عند تكبير الخط واسم طويل', (tester) async {
      await tester.pumpWidget(_wrap(
        const ProfileIdentityCard(
          fullName: 'عبد الرحمن بن عبد العزيز الشامي',
          jobTitle: 'مدير الموارد البشرية والشؤون الإدارية',
          companyName: 'مؤسسة التوصيل السريع للنقل',
        ),
        theme: AppTheme.darkTheme,
        textScale: 1.8,
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
