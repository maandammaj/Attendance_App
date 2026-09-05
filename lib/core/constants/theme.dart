import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_tokens.dart';

/// السمة الوحيدة في التطبيق. تُبنى من [AppPalette] لا من `fromSeed`، فكل
/// لون هنا قيمة مُتحقَّق تباينها لا نتيجة اشتقاق.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(Brightness.light, AppPalette.light);
  static ThemeData get darkTheme => _build(Brightness.dark, AppPalette.dark);

  static ThemeData _build(Brightness brightness, AppPalette palette) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: palette.primary,
      onPrimary: palette.onPrimary,
      primaryContainer: palette.primary.withValues(alpha: isDark ? 0.22 : 0.10),
      onPrimaryContainer: isDark ? palette.onSurface : palette.primary,
      secondary: palette.info,
      onSecondary: palette.onPrimary,
      tertiary: palette.accent,
      onTertiary: palette.onAccent,
      tertiaryContainer: palette.accent.withValues(alpha: isDark ? 0.20 : 0.12),
      onTertiaryContainer: palette.accent,
      surface: palette.surface,
      onSurface: palette.onSurface,
      surfaceContainerHighest: palette.surfaceAlt,
      onSurfaceVariant: palette.onSurfaceVariant,
      error: palette.negative,
      onError: Colors.white,
      errorContainer: palette.negative.withValues(alpha: isDark ? 0.20 : 0.10),
      onErrorContainer: palette.negative,
      outline: palette.outline,
      outlineVariant: palette.outline,
      scrim: palette.scrim,
      inverseSurface: palette.onSurface,
      onInverseSurface: palette.surface,
      shadow: Colors.black,
    );

    final textTheme = _textTheme(isDark, palette);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      dividerColor: palette.outline,
      splashFactory: InkSparkle.splashFactory,
      extensions: [AppPaletteExtension(palette)],

      iconTheme: IconThemeData(size: AppIconSize.lg, color: palette.onSurface),
      dividerTheme:
          DividerThemeData(color: palette.outline, space: 1, thickness: 1),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _FadeThroughTransitionBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: _FadeThroughTransitionBuilder(),
          TargetPlatform.windows: _FadeThroughTransitionBuilder(),
          TargetPlatform.linux: _FadeThroughTransitionBuilder(),
        },
      ),

      // بلا هذا يأخذ الزر العائم `primaryContainer` الافتراضي، فيظهر رمادياً
      // باهتاً كأنه معطّل — والزر هو الإجراء الرئيسي للشاشة.
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: palette.onPrimary,
        elevation: 0,
        focusElevation: 0,
        hoverElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),

      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: palette.background,
        foregroundColor: palette.onSurface,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(size: AppIconSize.lg, color: palette.onSurface),
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),

      // سطح أبيض على خلفية #F2F2F2 بظل خفيف — العمق بالتلميح لا بالحد.
      // في الوضع الداكن يعود الحد لأن الظل لا يفصل هناك.
      cardTheme: CardThemeData(
        elevation: 0,
        color: palette.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: isDark
              ? BorderSide(color: palette.outline)
              : BorderSide.none,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 66,
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primary.withValues(alpha: isDark ? 0.24 : 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? palette.primary
                : palette.onSurfaceVariant,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: AppIconSize.lg,
            color: states.contains(WidgetState.selected)
                ? palette.primary
                : palette.onSurfaceVariant,
          ),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          // 52 يتجاوز حدّ 48dp للمس بهامش مريح.
          minimumSize: const Size(0, 52),
          backgroundColor: palette.primary,
          foregroundColor: palette.onPrimary,
          disabledBackgroundColor:
              palette.onSurfaceVariant.withValues(alpha: 0.18),
          disabledForegroundColor:
              palette.onSurfaceVariant.withValues(alpha: 0.60),
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 48),
          foregroundColor: palette.primary,
          textStyle: textTheme.labelLarge,
          side: BorderSide(color: palette.outline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 44),
          foregroundColor: palette.primary,
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor: palette.onSurfaceVariant,
        ),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? palette.onPrimary
                : palette.surface),
        trackColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? palette.primary
                : palette.surfaceAlt),
        trackOutlineColor: WidgetStatePropertyAll(palette.outline),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? palette.primary
                : Colors.transparent),
        side: BorderSide(color: palette.outline, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceAlt,
        selectedColor: palette.primary.withValues(alpha: isDark ? 0.26 : 0.12),
        side: BorderSide(color: palette.outline),
        labelStyle: textTheme.labelSmall,
        padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),

      listTileTheme: ListTileThemeData(
        iconColor: palette.onSurfaceVariant,
        titleTextStyle: textTheme.bodyLarge,
        subtitleTextStyle: textTheme.bodySmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceAlt,
        contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        isDense: false,
        labelStyle: textTheme.bodyMedium,
        // النص النائب يخضع لحدّ 4.5:1 كأي نص، فلا يُخفَّت أكثر من الثانوي.
        hintStyle:
            textTheme.bodyMedium?.copyWith(color: palette.onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: palette.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: palette.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: palette.primary, width: 1.8),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: palette.negative),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
          borderSide: BorderSide(color: palette.negative, width: 1.8),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: palette.scrim,
        dragHandleColor: palette.outline,
        shape: const RoundedRectangleBorder(
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
        ),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        barrierColor: palette.scrim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        titleTextStyle: textTheme.titleLarge,
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        backgroundColor: palette.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: palette.surface),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: palette.primary.withValues(alpha: 0.16),
        circularTrackColor: palette.primary.withValues(alpha: 0.16),
      ),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: palette.onSurface,
          borderRadius: BorderRadius.circular(AppRadius.field),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: palette.surface),
      ),

      // تلوين نطاق التحديد والمؤشّر — أسطح النظام تحمل التصميم أيضاً.
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: palette.primary,
        selectionColor: palette.primary.withValues(alpha: 0.26),
        selectionHandleColor: palette.primary,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
            palette.onSurfaceVariant.withValues(alpha: 0.45)),
        radius: const Radius.circular(AppRadius.pill),
        thickness: const WidgetStatePropertyAll(4),
      ),
    );
  }

  static TextTheme _textTheme(bool isDark, AppPalette palette) {
    // Cairo متغيّر: الوزن يُختار بـ fontVariations لا بملف لكل وزن. تمرير
    // fontWeight وحده يُبقي الخط على وزنه الافتراضي.
    TextStyle font(double size, int weight, double height,
            {double spacing = 0}) =>
        TextStyle(
          fontFamily: 'Cairo',
          fontSize: size,
          height: height,
          letterSpacing: spacing,
          fontWeight: FontWeight.values[(weight ~/ 100) - 1],
          fontVariations: [FontVariation('wght', weight.toDouble())],
        );

    // السلّم الطباعي لمهارة arabic-app-design، وارتفاعات سطر 1.45–1.6
    // مريحة للعربية.
    return TextTheme(
      displayLarge: font(40, 800, 1.15, spacing: -0.8),
      displayMedium: font(32, 800, 1.2, spacing: -0.5),
      displaySmall: font(26, 800, 1.25),
      headlineMedium: font(22, 700, 1.35),
      headlineSmall: font(20, 700, 1.4),
      titleLarge: font(20, 700, 1.4),
      titleMedium: font(16.5, 700, 1.45),
      titleSmall: font(15, 600, 1.5),
      bodyLarge: font(15, 600, 1.5),
      bodyMedium: font(14, 500, 1.55),
      bodySmall: font(13, 500, 1.55),
      labelLarge: font(12.5, 600, 1.5),
      labelMedium: font(12.5, 600, 1.5),
      labelSmall: font(11.5, 500, 1.6),
    ).apply(
      bodyColor: palette.onSurface,
      displayColor: palette.onSurface,
    );
  }
}

/// انتقال صفحات: تلاشٍ مع تكبير طفيف من حالة مرئية أصلاً.
class _FadeThroughTransitionBuilder extends PageTransitionsBuilder {
  const _FadeThroughTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // الانتقال نفسه حركة: من طلب تقليلها يصل للصفحة مباشرة.
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) return child;

    final curved =
        CurvedAnimation(parent: animation, curve: AppCurves.emphasized);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: 0.985, end: 1).animate(curved),
        child: child,
      ),
    );
  }
}

/// أرقام جدولية للبيانات — بدونها تهتز الأعمدة والعدّادات مع كل تغيّر رقم.
const tabularFigures = TextStyle(
  fontFeatures: [FontFeature.tabularFigures()],
);
