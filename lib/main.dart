// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'core/services/notification_service.dart';
import 'data/local/database/isar_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // قاعدة البيانات أولاً: NotificationService يكتب سجل التنبيهات فيها.
  await IsarDatabase.instance;
  await NotificationService().init();

  await initializeDateFormatting('ar');
  Intl.defaultLocale = 'ar';

  runApp(
    const ProviderScope(
      child: AttendanceBudgetApp(),
    ),
  );
}
