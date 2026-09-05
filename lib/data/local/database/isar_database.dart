import 'package:flutter/foundation.dart';
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
  static Future<Isar>? _opening;

  /// قائمة المخططات الوحيدة. تُقرأ هنا وفي الاختبارات معاً، فلا تنشأ نسخة
  /// ثانية تنسى مجموعة جديدة وتفشل استعلاماتها وقت التشغيل فقط.
  static const List<CollectionSchema<dynamic>> schemas = [
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
  ];

  static Future<Isar> get instance {
    final ready = _instance;
    if (ready != null) return Future.value(ready);

    // تُخزَّن عملية الفتح نفسها لا نتيجتها فقط. `_instance ??= await _init()`
    // يترك فجوة بين فحص القيمة وإسنادها — كل نداء يصل داخلها يرى `null`
    // فيبدأ فتحاً ثانياً للقاعدة نفسها وهجرةً ثانية فوقها، فتتنازع معاملات
    // الكتابة ويتوقّف الإقلاع عند شاشة التحميل بلا خطأ ولا نشاط.
    return _opening ??= _init().then((isar) {
      _instance = isar;
      _opening = null;
      return isar;
    });
  }

  /// المنفذ الوحيد الذي تحقن منه الاختبارات قاعدة مؤقتة.
  ///
  /// المستودعات كلها تصل إلى القاعدة عبر [instance]، فبلا هذا المنفذ لا
  /// يمكن اختبار أيٍّ منها إلا على قاعدة الجهاز الحقيقية.
  @visibleForTesting
  static void overrideInstance(Isar? isar) {
    _instance = isar;
    _opening = null;
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
      schemas,
      directory: dir.path,
      inspector: true,
    );
  }
}
