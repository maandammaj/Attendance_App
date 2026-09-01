import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/attendance_model.dart';
import '../../models/debt_model.dart';
import '../../models/profile_model.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/account_model.dart';
import '../../models/notification_model.dart';
import '../../models/reminder_settings_model.dart';
import '../../models/budget_limit_model.dart';
import '../../models/company_model.dart';
import 'attendance_migration.dart';
import 'company_migration.dart';

class IsarDatabase {
  static Isar? _instance;

  static Future<Isar> get instance async {
    _instance ??= await _init();
    return _instance!;
  }

  static Future<Isar> _init() async {
    final isar = await _open();
    // يعمل مرة واحدة فعلياً: بعد أول تشغيل لا تبقى سجلات بلا جلسات.
    await AttendanceMigration.run(isar);
    await CompanyMigration.run(isar);
    return isar;
  }

  static Future<Isar> _open() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [
        AttendanceModelSchema,
        DebtModelSchema,
        ProfileModelSchema,
        TransactionModelSchema,
        CategoryModelSchema,
        AccountModelSchema,
        NotificationModelSchema,
        ReminderSettingsModelSchema,
        BudgetLimitModelSchema,
        CompanyModelSchema,
      ],
      directory: dir.path,
      inspector: true,
    );
  }
}
