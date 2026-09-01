import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/attendance_provider.dart';
import '../../presentation/providers/profile_provider.dart';
import '../../presentation/providers/transaction_provider.dart';
import '../../presentation/providers/debt_provider.dart';
import '../../core/services/notification_service.dart';
import '../entities/transaction_entity.dart';

class AutomationService {
  static Future<void> runDailyAutomation(WidgetRef ref) async {
    final now = DateTime.now();
    final profile = ref.read(profileProvider).valueOrNull;
    if (profile == null) return;

    // 1. التحقق من السجلات المفتوحة المنسية
    final todayRecord = ref.read(todayAttendanceProvider).valueOrNull;
    if (todayRecord != null && todayRecord.checkIn != null && todayRecord.checkOut == null) {
      // إذا مر وقت طويل على تسجيل الدخول (مثلاً أكثر من 16 ساعة)
      if (now.difference(todayRecord.checkIn!).inHours > 16) {
        NotificationService().showNotification(
          id: 999,
          title: 'هل نسيت تسجيل الخروج؟',
          body: 'لديك سجل دخول نشط منذ فترة طويلة، يرجى إغلاقه لضمان دقة الحسابات.',
        );
      }
    }

    // 2. تسوية المصاريف المتكررة (مثل الإيجار)
    final transRepo = ref.read(transactionRepositoryProvider);
    final allTrans = await transRepo.getMonthlyTransactions(now.year, now.month);
    
    // مثال: التحقق من "إيجار السكن" المتكرر يوم 18 (تاريخ اليوم كمثال)
    if (now.day == 18) {
      final exists = allTrans.any((t) => t.categoryName == 'إيجار' && t.date.day == 18);
      if (!exists) {
        // إضافة تلقائية (هذا يتطلب إعداد مسبق في الملف الشخصي للمصاريف الثابتة)
      }
    }
    
    // 3. تذكير بالديون المستحقة
    final debtSummary = ref.read(debtSummaryProvider).valueOrNull;
    if (debtSummary != null && debtSummary.remainingOwe > 0) {
      // يمكن إضافة منطق تنبيه هنا
    }
  }
}
