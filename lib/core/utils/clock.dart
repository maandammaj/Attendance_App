/// مصدر الوقت في التطبيق.
///
/// `DateTime.now()` المباشر يجعل نتيجة الحساب تابعة للحظة تشغيل الاختبار:
/// إحصاءات الشهر مثلاً تقرأ «كم يوماً مضى» من الساعة، فاختبارٌ يمرّ في
/// سبتمبر يسقط في أكتوبر بلا تغيّر سطر واحد. تمرير الساعة يجعل الزمن مُدخَلاً
/// صريحاً كبقية المدخلات.
abstract class Clock {
  const Clock();

  DateTime now();
}

/// ساعة الجهاز — الافتراضية في كل مسارات التشغيل.
class SystemClock extends Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();
}

/// ساعة ثابتة تتقدّم بالطلب وحده — للاختبارات.
class FakeClock extends Clock {
  FakeClock(this._now);

  DateTime _now;

  @override
  DateTime now() => _now;

  /// يقفز بالوقت إلى الأمام، لمحاكاة مرور جلسة أو يوم.
  void advance(Duration by) => _now = _now.add(by);

  /// يضبط الوقت على لحظة بعينها.
  void set(DateTime moment) => _now = moment;
}
