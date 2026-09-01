import 'package:flutter/material.dart';

/// لوحة الألوان لوضع واحد.
///
/// كل قيمة معرّفة صراحةً لكل وضع بدل اشتقاقها من `ColorScheme.fromSeed`،
/// لأن الاشتقاق التلقائي لا يضمن نِسب التباين — وهذه القيم مُتحقَّق منها
/// بـ `tool/contrast_check.py` (نص أساسي ≥ 4.5:1، عناصر كبيرة ≥ 3:1).
class AppPalette {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.onAccent,
    required this.accentOnBrand,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.positive,
    required this.negative,
    required this.warning,
    required this.info,
    required this.scrim,
    required this.shadow,
    required this.categorical,
  });

  final Color background;

  /// سطح البطاقات والأوراق المرتفعة.
  final Color surface;

  /// سطح أخفت للحقول والشرائح داخل البطاقة.
  final Color surfaceAlt;

  final Color primary;
  final Color onPrimary;

  /// لون التمييز — محجوز للمال وحده: الراتب، المكتسب، المبالغ.
  ///
  /// وجوده هو ما يجعل الرقم المالي يبرز؛ قبله كان بنفس أزرق التنقّل فلا
  /// يتقدّم على شيء. استخدامه في غير المال يُبطل الإشارة.
  final Color accent;
  final Color onAccent;

  /// درجة أفتح من [accent] للاستخدام فوق تدرّج العلامة الداكن، حيث لا
  /// يحقق الذهبي العادي تبايناً كافياً.
  final Color accentOnBrand;

  /// نص أساسي وأيقونات بارزة.
  final Color onSurface;

  /// نص ثانوي — مشتق من درجة الخلفية لا رمادي محايد.
  final Color onSurfaceVariant;

  final Color outline;

  /// دخل، إضافي، إنجاز.
  final Color positive;

  /// مصروف، عجز، غياب.
  final Color negative;

  final Color warning;
  final Color info;

  /// حجاب النوافذ المنبثقة.
  final Color scrim;

  /// ألوان الفئات في الرسوم، بترتيب ثابت.
  ///
  /// مُتحقَّقة بـ `validate_palette.js` من مهارة dataviz: نطاق الإضاءة،
  /// أرضية التشبّع، فصل عمى الألوان (ΔE ≥ 8)، والتباين مقابل السطح.
  /// **تُسند بالترتيب ولا تُدوَّر**: الفئة التاسعة تنضم إلى "أخرى" ولا تأخذ
  /// لوناً مولَّداً، وإلا صارت غير مميّزة تحت عمى الألوان.
  final List<Color> categorical;

  /// لون الظل. محايد دائماً — الظل الملوّن هالةُ زينة لا عمق.
  ///
  /// في الوضع الداكن الظل شبه معدوم: أسود على أسود لا يفصل شيئاً، والفصل
  /// هناك مهمة الحد وتدرّج السطح لا الظل.
  final Color shadow;

  /// أزرق الثقة على خلفية شبه بيضاء.
  static const light = AppPalette(
    background: Color(0xFFF4F6FB),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEBEFF7),
    primary: Color(0xFF16255C),
    onPrimary: Color(0xFFFFFFFF),
    accent: Color(0xFF8A5A0B),
    onAccent: Color(0xFFFFFFFF),
    accentOnBrand: Color(0xFFF2C766),
    onSurface: Color(0xFF0B1120),
    onSurfaceVariant: Color(0xFF4F5B75),
    outline: Color(0xFFD3DBEA),
    positive: Color(0xFF047857),
    negative: Color(0xFFC81E1E),
    warning: Color(0xFFB45309),
    info: Color(0xFF1D4ED8),
    scrim: Color(0x8C0F172A),
    shadow: Color(0xFF1B2440),
    categorical: [
      Color(0xFF3B6FE0),
      Color(0xFF0E9488),
      Color(0xFFD97706),
      Color(0xFFBE3455),
      Color(0xFF7C5CD6),
      Color(0xFF4D9E28),
      Color(0xFF0891B2),
      Color(0xFFB45309),
    ],
  );

  /// نفس العلامة بدرجات مرفوعة لتبقى مقروءة على الأزرق الليلي العميق.
  static const dark = AppPalette(
    background: Color(0xFF0A0F1E),
    surface: Color(0xFF141B2E),
    surfaceAlt: Color(0xFF0E1526),
    primary: Color(0xFF8FB4FF),
    onPrimary: Color(0xFF0A0F1E),
    accent: Color(0xFFE9B44C),
    onAccent: Color(0xFF1A1204),
    accentOnBrand: Color(0xFFF2C766),
    onSurface: Color(0xFFE9EDF7),
    onSurfaceVariant: Color(0xFF9AA8C2),
    outline: Color(0xFF2A3550),
    positive: Color(0xFF34D399),
    negative: Color(0xFFF87171),
    warning: Color(0xFFFBBF24),
    info: Color(0xFF7CA9FF),
    scrim: Color(0xB3060B16),
    shadow: Color(0xFF000000),
    categorical: [
      Color(0xFF5A86EA),
      Color(0xFF189E8E),
      Color(0xFFBC8016),
      Color(0xFFD25470),
      Color(0xFF8E74E0),
      Color(0xFF569C33),
      Color(0xFF1FA0BC),
      Color(0xFFAC7028),
    ],
  );

  /// الوضع الداكن يُستدلّ عليه من الخلفية لا من مَعلم منفصل قد ينحرف عنها.
  bool get isDark => background.computeLuminance() < 0.2;

  /// قطبا التدرّج ثنائي الاتجاه للقيم الموقّعة (مساهمة موجبة مقابل خصم).
  ///
  /// دافئ مقابل بارد بمنتصف محايد — قطبان باردان لا يُقرآن كمتضادّين.
  Color get divergingPositive => positive;
  Color get divergingNegative => negative;
  Color get divergingNeutral => onSurfaceVariant.withValues(alpha: 0.35);

  /// أغمق نقطة في تدرّج العلامة. ثابتة بين الوضعين لأن البطاقة الرئيسية
  /// سطح داكن دائماً، فتبقى نِسب الأبيض والذهبي فوقها واحدة.
  static const brandDeep = Color(0xFF16255C);

  /// تدرّج البطاقة الرئيسية.
  static const brandGradient = [brandDeep, Color(0xFF2B4394)];

  /// تدرّج حالة الدوام الجاري.
  static const activeGradient = [Color(0xFF04503A), Color(0xFF0C7A56)];
}

/// يتيح قراءة اللوحة من `Theme.of(context)` دون تمريرها يدوياً.
///
/// ضروري لأن `ColorScheme` لا يملك حقولاً للدلالات المالية.
class AppPaletteExtension extends ThemeExtension<AppPaletteExtension> {
  const AppPaletteExtension(this.palette);

  final AppPalette palette;

  @override
  AppPaletteExtension copyWith({AppPalette? palette}) =>
      AppPaletteExtension(palette ?? this.palette);

  /// الانتقال بين الوضعين يبدّل اللوحة عند منتصف الحركة بدل مزج كل حقل،
  /// فألوان الدلالة لا تمرّ بدرجات وسيطة بلا معنى.
  @override
  AppPaletteExtension lerp(AppPaletteExtension? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppPaletteContext on BuildContext {
  AppPalette get palette =>
      Theme.of(this).extension<AppPaletteExtension>()!.palette;

  /// هل طلب المستخدم تقليل الحركة من إعدادات النظام؟
  ///
  /// الحركة ليست زينة لمن يعاني حساسية الدهليز — التكرار والانزلاق قد
  /// يسبّبان دواراً فعلياً. القراءة من MediaQuery لا من إعداد داخلي حتى
  /// يسري إعداد النظام على التطبيق دون أن يضبطه المستخدم مرتين.
  bool get prefersReducedMotion =>
      MediaQuery.maybeDisableAnimationsOf(this) ?? false;

  /// يصفّر المدة عند طلب تقليل الحركة، فتصل الويدجت لحالتها النهائية فوراً
  /// بدل أن تُلغى فتختفي.
  Duration motion(Duration duration) =>
      prefersReducedMotion ? Duration.zero : duration;
}

class AppRadius {
  AppRadius._();

  /// قاع الحرفة يثبّت نصف قطر البطاقات بين 12 و16.
  static const double card = 16;
  static const double field = 12;
  static const double button = 14;
  static const double sheet = 24;

  /// الحبّة للعناصر الصغيرة فقط — شرائح، شارات، مؤشرات.
  static const double pill = 100;
}

/// إيقاع 4/8 — كل مسافة في التطبيق من هذا السلّم.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// أحجام الأيقونات كـ tokens بدل قيم عشوائية.
class AppIconSize {
  AppIconSize._();

  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
}

class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);

  /// تأخير تتابعي بين عناصر القائمة الواحدة.
  static const Duration stagger = Duration(milliseconds: 45);
}

class AppCurves {
  AppCurves._();

  /// تباطؤ أسّي — الحركة تبدأ سريعة وتستقر بهدوء.
  static const Curve emphasized = Curves.easeOutCubic;
  static const Curve standard = Curves.easeOutQuart;
}

class AppElevation {
  AppElevation._();

  /// طبقتان: ظلّ قريب ضيّق يرسم الحافة، وظلّ بعيد واسع يوحي بالمسافة.
  ///
  /// طبقة واحدة عريضة تُقرأ كضبابة ملوّنة؛ الطبقتان تُقرآن كارتفاع. الشفافية
  /// منخفضة عمداً — الظل يُحسّ ولا يُرى.
  static List<BoxShadow> _layered(
    Color shadow, {
    required double opacity,
    required double spread,
    required double drop,
  }) {
    return [
      BoxShadow(
        color: shadow.withValues(alpha: opacity * 0.55),
        blurRadius: spread * 0.35,
        offset: Offset(0, drop * 0.35),
      ),
      BoxShadow(
        color: shadow.withValues(alpha: opacity),
        blurRadius: spread,
        offset: Offset(0, drop),
      ),
    ];
  }

  /// سطح مرفوع قليلاً داخل التمرير — البطاقة الرئيسية مثلاً.
  static List<BoxShadow> raised(AppPalette palette) => palette.isDark
      ? const []
      : _layered(palette.shadow, opacity: 0.10, spread: 16, drop: 6);

  /// سطح طافٍ فوق المحتوى — شريط التنقل والزر العائم.
  static List<BoxShadow> floating(AppPalette palette) => palette.isDark
      ? const []
      : _layered(palette.shadow, opacity: 0.14, spread: 24, drop: 10);
}
