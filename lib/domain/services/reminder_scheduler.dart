import 'dart:developer' as developer;

import '../../core/constants/app_constants.dart';
import '../../core/constants/notification_ids.dart';
import '../../core/services/notification_service.dart';
import '../../core/utils/date_helpers.dart';
import '../../data/models/notification_model.dart';
import '../entities/company_entity.dart';
import '../entities/reminder_settings_entity.dart';
import '../repositories/debt_repository.dart';

/// يترجم جدول الدوام وقائمة الديون إلى تنبيهات مجدولة في نظام التشغيل.
///
/// الجدولة إعلانية بالكامل: كل استدعاء لـ [rescheduleAll] يلغي النطاقات
/// المعنية ثم يعيد بناءها من الحالة الحالية. هذا يجعل تغيير الإعدادات أو
/// جدول الدوام أو سداد دين ينعكس فوراً دون تتبّع فروقات.
class ReminderScheduler {
  ReminderScheduler({
    required this.debtRepository,
    NotificationService? notifications,
  }) : _notifications = notifications ?? NotificationService();

  final DebtRepository debtRepository;
  final NotificationService _notifications;

  Future<void> rescheduleAll({
    required CompanyEntity? company,
    required ReminderSettingsEntity settings,
  }) async {
    for (final range in NotificationIds.scheduledRanges) {
      await _notifications.cancelRange(range);
    }

    if (company != null) {
      await _scheduleShiftReminders(company, settings);
    }
    await _scheduleDebtReminders(settings);
    await _scheduleSummaries(settings);

    developer.log(
      'أُعيدت جدولة التنبيهات: ${(await _notifications.pending()).length} تنبيه معلّق',
      name: 'notifications.reschedule',
      level: 500,
    );
  }

  // ── الدوام ──────────────────────────────────────────────────────

  Future<void> _scheduleShiftReminders(
    CompanyEntity company,
    ReminderSettingsEntity settings,
  ) async {
    for (final day in company.workSchedule) {
      if (!day.isWorkingDay || day.isHoliday) continue;

      final start = _parseTime(day.startTime);
      final dayName = DateHelpers.arabicDayNameOfScheduleDay(day.dayOfWeek);

      if (start != null && settings.shiftStartEnabled) {
        final when = _shift(start, -settings.shiftStartLeadMinutes);
        await _notifications.scheduleWeekly(
          id: NotificationIds.shiftStart.idFor(day.dayOfWeek),
          title: 'وردية $dayName تبدأ قريباً',
          body: 'تبدأ الساعة ${day.startTime} — لا تنسَ تسجيل الحضور.',
          dayOfWeek: day.dayOfWeek,
          hour: when.$1,
          minute: when.$2,
          category: NotificationCategory.attendance,
          payload: 'attendance',
        );

        if (settings.missedCheckInEnabled) {
          final late = _shift(start, settings.missedCheckInAfterMinutes);
          await _notifications.scheduleWeekly(
            id: NotificationIds.missedCheckIn.idFor(day.dayOfWeek),
            title: 'لم تسجّل حضورك بعد',
            body:
                'مرّت ${settings.missedCheckInAfterMinutes} دقيقة على بداية وردية $dayName دون تسجيل حضور.',
            dayOfWeek: day.dayOfWeek,
            hour: late.$1,
            minute: late.$2,
            category: NotificationCategory.attendance,
            payload: 'attendance',
          );
        }
      }

      final end = _parseTime(day.endTime);
      if (end != null && settings.shiftEndEnabled) {
        final when = _shift(end, -settings.shiftEndLeadMinutes);
        // وردية عابرة لمنتصف الليل: النهاية تقع في اليوم التالي.
        // وردية عابرة لمنتصف الليل تنتهي في اليوم التالي (7 يلتف إلى 1).
        final targetDay =
            day.isCrossDay && end.$1 < (_parseTime(day.startTime)?.$1 ?? 0)
                ? (day.dayOfWeek % 7) + 1
                : day.dayOfWeek;
        await _notifications.scheduleWeekly(
          id: NotificationIds.shiftEnd.idFor(day.dayOfWeek),
          title: 'وردية $dayName تنتهي قريباً',
          body:
              'تنتهي الساعة ${day.endTime} — سجّل انصرافك حتى تُحتسب ساعاتك بدقة.',
          dayOfWeek: targetDay,
          hour: when.$1,
          minute: when.$2,
          category: NotificationCategory.attendance,
          payload: 'attendance',
        );
      }
    }
  }

  // ── الديون ──────────────────────────────────────────────────────

  Future<void> _scheduleDebtReminders(ReminderSettingsEntity settings) async {
    if (!settings.debtDueEnabled) return;

    final debts = await debtRepository.getAllDebts();
    final now = DateTime.now();

    for (final debt in debts) {
      final dueDate = debt.dueDate;
      if (dueDate == null || debt.remainingAmount <= 0) continue;
      if (debt.status == 'paid') continue;

      final direction = debt.debtType == 'owe' ? 'عليك' : 'لك';

      for (final leadDays in settings.debtDueLeadDays) {
        final when = DateTime(
          dueDate.year,
          dueDate.month,
          dueDate.day,
          10,
        ).subtract(Duration(days: leadDays));
        if (!when.isAfter(now)) continue;

        await _notifications.scheduleOnce(
          // المعرّف يمزج رقم الدين بعدد أيام التنبيه المسبق حتى لا يطغى
          // تنبيه على آخر لنفس الدين.
          id: NotificationIds.debtDue.idFor((debt.id * 10) + leadDays),
          title: 'دَين $direction يستحق بعد $leadDays ${_dayWord(leadDays)}',
          body:
              '${debt.personName}: المتبقي ${_money(debt.remainingAmount)} — تاريخ الاستحقاق ${DateHelpers.formatShortDate(dueDate)}.',
          scheduledTime: when,
          category: NotificationCategory.debt,
          payload: 'debt:${debt.id}',
        );
      }

      if (settings.debtOverdueEnabled) {
        final overdueAt = DateTime(
          dueDate.year,
          dueDate.month,
          dueDate.day,
          10,
        ).add(const Duration(days: 1));
        await _notifications.scheduleOnce(
          id: NotificationIds.debtOverdue.idFor(debt.id),
          title: 'دَين متأخر',
          body:
              '${debt.personName}: تجاوز تاريخ الاستحقاق والمتبقي ${_money(debt.remainingAmount)}.',
          scheduledTime: overdueAt,
          category: NotificationCategory.debt,
          payload: 'debt:${debt.id}',
        );
      }
    }
  }

  // ── الملخصات الدورية ────────────────────────────────────────────

  Future<void> _scheduleSummaries(ReminderSettingsEntity settings) async {
    if (settings.dailySummaryEnabled) {
      final time = _parseTime(settings.dailySummaryTime)!;
      await _notifications.scheduleDaily(
        id: NotificationIds.dailySummary.start,
        title: 'ملخص يومك',
        body: 'افتح التطبيق لمراجعة ساعاتك ومصروفاتك اليوم.',
        hour: time.$1,
        minute: time.$2,
        category: NotificationCategory.summary,
        payload: 'summary:daily',
      );
    }

    if (settings.weeklySummaryEnabled) {
      final time = _parseTime(settings.weeklySummaryTime)!;
      await _notifications.scheduleWeekly(
        id: NotificationIds.weeklySummary.start,
        title: 'ملخص الأسبوع',
        body: 'راجع ساعات الأسبوع والإضافي والمصروفات في شاشة التحليلات.',
        dayOfWeek: settings.weeklySummaryDayOfWeek,
        hour: time.$1,
        minute: time.$2,
        category: NotificationCategory.summary,
        payload: 'summary:weekly',
      );
    }

    if (settings.monthlySummaryEnabled) {
      final time = _parseTime(settings.monthlySummaryTime)!;
      final now = DateTime.now();
      // تُجدول للشهر الحالي إن لم يمضِ يومه، وإلا للشهر القادم؛ ثم يُعاد
      // تجديدها في دورة إعادة الجدولة التالية.
      final thisMonth = _clampedMonthDay(
          now.year, now.month, settings.monthlySummaryDayOfMonth, time);
      final target = thisMonth.isAfter(now)
          ? thisMonth
          : _clampedMonthDay(
              now.year, now.month + 1, settings.monthlySummaryDayOfMonth, time);

      await _notifications.scheduleOnce(
        id: NotificationIds.monthlySummary.start,
        title: 'التقرير الشهري جاهز',
        body: 'راجع كشف الراتب وصدّره PDF من شاشة التقارير.',
        scheduledTime: target,
        category: NotificationCategory.summary,
        payload: 'summary:monthly',
      );
    }
  }

  static DateTime _clampedMonthDay(
      int year, int month, int day, (int, int) time) {
    final lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, day > lastDay ? lastDay : day, time.$1, time.$2);
  }

  static (int, int)? _parseTime(String? hhmm) {
    if (hhmm == null) return null;
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return (hour, minute);
  }

  /// يزيح وقتاً بعدد دقائق موجب أو سالب مع الالتفاف حول اليوم.
  static (int, int) _shift((int, int) time, int deltaMinutes) {
    var total = (time.$1 * 60) + time.$2 + deltaMinutes;
    total %= 24 * 60;
    if (total < 0) total += 24 * 60;
    return (total ~/ 60, total % 60);
  }

  static String _dayWord(int days) => days == 1 ? 'يوم' : 'أيام';

  static String _money(double value) =>
      '${value.toStringAsFixed(0)} ${AppConstants.defaultCurrency}';
}
