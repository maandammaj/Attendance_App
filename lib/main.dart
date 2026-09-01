// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app.dart';
import 'data/models/attendance_model.dart';
import 'data/models/debt_model.dart';
import 'data/models/profile_model.dart';
import 'data/models/transaction_model.dart';
import 'data/models/category_model.dart';
import 'data/local/database/isar_database.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة التنبيهات
  await NotificationService().init();

  // Initialize locale data for date formatting (Arabic locale used in UI)
  await initializeDateFormatting('ar');
  Intl.defaultLocale = 'ar';

  // تهيئة قاعدة البيانات
  await IsarDatabase.instance;

  runApp(
    const ProviderScope(
      child: AttendanceBudgetApp(),
    ),
  );
}
