/// نوع اليوم الذي وقع فيه الإضافي — يحدّد أي أجر يُطبَّق.
enum OvertimeDayType {
  /// يوم عمل عادي.
  normal,

  /// يوم راحة أسبوعية بحسب الجدول.
  weekend,

  publicHoliday,
  workplaceHoliday;

  String get label => switch (this) {
        OvertimeDayType.normal => 'يوم عمل',
        OvertimeDayType.weekend => 'يوم راحة',
        OvertimeDayType.publicHoliday => 'عطلة رسمية',
        OvertimeDayType.workplaceHoliday => 'عطلة جهة العمل',
      };
}

/// كيف يُحسب أجر الساعة الإضافية.
enum OvertimeRateKind {
  /// مضاعِف لأجر الساعة العادي: 1.5 تعني ساعة ونصفاً لكل ساعة.
  ///
  /// النسبة المئوية (150%) هي هذا نفسه معبَّراً عنه بصيغة أخرى، فلا كِيان
  /// ثالث لها.
  multiplier,

  /// مبلغ مقطوع لكل ساعة إضافية، مستقلّ عن أجر الساعة.
  fixedPerHour,

  /// مبلغ مقطوع لليوم كلّه متى وُجد إضافي، مهما بلغت ساعاته.
  fixedPerDay;

  String get label => switch (this) {
        OvertimeRateKind.multiplier => 'مضاعِف أجر الساعة',
        OvertimeRateKind.fixedPerHour => 'مبلغ لكل ساعة',
        OvertimeRateKind.fixedPerDay => 'مبلغ لليوم',
      };
}

/// أجر الإضافي: نوعه وقيمته.
class OvertimeRateEntity {
  const OvertimeRateEntity({required this.kind, required this.value});

  const OvertimeRateEntity.multiplier(double times)
      : kind = OvertimeRateKind.multiplier,
        value = times;

  final OvertimeRateKind kind;
  final double value;

  /// قيمة الإضافي لعدد دقائق، بمعلومية أجر الساعة العادي.
  double amountFor({required int minutes, required double hourlyWage}) {
    if (minutes <= 0) return 0;
    return switch (kind) {
      OvertimeRateKind.multiplier => (minutes / 60) * hourlyWage * value,
      OvertimeRateKind.fixedPerHour => (minutes / 60) * value,
      // مقطوع لليوم: يُدفع مرّة متى وُجد إضافي، ولا يتضاعف بالساعات.
      OvertimeRateKind.fixedPerDay => value,
    };
  }

  String describe() => switch (kind) {
        OvertimeRateKind.multiplier => '×$value',
        OvertimeRateKind.fixedPerHour => '$value / ساعة',
        OvertimeRateKind.fixedPerDay => '$value / يوم',
      };
}

/// أجور الإضافي لجهة واحدة، مفصّلة بنوع اليوم.
///
/// تحلّ محلّ حقل `overtimeRate` المفرد الذي كان يحمل معنيين: قيمة أكبر من 2
/// تُقرأ مبلغاً مطلقاً وما دونها مضاعِفاً. تلك القاعدة تجعل مضاعِف 2.5
/// مستحيل التعبير عنه، وتغيّر معنى الرقم عند تجاوزه حدّاً لا يراه المستخدم.
class OvertimePolicyEntity {
  const OvertimePolicyEntity({
    required this.normal,
    this.weekend,
    this.publicHoliday,
    this.workplaceHoliday,
  });

  /// الأجر في يوم العمل العادي — وهو الأساس الذي يرجع إليه كل نوع لم يُحدَّد.
  final OvertimeRateEntity normal;

  final OvertimeRateEntity? weekend;
  final OvertimeRateEntity? publicHoliday;
  final OvertimeRateEntity? workplaceHoliday;

  /// الأجر المطبَّق على نوع يوم. غير المحدَّد يرجع إلى [normal].
  OvertimeRateEntity rateFor(OvertimeDayType dayType) => switch (dayType) {
        OvertimeDayType.normal => normal,
        OvertimeDayType.weekend => weekend ?? normal,
        OvertimeDayType.publicHoliday => publicHoliday ?? normal,
        OvertimeDayType.workplaceHoliday => workplaceHoliday ?? normal,
      };

  /// يبني السياسة من الحقل القديم بالقاعدة التي كانت مطبَّقة حرفياً، فلا
  /// تتغيّر أرقام جهة قائمة لمجرّد وجود السياسة.
  factory OvertimePolicyEntity.fromLegacyRate(double rate) {
    return OvertimePolicyEntity(
      normal: rate > 2
          ? OvertimeRateEntity(kind: OvertimeRateKind.fixedPerHour, value: rate)
          : OvertimeRateEntity(
              kind: OvertimeRateKind.multiplier, value: rate),
    );
  }

  OvertimePolicyEntity copyWith({
    OvertimeRateEntity? normal,
    OvertimeRateEntity? weekend,
    OvertimeRateEntity? publicHoliday,
    OvertimeRateEntity? workplaceHoliday,
    bool clearWeekend = false,
    bool clearPublicHoliday = false,
    bool clearWorkplaceHoliday = false,
  }) {
    return OvertimePolicyEntity(
      normal: normal ?? this.normal,
      weekend: clearWeekend ? null : (weekend ?? this.weekend),
      publicHoliday:
          clearPublicHoliday ? null : (publicHoliday ?? this.publicHoliday),
      workplaceHoliday: clearWorkplaceHoliday
          ? null
          : (workplaceHoliday ?? this.workplaceHoliday),
    );
  }
}
