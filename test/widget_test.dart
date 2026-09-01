import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:attendance_budget_app/app.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // بناء التطبيق وإمراره داخل ProviderScope مع تحديد الخاصية child
    await tester.pumpWidget(
      const ProviderScope(
        child: AttendanceBudgetApp(),
      ),
    );

    // إعادة رسم الإطار
    await tester.pumpAndSettle();
  });
}