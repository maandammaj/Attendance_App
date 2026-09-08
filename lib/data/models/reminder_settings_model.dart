import 'package:isar_community/isar.dart';

part 'reminder_settings_model.g.dart';

/// صف مفرد (`id = 0`) يحمل تفضيلات كل نوع تذكير.
///
/// مفصول عن `ProfileModel` لأن تعديل التفضيلات يعيد جدولة التنبيهات،
/// بينما تعديل الراتب لا يفعل.
@collection
class ReminderSettingsModel {
  Id id = 0;

  // ── تذكيرات الدوام ──────────────────────────────────────────────
  bool shiftStartEnabled = true;
  /// كم دقيقة قبل بداية الوردية يُرسل التذكير.
  int shiftStartLeadMinutes = 30;

  bool shiftEndEnabled = true;
  /// كم دقيقة قبل نهاية الوردية يُرسل التذكير.
  int shiftEndLeadMinutes = 15;

  /// تنبيه عند اكتمال الساعات المطلوبة (بداية احتساب الإضافي).
  bool requiredHoursDoneEnabled = true;

  /// تنبيه "نسيت تسجيل الخروج" بعد مرور هذه الساعات على الدخول.
  bool forgotCheckOutEnabled = true;
  int forgotCheckOutAfterHours = 12;

  /// تنبيه عند عدم تسجيل الحضور بعد بداية الوردية بهذه الدقائق.
  bool missedCheckInEnabled = true;
  int missedCheckInAfterMinutes = 45;

  // ── تذكيرات الديون ──────────────────────────────────────────────
  bool debtDueEnabled = true;
  /// أيام التنبيه المسبق قبل تاريخ الاستحقاق.
  List<int> debtDueLeadDays = const [7, 3, 1];
  bool debtOverdueEnabled = true;

  // ── تنبيهات مالية ذكية ──────────────────────────────────────────
  bool budgetOverrunEnabled = true;
  /// نسبة من حد الفئة تُطلق تنبيهاً تحذيرياً قبل التجاوز (0.0 – 1.0).
  double budgetWarnThreshold = 0.8;

  bool unusualSpendingEnabled = true;
  bool debtRatioEnabled = true;
  /// نسبة الدين إلى الراتب التي تعتبر خطرة.
  double debtRatioThreshold = 0.5;
  bool monthEndForecastEnabled = true;

  // ── الملخصات الدورية ────────────────────────────────────────────
  bool dailySummaryEnabled = true;
  /// وقت الملخص اليومي بصيغة "HH:mm".
  String dailySummaryTime = '21:00';

  bool weeklySummaryEnabled = true;
  /// يوم الملخص الأسبوعي بترقيم `DateTime.weekday` (1 = الاثنين … 7 = الأحد).
  int weeklySummaryDayOfWeek = DateTime.wednesday;
  String weeklySummaryTime = '20:00';

  bool monthlySummaryEnabled = true;
  /// يوم الشهر الذي يُرسل فيه التقرير الشهري (يُقصّ لآخر يوم في الأشهر القصيرة).
  int monthlySummaryDayOfMonth = 28;
  String monthlySummaryTime = '19:00';

  bool recurringExpenseEnabled = true;

  // ── ساعات الهدوء ────────────────────────────────────────────────
  /// لا تُطلق تنبيهات بين هذين الوقتين (ما عدا الحرجة).
  bool quietHoursEnabled = false;
  String quietHoursStart = '23:00';
  String quietHoursEnd = '07:00';

  // ── الأمان ──────────────────────────────────────────────────────
  /// يمنع تسجيل الحضور/الانصراف دون تحقق ناجح. عند تعطيله يُسجَّل الدوام
  /// مع وسم `isBiometricVerified = false` بدل منعه.
  bool requireBiometricForAttendance = true;

  /// يطلب تحققاً عند كل فتح للتطبيق.
  bool appLockEnabled = false;

  /// يسمح بقفل الجهاز (PIN/نمط) كبديل عن البصمة.
  bool allowDeviceCredential = true;

  DateTime updatedAt = DateTime(2020);
}
