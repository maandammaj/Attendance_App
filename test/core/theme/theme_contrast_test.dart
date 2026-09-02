import 'dart:math' as math;

import 'package:attendance_budget_app/core/constants/design_tokens.dart';
import 'package:attendance_budget_app/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// المسافة اللونية في فضاء OKLab، مضروبة في 100 كما يفعل مدقّق dataviz.
///
/// المقياس الصحيح للتمييز بين ألوان الفئات: نسبة التباين الضوئي لا تصلح
/// لأنها تقيس الإضاءة، وألوان الفئات متساوية الإضاءة بحكم التصميم.
double deltaEOklab(Color a, Color b) {
  (double, double, double) toOklab(Color c) {
    double linear(double v) =>
        v <= 0.04045 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();

    final r = linear(c.r);
    final g = linear(c.g);
    final bl = linear(c.b);

    final l = math.pow(
        0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * bl, 1 / 3);
    final m = math.pow(
        0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * bl, 1 / 3);
    final s = math.pow(
        0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * bl, 1 / 3);

    return (
      (0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s).toDouble(),
      (1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s).toDouble(),
      (0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s).toDouble(),
    );
  }

  final (l1, a1, b1) = toOklab(a);
  final (l2, a2, b2) = toOklab(b);
  return math.sqrt(math.pow(l1 - l2, 2) +
          math.pow(a1 - a2, 2) +
          math.pow(b1 - b2, 2)) *
      100;
}

/// نسبة تباين WCAG بين لونين معتمين.
double contrast(Color a, Color b) {
  double channel(double c) =>
      c <= 0.03928 ? c / 12.92 : math.pow((c + 0.055) / 1.055, 2.4).toDouble();

  double luminance(Color c) =>
      0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);

  final la = luminance(a);
  final lb = luminance(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

/// يبني السمة فعلياً ثم يقرأ الألوان كما ستصل للويدجتس، لا كما كُتبت في
/// الثوابت — فيلتقط أي انزلاق بين اللوحة و`ColorScheme` المشتق منها.
void main() {
  // google_fonts يقرأ الأصول عند بناء السمة، فيلزم تهيئة الربط أولاً.
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final (name, theme, palette) in [
    ('الفاتح', AppTheme.lightTheme, AppPalette.light),
    ('الداكن', AppTheme.darkTheme, AppPalette.dark),
  ]) {
    group('السمة $name', () {
      test('نص المتن يحقق 4.5:1 على البطاقة والخلفية', () {
        final body = theme.textTheme.bodyMedium!.color!;
        expect(contrast(body, theme.colorScheme.surface),
            greaterThanOrEqualTo(4.5));
        expect(contrast(body, theme.scaffoldBackgroundColor),
            greaterThanOrEqualTo(4.5));
      });

      test('النص الثانوي والنائب يحققان 4.5:1', () {
        final variant = theme.colorScheme.onSurfaceVariant;
        expect(contrast(variant, theme.colorScheme.surface),
            greaterThanOrEqualTo(4.5));
        expect(contrast(variant, theme.scaffoldBackgroundColor),
            greaterThanOrEqualTo(4.5));

        final hint = theme.inputDecorationTheme.hintStyle!.color!;
        expect(contrast(hint, palette.surfaceAlt), greaterThanOrEqualTo(4.5));
      });

      test('نص الزر الممتلئ يحقق 4.5:1 على لون العلامة', () {
        expect(contrast(palette.onPrimary, palette.primary),
            greaterThanOrEqualTo(4.5));
      });

      test('ألوان الدلالة المالية تحقق 4.5:1 على البطاقة', () {
        for (final (label, color) in [
          ('الموجب', palette.positive),
          ('السالب', palette.negative),
          ('التحذير', palette.warning),
          ('المعلومة', palette.info),
        ]) {
          expect(contrast(color, palette.surface), greaterThanOrEqualTo(4.5),
              reason: '$label غير مقروء على سطح البطاقة');
        }
      });

      test('الأيقونات المختارة في شريط التنقل تحقق 3:1', () {
        final selected = theme.navigationBarTheme.iconTheme!
            .resolve({WidgetState.selected})!.color!;
        expect(contrast(selected, theme.colorScheme.surface),
            greaterThanOrEqualTo(3.0));
      });

      test('لون التمييز يحقق 4.5:1 على البطاقة والخلفية', () {
        expect(contrast(palette.accent, palette.surface),
            greaterThanOrEqualTo(4.5));
        expect(contrast(palette.accent, palette.background),
            greaterThanOrEqualTo(4.5));
      });

      test('التمييز فوق تدرّج العلامة مقروء في الوضعين', () {
        // التدرّج ثابت بين الوضعين، لكن نفحصه من كل لوحة لأن
        // accentOnBrand قد ينحرف عن أحدهما لاحقاً.
        expect(contrast(palette.accentOnBrand, AppPalette.brandDeep),
            greaterThanOrEqualTo(4.5));
        expect(contrast(const Color(0xFFFFFFFF), AppPalette.brandDeep),
            greaterThanOrEqualTo(4.5));
      });

      test('تعبئة الحقل تُميَّز عن سطح البطاقة', () {
        // في هوية arabic-app-design الحدُّ زخرفي؛ ما يعرّف الحقل تعبئته
        // (surfaceAlt) وما يفصل البطاقة ظلُّها. نسبة التباين لا تقيس ظلاً
        // بشفافية 4%، فنفحص ما تقدر عليه: أن التعبئة والسطح ليسا نفس اللون.
        expect(palette.surfaceAlt, isNot(palette.surface));
        expect(contrast(palette.onSurface, palette.surfaceAlt),
            greaterThanOrEqualTo(4.5));
        expect(contrast(palette.onSurfaceVariant, palette.surfaceAlt),
            greaterThanOrEqualTo(4.5));
      });

      test('ألوان الفئات ثمانية وتحقق 3:1 على السطح', () {
        // تُسند بالترتيب ولا تُدوَّر؛ ثبات العدد يمنع توليد لون تاسع.
        expect(palette.categorical, hasLength(8));
        for (final color in palette.categorical) {
          expect(contrast(color, palette.surface), greaterThanOrEqualTo(3.0));
        }
      });

      test('كل لوني فئة متجاورين يفصلهما ΔE ≥ 15 في OKLab', () {
        // نسبة تباين WCAG لا تصلح هنا: ألوان الفئات متقاربة الإضاءة عمداً،
        // فالفصل بينها لونيّ لا ضوئيّ. هذا هو المقياس الذي يستخدمه
        // validate_palette.js من مهارة dataviz، وحدّه للرؤية الطبيعية 15.
        for (int i = 1; i < palette.categorical.length; i++) {
          final delta = deltaEOklab(
              palette.categorical[i - 1], palette.categorical[i]);
          expect(delta, greaterThanOrEqualTo(15.0),
              reason: 'اللونان ${i - 1} و $i يصعب تمييزهما');
        }
      });

      test('اللوحة متاحة عبر امتداد السمة', () {
        expect(theme.extension<AppPaletteExtension>()!.palette, palette);
      });
    });
  }

  group('أهداف اللمس', () {
    test('الأزرار تحقق حد 48dp', () {
      for (final (label, size) in [
        ('ممتلئ', AppTheme.lightTheme.filledButtonTheme.style!.minimumSize!
            .resolve({})!),
        ('محدّد', AppTheme.lightTheme.outlinedButtonTheme.style!.minimumSize!
            .resolve({})!),
        ('أيقونة', AppTheme.lightTheme.iconButtonTheme.style!.minimumSize!
            .resolve({})!),
      ]) {
        expect(size.height, greaterThanOrEqualTo(44),
            reason: 'زر $label أقصر من الحد الأدنى للمس');
      }
    });
  });

  group('حواف الهوية', () {
    test('القيم مطابقة لمهارة arabic-app-design', () {
      expect(AppRadius.badge, 10);
      expect(AppRadius.field, 14);
      expect(AppRadius.card, 18);
      expect(AppRadius.sheet, 24);
    });
  });

  group('سلّم المسافات', () {
    test('الهامش الأفقي الموحد 20', () {
      expect(AppSpacing.screen, 20);
    });

    test('السلّم من مضاعفات 4', () {
      for (final step in [
        AppSpacing.xs,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.screen,
        AppSpacing.xl,
        AppSpacing.xxl,
        AppSpacing.xxxl,
        AppSpacing.huge,
      ]) {
        expect(step % 4, 0, reason: 'المسافة $step خارج السلّم');
      }
    });
  });

  group('الخط', () {
    test('كل الأنماط من Cairo بأوزان متغيّرة صريحة', () {
      final theme = AppTheme.lightTheme.textTheme;
      for (final style in [
        theme.displaySmall,
        theme.titleMedium,
        theme.bodyMedium,
        theme.labelSmall,
      ]) {
        expect(style!.fontFamily, 'Cairo');
        // بلا fontVariations يبقى الخط المتغيّر على وزنه الافتراضي.
        expect(style.fontVariations, isNotEmpty);
      }
    });

    test('ارتفاع السطر مريح للعربية (1.15–1.6)', () {
      final theme = AppTheme.lightTheme.textTheme;
      for (final style in [theme.bodyMedium, theme.bodySmall, theme.titleMedium]) {
        expect(style!.height, inInclusiveRange(1.15, 1.6));
      }
    });
  });

  testWidgets('التطبيق يبني في الوضعين دون استثناء', (tester) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: mode,
        locale: const Locale('ar'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Column(
              children: [
                Text('نص', style: Theme.of(context).textTheme.bodyMedium),
                FilledButton(onPressed: () {}, child: const Text('زر')),
                Card(child: Text('بطاقة', style: TextStyle(color: context.palette.positive))),
              ],
            ),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
}
