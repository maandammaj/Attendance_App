import '../../data/models/notification_model.dart';

/// نطاق معرّفات مغلق من الأسفل ومفتوح من الأعلى: `[start, end)`.
class IdRange {
  const IdRange(this.start, this.end);

  final int start;
  final int end;

  /// معرّف داخل النطاق مشتق من [key]، يبقى ثابتاً لنفس المفتاح
  /// حتى تُلغى إعادةُ الجدولة التنبيهَ القديم بدل تكديس نسخ منه.
  int idFor(int key) => start + (key.abs() % (end - start));
}

/// كل نوع تنبيه يملك نطاقه ليُعاد جدولته أو يُلغى دون المساس بالباقي.
class NotificationIds {
  NotificationIds._();

  /// تذكير قبل بداية الوردية — معرّف لكل يوم أسبوع.
  static const shiftStart = IdRange(1000, 1010);

  /// تذكير قبل نهاية الوردية — معرّف لكل يوم أسبوع.
  static const shiftEnd = IdRange(1010, 1020);

  /// "لم تسجّل حضورك" — معرّف لكل يوم أسبوع.
  static const missedCheckIn = IdRange(1020, 1030);

  /// تنبيهات فورية تُقيَّم أثناء التشغيل (اكتمال الساعات، نسيان الخروج).
  static const attendanceLive = IdRange(1030, 1040);

  static const debtDue = IdRange(2000, 3000);
  static const debtOverdue = IdRange(3000, 4000);

  static const finance = IdRange(4000, 4100);

  static const dailySummary = IdRange(5000, 5001);
  static const weeklySummary = IdRange(5001, 5002);
  static const monthlySummary = IdRange(5002, 5003);
  static const recurringExpense = IdRange(5100, 5200);

  /// كل النطاقات المجدولة مسبقاً — تُلغى دفعةً واحدة قبل إعادة الجدولة.
  static const scheduledRanges = <IdRange>[
    shiftStart,
    shiftEnd,
    missedCheckIn,
    debtDue,
    debtOverdue,
    dailySummary,
    weeklySummary,
    monthlySummary,
    recurringExpense,
  ];
}

class NotificationChannels {
  NotificationChannels._();

  /// **الإصدار جزء من المعرّف عمداً.** أندرويد يتجاهل أي تعديل على قناة
  /// بعد إنشائها — الصوت والأهمية والاهتزاز تتجمّد على أول قيمة. تغيير أي
  /// منها يوجب رفع الإصدار هنا وإضافة المعرّف القديم إلى [retired].
  static const String _version = 'v2';

  static const String attendance = 'attendance_channel_$_version';
  static const String debt = 'debt_channel_$_version';
  static const String finance = 'finance_channel_$_version';
  static const String summary = 'summary_channel_$_version';
  static const String general = 'general_channel_$_version';

  /// قنوات إصدارات سابقة تُحذف عند الإقلاع حتى لا تتراكم في إعدادات النظام.
  static const List<String> retired = [
    'attendance_channel',
    'debt_channel',
    'finance_channel',
    'summary_channel',
    'general_channel',
    'default_channel',
    'reminders_channel',
  ];

  static String forCategory(NotificationCategory category) {
    return switch (category) {
      NotificationCategory.attendance => attendance,
      NotificationCategory.debt => debt,
      NotificationCategory.finance => finance,
      NotificationCategory.summary => summary,
      NotificationCategory.general => general,
    };
  }
}
