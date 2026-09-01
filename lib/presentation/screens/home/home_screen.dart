import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../providers/attendance_provider.dart';
import '../attendance/attendance_screen.dart';
import '../budget/budget_dashboard_screen.dart';
import '../debt/debts_screen.dart';
import '../profile/profile_screen.dart';
import '../account/accounts_screen.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../providers/reminder_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reminderControllerProvider.notifier).runStartupCycle();
    });
  }

  final _screens = const [
    BudgetDashboardScreen(),
    AttendanceScreen(),
    DebtsScreen(),
    AccountsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final todayAsync = ref.watch(todayAttendanceProvider);
    final attendanceState = ref.watch(attendanceControllerProvider);
    
    final isCheckedIn = todayAsync.valueOrNull?.checkIn != null;
    final isCheckedOut = todayAsync.valueOrNull?.checkOut != null;

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          if (attendanceState is AsyncLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
      floatingActionButton: (_currentIndex == 1 || _currentIndex == 0)
          ? FloatingActionButton.large(
              heroTag: 'main_biometric_fab',
              onPressed: attendanceState is AsyncLoading 
                  ? null 
                  : () async {
                      final notifier = ref.read(attendanceControllerProvider.notifier);
                      bool success = false;
                      if (!isCheckedIn) {
                        success = await notifier.checkIn();
                        if (mounted && success) UIHelpers.showSuccessSnackBar(context, 'تم تسجيل الحضور بنجاح');
                      } else if (!isCheckedOut) {
                        success = await notifier.checkOut();
                        if (mounted && success) UIHelpers.showSuccessSnackBar(context, 'تم تسجيل الانصراف بنجاح');
                      } else {
                        UIHelpers.showInfoSnackBar(context, 'لقد سجلت حضورك وانصرافك بالفعل اليوم');
                      }
                    },
              backgroundColor: isCheckedOut
                  ? Colors.grey
                  : (isCheckedIn ? Colors.orange.shade700 : Colors.green.shade700),
              child: Icon(
                isCheckedIn ? Icons.logout_rounded : Icons.fingerprint_rounded,
                color: Colors.white,
                size: 36,
              ),
            )
          : null,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
