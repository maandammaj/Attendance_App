/// العملات المدعومة، بكلمات عربية لا برموز.
///
/// وُجد هذا الملف لأن العملة كانت معرّفة في ثلاث قوائم متباينة — شاشة
/// الإعداد ترى `ر.س` وشاشة الملف ترى `SAR`، وهما القيمة نفسها بكتابتين.
/// اختيار عملة من إحداهما كان يترك المنتقي في الأخرى بقيمة لا يملك عنصراً
/// لها، وهذا خطأ تأكيد (assert) في `DropdownButtonFormField` لا مجرد فرق شكل.
///
/// المخزَّن هو [code]؛ العرض دائماً بـ [word] بجانب المبلغ وبـ [fullName]
/// داخل المنتقي.
class AppCurrency {
  const AppCurrency({
    required this.code,
    required this.word,
    required this.fullName,
    required this.aliases,
  });

  /// ما يُكتب في قاعدة البيانات — رمز ISO ثابت لا يتغيّر بتغيّر نص العرض.
  final String code;

  /// الكلمة بجانب المبلغ: «2538 ريال».
  final String word;

  /// الاسم الكامل داخل منتقي العملة.
  final String fullName;

  /// كتابات سابقة أو بديلة تُقرأ ولا تُكتب — بها تُفهم صفوف مخزّنة قديمة
  /// دون ترحيل لقاعدة البيانات.
  final List<String> aliases;

  /// كلمة العملة الافتراضية كثابت — تُستعمل كقيمة افتراضية لمعامل، وهو
  /// موضع لا يقبل إلا تعبيراً ثابتاً وقت الترجمة.
  static const String fallbackWord = 'ريال';

  static const yer = AppCurrency(
    code: 'YER',
    word: fallbackWord,
    fullName: 'ريال يمني',
    aliases: ['ر.ي', 'ر.ي.', 'YER'],
  );

  static const sar = AppCurrency(
    code: 'SAR',
    word: 'ريال سعودي',
    fullName: 'ريال سعودي',
    aliases: ['ر.س', 'ر.س.', 'SAR'],
  );

  static const aed = AppCurrency(
    code: 'AED',
    word: 'درهم',
    fullName: 'درهم إماراتي',
    aliases: ['د.إ', 'د.إ.', 'AED'],
  );

  static const egp = AppCurrency(
    code: 'EGP',
    word: 'جنيه',
    fullName: 'جنيه مصري',
    aliases: ['ج.م', 'ج.م.', 'EGP'],
  );

  static const usd = AppCurrency(
    code: 'USD',
    word: 'دولار',
    fullName: 'دولار أمريكي',
    aliases: [r'$', 'USD'],
  );

  /// الترتيب مقصود: عملة التطبيق الأساسية أولاً.
  static const List<AppCurrency> all = [yer, sar, aed, egp, usd];

  /// ما يُفترض حين لا تكون العملة مضبوطة بعد.
  static const AppCurrency fallback = yer;

  /// يفهم الرمز القديم والرمز الجديد والكلمة نفسها.
  ///
  /// لا يرمي على قيمة مجهولة: صفٌّ كُتب بعملة حُذفت لاحقاً يجب أن يُعرض،
  /// لا أن يُسقط الشاشة.
  static AppCurrency resolve(String? stored) {
    if (stored == null) return fallback;
    final value = stored.trim();
    if (value.isEmpty) return fallback;

    for (final currency in all) {
      if (currency.code == value ||
          currency.word == value ||
          currency.fullName == value ||
          currency.aliases.contains(value)) {
        return currency;
      }
    }

    final upper = value.toUpperCase();
    for (final currency in all) {
      if (currency.code == upper || currency.aliases.contains(upper)) {
        return currency;
      }
    }

    return fallback;
  }

  /// الكلمة التي تُكتب بجانب المبلغ.
  static String wordOf(String? stored) => resolve(stored).word;

  /// الرمز الذي يُخزَّن — يُطبّع أي كتابة قديمة إلى رمزها الثابت.
  static String codeOf(String? stored) => resolve(stored).code;
}
