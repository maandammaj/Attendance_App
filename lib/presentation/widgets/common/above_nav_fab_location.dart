import 'package:flutter/material.dart';

import '../../../core/constants/design_tokens.dart';

/// موضع زر عائم داخل تبويب، مرفوع فوق شريط التنقل العائم.
///
/// التبويبات الخمسة تعيش داخل `HomeScreen` وهو يرفع `extendBody`، فشريطه
/// يطفو فوق أجسامها. زرٌّ بموضع قياسي يقع **تحت** الشريط ويختفي بالكامل —
/// وهذا ما كان يخفي «دين جديد» و«إضافة حساب»، فيصير الإجراء الرئيسي
/// لكلتا الشاشتين غير قابل للوصول أصلاً.
class AboveNavFabLocation extends StandardFabLocation
    with FabEndOffsetX, FabFloatOffsetY {
  const AboveNavFabLocation();

  @override
  double getOffsetY(
    ScaffoldPrelayoutGeometry scaffoldGeometry,
    double adjustment,
  ) =>
      super.getOffsetY(scaffoldGeometry, adjustment) -
      AppSpacing.bottomNavInset;

  @override
  String toString() => 'AboveNavFabLocation';
}

/// النسخة الوحيدة — الموضع بلا حالة.
const aboveNavFabLocation = AboveNavFabLocation();
