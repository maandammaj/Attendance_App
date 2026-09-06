import 'package:attendance_budget_app/core/constants/design_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// يلتقط قيمة الخلوص كما تراها الويدجت داخل MediaQuery معيّن.
class _Probe extends StatelessWidget {
  const _Probe({required this.onMeasure});

  final void Function(double nav, double fab) onMeasure;

  @override
  Widget build(BuildContext context) {
    onMeasure(context.navBarClearance, context.navBarFabClearance);
    return const SizedBox.shrink();
  }
}

Future<({double nav, double fab})> _measure(
  WidgetTester tester, {
  required double safeAreaBottom,
}) async {
  late double nav;
  late double fab;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: const Size(360, 800),
        padding: EdgeInsets.only(bottom: safeAreaBottom),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: _Probe(onMeasure: (n, f) {
          nav = n;
          fab = f;
        }),
      ),
    ),
  );
  return (nav: nav, fab: fab);
}

void main() {
  group('خلوص شريط التنقل العائم', () {
    testWidgets('بلا شريط إيماءات يساوي الثابت', (tester) async {
      final m = await _measure(tester, safeAreaBottom: 0);
      expect(m.nav, AppSpacing.bottomNavInset);
      expect(m.fab, AppSpacing.bottomFabInset);
    });

    testWidgets('مع شريط إيماءات يزيد بمقداره', (tester) async {
      // `NavigationBar` يضيف حشوة المنطقة الآمنة إلى ارتفاعه، فالثابت وحده
      // يترك آخر عنصر محجوباً — وهذا ما رُصد فعلياً على المحاكي.
      const gestureBar = 48.0;
      final m = await _measure(tester, safeAreaBottom: gestureBar);

      expect(m.nav, AppSpacing.bottomNavInset + gestureBar);
      expect(m.fab, AppSpacing.bottomFabInset + gestureBar);
      expect(m.nav, greaterThan(AppSpacing.bottomNavInset),
          reason: 'الثابت وحده لا يكفي على جهاز له شريط إيماءات');
    });

    testWidgets('خلوص الزر العائم يفوق خلوص الشريط دائماً', (tester) async {
      for (final inset in [0.0, 24.0, 48.0]) {
        final m = await _measure(tester, safeAreaBottom: inset);
        expect(m.fab, greaterThan(m.nav));
      }
    });
  });
}
