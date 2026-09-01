// data/models/attendance_model.dart
import 'package:isar_community/isar.dart';

part 'attendance_model.g.dart';

@collection
class AttendanceModel {
  Id id = Isar.autoIncrement;

  // 📅 التاريخ
  late DateTime date;

  // 🕐 وقت الدخول والخروج
  DateTime? checkIn;
  DateTime? checkOut;

  // ⏱️ الساعات المحسوبة
  late int workedHours;
  late int workedMinutes;

  // 📊 الاحتساب التلقائي
  late int requiredHours; // الساعات المطلوبة لهذا اليوم
  late int requiredMinutes;

  // ✅ الزيادة (الإضافي)
  late int overtimeHours;
  late int overtimeMinutes;
  late double overtimeValue; // القيمة المالية

  // ❌ النقص (التأخير)
  late int deficitHours;
  late int deficitMinutes;
  late double deficitValue; // قيمة الخصم

  // 📝 ملاحظات
  String? notes;

  // 🔐 تم التحقق بالبصمة؟
  late bool isBiometricVerified;

  // 🏷️ نوع اليوم (عادي، خميس، عطلة)
  @enumerated
  late DayType dayType;

  // 🚩 حالات إضافية
  bool isAbsent = false;
}

enum DayType {
  regular,      // يوم عادي (8 ساعات)
  thursday,     // خميس (4 ساعات)
  friday,       // جمعة (عطلة)
  holiday,      // عطلة رسمية
  custom,       // إعداد مخصص
}