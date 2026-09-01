import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes.dart';
import 'core/constants/theme.dart';
import 'presentation/screens/auth/app_lock_gate.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/setup/setup_gate.dart';

class AttendanceBudgetApp extends ConsumerWidget {
  const AttendanceBudgetApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'نظام الحضور والميزانية',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // التطبيق عربي فقط: تثبيت اللغة يعطي RTL لكل الشاشات، ويعرّب ويدجتس
      // Material الجاهزة (منتقي التاريخ والوقت والمدى) التي كانت إنجليزية.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      routes: AppRoutes.routes,

      // البوابتان هنا لا في `builder`: هذا الأخير يُركَّب **فوق** الـNavigator،
      // فبوابة تعرض شاشتها بدل `child` تُسقط الـNavigator ومعه الـOverlay،
      // فينهار كل Tooltip وحوار ومنتقي وقت داخلها بـ"No Overlay widget found".
      // كونهما أول مسار يبقيهما تحت الـNavigator ويحفظ الـOverlay.
      home: const _AppRoot(),
    );
  }
}

/// جذر التطبيق داخل الـNavigator: التحقق ثم الإعداد ثم الشاشة الرئيسية.
class _AppRoot extends StatelessWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context) {
    return const AppLockGate(
      child: SetupGate(child: HomeScreen()),
    );
  }
}
