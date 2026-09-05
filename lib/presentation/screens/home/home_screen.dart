import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/company_provider.dart';
import '../../providers/reminder_provider.dart';
import '../attendance/widgets/check_in_company_sheet.dart';
import '../../widgets/attendance/attendance_fab.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../account/accounts_screen.dart';
import '../attendance/attendance_screen.dart';
import '../budget/budget_dashboard_screen.dart';
import '../debt/debts_screen.dart';
import '../profile/profile_screen.dart';

/// هيكل التطبيق: خمسة تبويبات مع زر حضور/انصراف عائم.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  static const _screens = [
    BudgetDashboardScreen(),
    AttendanceScreen(),
    DebtsScreen(),
    AccountsScreen(),
    ProfileScreen(),
  ];

  /// تبويب الدوام وحده يعرض زر الحضور.
  ///
  /// كان يظهر على الرئيسية أيضاً فيجلس فوق زرّي "دخل" و"مصروف" ويحجبهما.
  /// لكل سطح إجراء رئيسي واحد: الرئيسية تسجّل حركة مالية، والدوام يسجّل حضوراً.
  static const _fabTabs = {1};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(reminderControllerProvider.notifier).runStartupCycle();
    });
  }

  Future<void> _toggleAttendance() async {
    final today = ref.read(todayAttendanceProvider).value;
    final notifier = ref.read(attendanceControllerProvider.notifier);

    if (today?.isOpen ?? false) {
      _report(await notifier.checkOut());
      return;
    }

    // بأكثر من جهة يُسأل المستخدم صراحةً؛ بجهة واحدة لا سؤال — إضافة خطوة
    // حيث لا غموض احتكاك بلا مقابل.
    final companies = (ref.read(companiesProvider).value ?? const [])
        .where((company) => !company.isArchived)
        .toList();

    int? companyId;
    if (companies.length > 1) {
      final picked = await CheckInCompanySheet.pick(context);
      if (picked == null) return;
      companyId = picked.id;
    }

    _report(await notifier.checkIn(companyId: companyId));
  }

  void _report(AttendanceActionResult result) {

    if (!mounted) return;
    if (result.isSuccess) {
      UIHelpers.showSuccessSnackBar(context, result.message);
    } else {
      UIHelpers.showErrorSnackBar(context, result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayAttendanceProvider).value;
    final isBusy = ref.watch(attendanceControllerProvider) is AsyncLoading;
    final showFab = _fabTabs.contains(_currentIndex);

    return Scaffold(
      extendBody: true,
      body: AnimatedSwitcher(
        duration: AppDurations.medium,
        switchInCurve: AppCurves.emphasized,
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.015),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: KeyedSubtree(
          key: ValueKey(_currentIndex),
          child: _screens[_currentIndex],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AnimatedSlide(
        offset: showFab ? Offset.zero : const Offset(0, 2),
        duration: AppDurations.medium,
        curve: AppCurves.emphasized,
        child: AnimatedOpacity(
          opacity: showFab ? 1 : 0,
          duration: AppDurations.fast,
          child: AttendanceFab(
            isSessionOpen: today?.isOpen ?? false,
            isBusy: isBusy,
            onPressed: _toggleAttendance,
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
