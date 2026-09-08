import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/local/repositories/company_repository_impl.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import 'attendance_provider.dart';
import 'dashboard_provider.dart';
import 'transaction_provider.dart';
import 'debt_provider.dart';
import 'analytics_provider.dart';
import 'account_provider.dart';
import 'reminder_provider.dart';
import 'profile_provider.dart';

part 'company_provider.g.dart';

final companyRepositoryProvider =
    Provider<CompanyRepository>((ref) => CompanyRepositoryImpl());

@riverpod
Future<List<CompanyEntity>> companies(Ref ref) async {
  return await ref.read(companyRepositoryProvider).getAll();
}

/// الجهة المعروضة حالياً. كل شاشة دوام أو راتب أو تقرير تقرأ منها.
///
/// تراقب `profileProvider` لأن المؤشر مخزَّن فيه: تبديل الجهة يحدّث الملف
/// فتُعاد قراءة هذه تلقائياً ومعها كل ما يعتمد عليها.
@riverpod
Future<CompanyEntity?> activeCompany(Ref ref) async {
  // إبقاء حيّ صريح. هذا المزوّد يُنتظَر بـ `await` من مزوّدات أخرى، ومع
  // الإتلاف التلقائي يُتلَف بينما المنتظِر معلّق عند `await`، ثم يُعاد إنشاؤه
  // بمستقبل جديد فيُبطَل المنتظِر ويبدأ من جديد — حلقة إعادة بناء لا تنتهي
  // تظهر كشاشة تحميل عالقة وGC متواصل. تُستدعى في الجسم لا كوسم، لأن تغيير
  // الوسم يحتاج إعادة توليد، و`build_runner` معطّل على هذا الـSDK.
  ref.keepAlive();

  await ref.watch(profileProvider.future);
  return await ref.read(companyRepositoryProvider).getActive();
}

// keepAlive: هذه المتحكّمات بعمر التطبيق لا بعمر شاشة. بدونها يُتلَف
// المتحكّم حين تُبدَّل شاشته أثناء عملية جارية — بوابة الإعداد تفعل ذلك فور
// إنشاء أول جهة — فتُكتب الحالة على مزوّد مُتلَف ويُرمى
// "Bad state: Future already completed".
@Riverpod(keepAlive: true)
class CompanyController extends _$CompanyController {
  @override
  FutureOr<void> build() => null;

  Future<int?> create(CompanyEntity company) async {
    state = const AsyncLoading();
    try {
      final id = await ref.read(companyRepositoryProvider).create(company);
      _invalidateAll();
      await _reschedule();
      state = const AsyncData(null);
      return id;
    } catch (error, stack) {
      state = AsyncError(error, stack);
      return null;
    }
  }

  Future<void> save(CompanyEntity company) async {
    state = const AsyncLoading();
    try {
      await ref.read(companyRepositoryProvider).update(company);
      _invalidateAll();
      await _reschedule();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  Future<void> switchTo(int companyId) async {
    state = const AsyncLoading();
    try {
      await ref.read(companyRepositoryProvider).setActive(companyId);
      _invalidateAll();
      await _reschedule();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  /// يحذف الجهة وكل سجلات دوامها.
  Future<void> delete(int companyId) async {
    state = const AsyncLoading();
    try {
      await ref.read(companyRepositoryProvider).delete(companyId);
      _invalidateAll();
      state = const AsyncData(null);
    } catch (error, stack) {
      state = AsyncError(error, stack);
    }
  }

  /// تذكيرات الوردية مشتقة من جدول الجهة، فأي تغيير فيها يبطل الجدولة.
  ///
  /// تُقرأ الجهة من المستودع مباشرةً لا من `activeCompanyProvider`: الأخير
  /// يراقب `profileProvider` الذي أُبطل للتوّ، وانتظاره هنا يُدخله في حلقة.
  Future<void> _reschedule() async {
    await ref.read(reminderSchedulerProvider).rescheduleAll(
          company: await ref.read(companyRepositoryProvider).getActive(),
          settings: await ref.read(reminderSettingsProvider.future),
        );
  }

  /// تبديل الجهة يغيّر كل رقم في التطبيق تقريباً، فالإبطال شامل عمداً.
  void _invalidateAll() {
    ref.invalidate(profileProvider);
    ref.invalidate(companiesProvider);
    ref.invalidate(activeCompanyProvider);
    ref.invalidate(todayAttendanceProvider);
    ref.invalidate(monthlyAttendanceProvider);
    ref.invalidate(attendanceStatsProvider);
    ref.invalidate(dashboardDataProvider);
    // كل هذه صارت تابعة للجهة بعد الفصل الكامل.
    ref.invalidate(anyOpenSessionProvider);
    ref.invalidate(monthlyTransactionsProvider);
    ref.invalidate(allDebtsProvider);
    ref.invalidate(debtSummaryProvider);
    ref.invalidate(allAccountsProvider);
    ref.invalidate(budgetLimitsProvider);
    ref.invalidate(budgetStatusProvider);
    ref.invalidate(analyticsReportProvider);
    ref.invalidate(companyComparisonProvider);
  }
}
