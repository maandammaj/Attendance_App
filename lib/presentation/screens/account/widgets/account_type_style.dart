import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../domain/entities/account_entity.dart';

/// الشكل العربي لتصنيف الحساب: اسمه، أيقونته، ولونه.
///
/// وُجد لأن الشاشة كانت تعرض `type.name` — أي اسم قيمة الـenum الإنجليزي
/// («supplier») داخل واجهة عربية بالكامل.
///
/// اللون من [AppPalette.categorical] بترتيب ثابت لا يُدوَّر: أربعة تصنيفات
/// تأخذ أول أربع خانات، وهي خانات مُتحقَّق من فصلها تحت عمى الألوان.
extension AccountTypeStyle on AccountTypeEntity {
  String get arabicLabel => switch (this) {
        AccountTypeEntity.supplier => 'مورّد',
        AccountTypeEntity.customer => 'عميل',
        AccountTypeEntity.friend => 'صديق',
        AccountTypeEntity.personal => 'شخصي',
      };

  IconData get icon => switch (this) {
        AccountTypeEntity.supplier => Icons.local_shipping_outlined,
        AccountTypeEntity.customer => Icons.storefront_outlined,
        AccountTypeEntity.friend => Icons.people_alt_outlined,
        AccountTypeEntity.personal => Icons.account_balance_wallet_outlined,
      };

  Color color(AppPalette palette) => switch (this) {
        AccountTypeEntity.supplier => palette.categorical[0],
        AccountTypeEntity.customer => palette.categorical[1],
        AccountTypeEntity.friend => palette.categorical[2],
        AccountTypeEntity.personal => palette.categorical[3],
      };
}
