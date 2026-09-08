import '../entities/company_entity.dart';

abstract class CompanyRepository {
  /// كل الجهات، المؤرشفة أخيراً.
  Future<List<CompanyEntity>> getAll({bool includeArchived = true});

  Future<CompanyEntity?> getById(int id);

  /// الجهة الفعّالة بحسب `ProfileModel.activeCompanyId`، أو أول جهة غير
  /// مؤرشفة إن كان المؤشر ضائعاً.
  Future<CompanyEntity?> getActive();

  /// ينشئ جهة ويعيد معرّفها. أول جهة تصير الفعّالة تلقائياً.
  Future<int> create(CompanyEntity company);

  Future<void> update(CompanyEntity company);

  Future<void> setActive(int companyId);

  /// يحذف الجهة **وكل سجلات دوامها** — عملية لا رجعة فيها.
  Future<void> delete(int companyId);
}
