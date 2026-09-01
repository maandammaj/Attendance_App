import 'package:flutter/material.dart';
import '../presentation/screens/budget/budget_dashboard_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/attendance/attendance_screen.dart';
import '../presentation/screens/attendance/attendance_history_screen.dart';
import '../presentation/screens/attendance/monthly_report_screen.dart';
import '../presentation/screens/account/accounts_screen.dart';
import '../presentation/screens/home/notification_history_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String attendance = '/attendance';
  static const String budget = '/budget';
  static const String profile = '/profile';
  static const String monthlyReport = '/monthly-report';
  static const String accounts = '/accounts';
  static const String notifications = '/notification-history';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomeScreen(),
    attendance: (context) => const AttendanceScreen(),
    '/attendance-history': (context) => const AttendanceHistoryScreen(),
    monthlyReport: (context) => const MonthlyReportScreen(),
    budget: (context) => const BudgetDashboardScreen(),
    profile: (context) => const ProfileScreen(),
    accounts: (context) => const AccountsScreen(),
    notifications: (context) => const NotificationHistoryScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return null;
  }
}
