import 'package:attendance_budget_app/core/constants/design_tokens.dart';
import 'package:attendance_budget_app/domain/entities/account_entity.dart';
import 'package:attendance_budget_app/presentation/screens/account/widgets/account_type_style.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('تصنيف الحساب', () {
    test('كل تصنيف يحمل اسماً عربياً لا اسم قيمة الـenum', () {
      // الشاشة كانت تعرض `type.name` فيظهر «supplier» داخل واجهة عربية.
      for (final type in AccountTypeEntity.values) {
        expect(type.arabicLabel, isNotEmpty);
        expect(
          type.arabicLabel,
          isNot(equals(type.name)),
          reason: 'التصنيف ${type.name} ما زال يعرض اسمه الإنجليزي',
        );
        expect(
          RegExp(r'^[؀-ۿ\s]+$').hasMatch(type.arabicLabel),
          isTrue,
          reason: 'التسمية «${type.arabicLabel}» ليست عربية خالصة',
        );
      }
    });

    test('لا تسمية مكرّرة بين التصنيفات', () {
      final labels =
          AccountTypeEntity.values.map((t) => t.arabicLabel).toSet();
      expect(labels.length, AccountTypeEntity.values.length);
    });

    test('كل تصنيف يأخذ خانة لون ثابتة ومتمايزة في الوضعين', () {
      for (final palette in [AppPalette.light, AppPalette.dark]) {
        final colors =
            AccountTypeEntity.values.map((t) => t.color(palette)).toList();
        expect(colors.toSet().length, AccountTypeEntity.values.length,
            reason: 'تصنيفان يتشاركان اللون نفسه');
        // الخانات تُسند بالترتيب ولا تُدوَّر — أربعة تصنيفات، أول أربع خانات.
        expect(colors, palette.categorical.take(4).toList());
      }
    });

    test('كل تصنيف يحمل أيقونة مميّزة', () {
      final icons = AccountTypeEntity.values.map((t) => t.icon).toSet();
      expect(icons.length, AccountTypeEntity.values.length);
    });
  });
}
