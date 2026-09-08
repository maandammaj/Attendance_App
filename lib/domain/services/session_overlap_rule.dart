import 'attendance_calculation_service.dart';

/// تداخل بين جلستين في اليوم نفسه.
class SessionOverlap {
  const SessionOverlap(this.first, this.second);

  final SessionInput first;
  final SessionInput second;
}

/// يمنع تداخل الجلسات **داخل جهة العمل الواحدة**.
///
/// جلستان متداخلتان في الجهة نفسها تعنيان احتساب الدقائق المشتركة مرّتين،
/// فتنتفخ ساعات التواجد والإضافي ويُحتسب أجر عن وقت لم يُعمل.
///
/// أمّا التداخل **بين جهتين** فلا يُمنع هنا: من يعمل في مستشفى صباحاً وعملٍ
/// حرٍّ مساءً قد تتداخل ساعاته المسجَّلة بلا أن يكون ذلك خطأً في البيانات —
/// وهو شأن يخصّ التنبيه لا المنع، ولا تراه هذه القاعدة أصلاً لأنها تُطبَّق
/// على سجل يوم واحد في جهة واحدة.
class SessionOverlapRule {
  const SessionOverlapRule._();

  /// أول تداخل في القائمة، أو null إن كانت سليمة.
  ///
  /// التلامس ليس تداخلاً: جلسة تنتهي 12:00 وأخرى تبدأ 12:00 مقبولتان.
  static SessionOverlap? firstOverlap(List<SessionInput> sessions) {
    final closed = sessions.where((s) => s.isClosed).toList()
      ..sort((a, b) => a.checkIn!.compareTo(b.checkIn!));

    for (var i = 1; i < closed.length; i++) {
      final previous = closed[i - 1];
      final current = closed[i];
      if (current.checkIn!.isBefore(previous.checkOut!)) {
        return SessionOverlap(previous, current);
      }
    }

    // الجلسة المفتوحة تمتدّ إلى الآن، فأي جلسة تبدأ بعد بدايتها تتداخل معها.
    final open = sessions.where((s) => s.isOpen).toList();
    for (final openSession in open) {
      for (final other in closed) {
        if (other.checkOut!.isAfter(openSession.checkIn!)) {
          return SessionOverlap(openSession, other);
        }
      }
    }

    return null;
  }

  /// يرمي برسالة عربية عند وجود تداخل.
  static void assertNoOverlap(List<SessionInput> sessions) {
    final overlap = firstOverlap(sessions);
    if (overlap == null) return;
    throw Exception(
      'الجلسة تتداخل مع جلسة أخرى في اليوم نفسه — راجع الأوقات',
    );
  }
}
