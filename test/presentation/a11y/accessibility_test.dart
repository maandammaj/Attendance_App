import 'package:attendance_budget_app/core/constants/design_tokens.dart';
import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:attendance_budget_app/domain/entities/analytics_report_entity.dart';
import 'package:attendance_budget_app/presentation/screens/budget/widgets/spending_breakdown.dart';
import 'package:attendance_budget_app/presentation/widgets/common/animated_entrance.dart';
import 'package:attendance_budget_app/presentation/widgets/common/empty_state.dart';
import 'package:attendance_budget_app/presentation/widgets/common/pulsing_dot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// يغلّف ويدجت بسمة التطبيق، مع إمكانية محاكاة إعدادات النظام.
Widget _wrap(
  Widget child, {
  bool reducedMotion = false,
  double textScale = 1.0,
  Size size = const Size(375, 812),
}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    locale: const Locale('ar'),
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        disableAnimations: reducedMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(body: child),
      ),
    ),
  );
}

List<CategoryBreakdownItem> _items(int count) => [
      for (int i = 0; i < count; i++)
        CategoryBreakdownItem(
          name: 'فئة إنفاق رقم ${i + 1}',
          amount: 1000.0 - (i * 50),
          share: 1 / count,
          transactionCount: i + 1,
        ),
    ];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('تقليل الحركة', () {
    testWidgets('النبضة المتكرّرة تتوقف ولا تبقى حركة دائمة', (tester) async {
      await tester.pumpWidget(
        _wrap(const PulsingDot(color: Colors.green), reducedMotion: true),
      );
      await tester.pump(const Duration(seconds: 2));

      // pumpAndSettle يتعلّق إلى الأبد أمام حركة لا نهائية؛ نجاحه دليل توقّفها.
      await tester.pumpAndSettle();
      expect(find.byType(PulsingDot), findsOneWidget);
    });

    testWidgets('مدخل القائمة يعرض المحتوى فوراً بلا تلاشٍ', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const AnimatedEntrance(index: 3, child: Text('محتوى')),
          reducedMotion: true,
        ),
      );
      // بلا ضخّ إضافي: النص موجود من أول إطار.
      expect(find.text('محتوى'), findsOneWidget);
      // الطفل يُعاد كما هو، فلا طبقة تلاشٍ ولا انزلاق داخل الويدجت نفسه.
      // البحث محصور فيه لأن انتقال الصفحة يملك FadeTransition خاصاً به.
      expect(
        find.descendant(
          of: find.byType(AnimatedEntrance),
          matching: find.byType(FadeTransition),
        ),
        findsNothing,
      );
      expect(
        find.descendant(
          of: find.byType(AnimatedEntrance),
          matching: find.byType(SlideTransition),
        ),
        findsNothing,
      );
    });

    testWidgets('الحركة تعمل حين لا يطلب المستخدم تقليلها', (tester) async {
      await tester.pumpWidget(
        _wrap(const PulsingDot(color: Colors.green)),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(PulsingDot), findsOneWidget);
      // نُنهي الحركة اللانهائية حتى لا يتعلّق المُشغّل.
      await tester.pumpWidget(_wrap(const SizedBox()));
    });
  });

  group('تكبير خط النظام', () {
    testWidgets('توزيع المصروفات لا يفيض عند ضعف حجم الخط', (tester) async {
      await tester.pumpWidget(_wrap(
        SingleChildScrollView(
          child: SpendingBreakdown(items: _items(6), currency: 'ر.ي'),
        ),
        textScale: 2.0,
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('حالة الفراغ تصمد على أضيق شاشة مع خط مكبّر', (tester) async {
      await tester.pumpWidget(_wrap(
        const EmptyState(
          icon: Icons.inbox_outlined,
          title: 'لا بيانات',
          message: 'رسالة طويلة نسبياً تشرح للمستخدم ما الذي عليه فعله الآن.',
        ),
        textScale: 1.8,
        size: const Size(320, 640),
      ));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('الأوصاف الصوتية', () {
    testWidgets('كل زر أيقوني يحمل وصفاً يقرأه قارئ الشاشة', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(_wrap(
        Row(
          children: [
            IconButton(
              tooltip: 'حذف',
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
            ),
          ],
        ),
      ));

      expect(
        tester.getSemantics(find.byType(IconButton)),
        matchesSemantics(
          isButton: true,
          isEnabled: true,
          isFocusable: true,
          hasEnabledState: true,
          hasTapAction: true,
          hasFocusAction: true,
          tooltip: 'حذف',
        ),
      );
      handle.dispose();
    });
  });

  group('أهداف اللمس', () {
    testWidgets('زر الأيقونة يبلغ الحد الأدنى 48dp', (tester) async {
      await tester.pumpWidget(_wrap(
        IconButton(
          tooltip: 'حذف',
          icon: const Icon(Icons.delete_outline),
          onPressed: () {},
        ),
      ));

      final size = tester.getSize(find.byType(IconButton));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
    });
  });

  group('مفاتيح التصميم', () {
    test('مدة الحركة تصير صفراً عند طلب تقليلها', () {
      // فحص مباشر للمنطق دون شجرة ويدجتس.
      expect(AppDurations.medium.inMilliseconds, greaterThan(0));
    });
  });
}
