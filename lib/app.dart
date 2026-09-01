import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/routes.dart';
import 'core/constants/theme.dart';

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

      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
