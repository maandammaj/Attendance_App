/// صياغة العدد بالعربية: مفرد ومثنّى وجمع.
///
/// «1 جهات» و«2 يوم» خطأ نحوي يراه المستخدم في كل شاشة تعدّ شيئاً. العربية
/// تميّز أربع حالات لا حالتين، والصيغة الإنجليزية (رقم + جمع) لا تصحّ فيها.
class ArabicPlural {
  const ArabicPlural._();

  /// يصوغ العدد مع اسمه.
  ///
  /// [singular] مفرد، [dual] مثنّى، [plural] جمع القلّة (3–10)،
  /// و[manyPlural] ما بعد العشرة — وهو المفرد في العربية («11 يوماً»).
  static String count(
    int number, {
    required String singular,
    required String dual,
    required String plural,
    String? manyPlural,
  }) {
    if (number == 0) return 'لا $plural';
    if (number == 1) return singular;
    if (number == 2) return dual;
    if (number <= 10) return '$number $plural';
    return '$number ${manyPlural ?? singular}';
  }

  /// جهة عمل: «جهة» · «جهتان» · «3 جهات» · «11 جهة».
  static String workplaces(int n) => count(
        n,
        singular: 'جهة واحدة',
        dual: 'جهتين',
        plural: 'جهات',
        manyPlural: 'جهة',
      );

  /// يوم: «يوم» · «يومان» · «3 أيام» · «11 يوماً».
  static String days(int n) => count(
        n,
        singular: 'يوم واحد',
        dual: 'يومين',
        plural: 'أيام',
        manyPlural: 'يوماً',
      );
}
