import 'package:flutter/material.dart';

import '../presentation/screens/account/accounts_screen.dart';
import '../presentation/screens/analytics/analytics_screen.dart';
import '../presentation/screens/attendance/attendance_history_screen.dart';
import '../presentation/screens/attendance/attendance_screen.dart';
import '../presentation/screens/attendance/monthly_report_screen.dart';
import '../presentation/screens/budget/budget_dashboard_screen.dart';
import '../presentation/screens/home/notification_history_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/reminders/budget_limits_screen.dart';
import '../presentation/screens/schedule/work_schedule_screen.dart';
import '../domain/entities/company_entity.dart';
import '../presentation/screens/companies/companies_screen.dart';
import '../presentation/screens/companies/company_editor_screen.dart';
import '../presentation/screens/reminders/reminder_settings_screen.dart';

class AppRoutes {
  AppRoutes._();

  /// الشاشة الرئيسية تُركَّب عبر `MaterialApp.home` لا كمسار مُسمّى، لأن
  /// بوابتي القفل والإعداد تغلّفانها ويجب أن تبقيا داخل الـNavigator.
  /// `pushNamed('/')` كان يعيد الدخول للهيكل بدل الرجوع إليه على أي حال.
  static const String attendance = '/attendance';
  static const String attendanceHistory = '/attendance-history';
  static const String budget = '/budget';
  static const String profile = '/profile';
  static const String monthlyReport = '/monthly-report';
  static const String analytics = '/analytics';
  static const String accounts = '/accounts';
  static const String notifications = '/notification-history';
  static const String reminders = '/reminders';
  static const String companies = '/companies';
  static const String companyEditor = '/company-editor';
  static const String budgetLimits = '/budget-limits';
  static const String workSchedule = '/work-schedule';

  static Map<String, WidgetBuilder> get routes => {
        attendance: (context) => const AttendanceScreen(),
        attendanceHistory: (context) => const AttendanceHistoryScreen(),
        monthlyReport: (context) => const MonthlyReportScreen(),
        analytics: (context) => const AnalyticsScreen(),
        budget: (context) => const BudgetDashboardScreen(),
        profile: (context) => const ProfileScreen(),
        accounts: (context) => const AccountsScreen(),
        notifications: (context) => const NotificationHistoryScreen(),
        reminders: (context) => const ReminderSettingsScreen(),
    companies: (context) => const CompaniesScreen(),
    companyEditor: (context) => CompanyEditorScreen(
          company: ModalRoute.of(context)?.settings.arguments as CompanyEntity?,
        ),
        budgetLimits: (context) => const BudgetLimitsScreen(),
        workSchedule: (context) => const WorkScheduleScreen(),
      };
}
