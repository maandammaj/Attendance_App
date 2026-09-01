import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/salary_calculator.dart';
import '../providers/attendance_provider.dart';
import '../providers/profile_provider.dart';

class LiveSalaryCounter extends ConsumerStatefulWidget {
  const LiveSalaryCounter({super.key});

  @override
  ConsumerState<LiveSalaryCounter> createState() => _LiveSalaryCounterState();
}

class _LiveSalaryCounterState extends ConsumerState<LiveSalaryCounter> {
  Timer? _timer;
  double _earned = 0.0;
  String _durationStr = '00:00:00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateLiveStats();
    });
  }

  void _updateLiveStats() {
    final today = ref.read(todayAttendanceProvider).valueOrNull;
    final profile = ref.read(profileProvider).valueOrNull;

    if (today?.checkIn != null && today?.checkOut == null && profile != null) {
      final now = DateTime.now();
      final calc = SalaryCalculator(profile);
      
      // 1. حساب المبلغ المكتسب
      final current = calc.calculateCurrentEarned(
        today!.checkIn!,
        now,
        today.requiredHours,
        today.requiredMinutes,
      );

      // 2. حساب مدة العمل الحالية
      final diff = now.difference(today.checkIn!);
      final h = diff.inHours.toString().padLeft(2, '0');
      final m = (diff.inMinutes % 60).toString().padLeft(2, '0');
      final s = (diff.inSeconds % 60).toString().padLeft(2, '0');

      if (mounted) {
        setState(() {
          _earned = current;
          _durationStr = '$h:$m:$s';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = ref.watch(todayAttendanceProvider).valueOrNull;
    final profile = ref.watch(profileProvider).valueOrNull;

    if (today?.checkIn == null || today?.checkOut != null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.timer_outlined, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Text(
                'مدة العمل الحالية: $_durationStr',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'أرباحك اللحظية',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          Text(
            '${_earned.toStringAsFixed(2)} ${profile?.currency ?? AppConstants.defaultCurrency}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
