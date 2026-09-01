import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/attendance_model.dart';
import '../../models/debt_model.dart';
import '../../models/profile_model.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/account_model.dart';
import '../../models/notification_model.dart';

class IsarDatabase {
  static Isar? _instance;

  static Future<Isar> get instance async {
    _instance ??= await _init();
    return _instance!;
  }

  static Future<Isar> _init() async {
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
      ],
      directory: dir.path,
      inspector: true,
    );
  }
}
