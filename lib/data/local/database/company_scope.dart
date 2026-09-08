import 'package:isar_community/isar.dart';

import '../../models/company_model.dart';
import '../../models/profile_model.dart';

/// نطاق الجهة الفعّالة في طبقة البيانات.
///
/// كانت هذه القاعدة منسوخة حرفياً في أربعة مستودعات — نسخ متطابقة بالبايت،
/// فأي تصحيح لها يلزم تطبيقه أربع مرات وإلا اختلفت الجهة التي يراها مستودع
/// عن التي يراها آخر في اللحظة نفسها.
class CompanyScope {
  const CompanyScope._();

  /// معرّف الجهة المعروضة، وإلا أول جهة غير مؤرشفة.
  ///
  /// الفشل صريح بلا جهة: كتابة سجل بلا جهة تُنتج بيانات لا تظهر في أي
  /// استعلام مُرشَّح، وهي أسوأ من رسالة خطأ.
  static Future<int> activeId(Isar isar) async {
    final profile = await isar.profileModels.get(0);
    final id = profile?.activeCompanyId;
    if (id != null) return id;

    final fallback = await isar.companyModels
        .filter()
        .isArchivedEqualTo(false)
        .findFirst();
    if (fallback == null) throw Exception('لم تُحدَّد جهة عمل');
    return fallback.id;
  }

  /// يرفض سجلاً يخص جهة أخرى قبل تعديله أو حذفه.
  ///
  /// المعرّفات تصل من الواجهة، والواجهة مُرشَّحة بالجهة — لكن شاشة بقيت
  /// مفتوحة أثناء تبديل الجهة تحمل معرّفات الجهة السابقة، فتُعدَّل بيانات
  /// جهة لا يراها المستخدم أمامه.
  static void assertOwned({
    required int? recordCompanyId,
    required int activeCompanyId,
    required String subject,
  }) {
    if (recordCompanyId == null) {
      throw Exception('$subject غير موجود');
    }
    if (recordCompanyId != activeCompanyId) {
      throw Exception('$subject يخص جهة عمل أخرى');
    }
  }
}
