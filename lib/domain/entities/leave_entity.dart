/// نوع الإجازة.
///
/// [isPaid] هو ما يفرّق بينها مالياً: الإجازة المدفوعة تُفرِّغ مطلوب اليوم
/// فلا عجز عليه، وغير المدفوعة تترك المطلوب قائماً فيُخصم كيوم لم يُعمل.
enum LeaveTypeEntity {
  annual,
  sick,
  emergency,
  official,
  unpaid,
  other;

  /// «أخرى» مدفوعة افتراضاً: أغلب الإجازات مدفوعة، والخصم الصامت عن نوع
  /// لم يحدّده المستخدم أسوأ من عدمه — وله أن يختار «بلا أجر» صراحةً.
  bool get isPaid => this != LeaveTypeEntity.unpaid;

  String get label => switch (this) {
        LeaveTypeEntity.annual => 'سنوية',
        LeaveTypeEntity.sick => 'مرضية',
        LeaveTypeEntity.emergency => 'اضطرارية',
        LeaveTypeEntity.official => 'رسمية',
        LeaveTypeEntity.unpaid => 'بلا أجر',
        LeaveTypeEntity.other => 'أخرى',
      };
}

/// إجازة مأخوذة في مدى من التواريخ.
class LeaveEntity {
  const LeaveEntity({
    required this.id,
    required this.companyId,
    required this.from,
    required this.to,
    required this.type,
    this.note,
    required this.createdAt,
  });

  final int id;

  /// الجهة التي أُخذت منها. الأرصدة لا تُخلط بين الجهات.
  final int companyId;

  final DateTime from;
  final DateTime to;
  final LeaveTypeEntity type;
  final String? note;
  final DateTime createdAt;

  /// عدد الأيام شاملاً الطرفين.
  int get days => to.difference(from).inDays + 1;

  bool covers(DateTime date) =>
      !date.isBefore(from) && !date.isAfter(to);
}

/// رصيد نوع إجازة في جهة واحدة.
class LeaveAllowanceEntity {
  const LeaveAllowanceEntity({required this.type, required this.days});

  final LeaveTypeEntity type;

  /// الأيام المستحقّة سنوياً. صفر يعني بلا رصيد مُعلَن.
  final int days;
}

/// رصيد نوع بعد خصم ما استُهلك.
class LeaveBalanceEntity {
  const LeaveBalanceEntity({
    required this.type,
    required this.allowance,
    required this.used,
  });

  final LeaveTypeEntity type;
  final int allowance;
  final int used;

  int get remaining => allowance - used;

  /// تجاوزٌ للرصيد المُعلَن — يُعرض ولا يُمنع: الرصيد قد يكون مُدخَلاً ناقصاً،
  /// ومنعُ تسجيل إجازة وقعت فعلاً يجعل السجل يخالف الواقع.
  bool get isOverdrawn => allowance > 0 && used > allowance;
}
