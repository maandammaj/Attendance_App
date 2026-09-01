import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../providers/attendance_provider.dart';
import '../../providers/profile_provider.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/live_salary_counter.dart';
import 'manual_attendance_dialog.dart';

class AttendanceScreen extends ConsumerWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayAttendance = ref.watch(todayAttendanceProvider);
    final controllerState = ref.watch(attendanceControllerProvider);
    final now = DateTime.now();
    final stats = ref.watch(attendanceStatsProvider(year: now.year, month: now.month));
    final profile = ref.watch(profileProvider).valueOrNull;

    // استماع للأخطاء في الـ Controller
    ref.listen(attendanceControllerProvider, (prev, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ: ${next.error}'), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الدوام'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_rounded),
            onPressed: () => Navigator.pushNamed(context, '/analytics'),
            tooltip: 'التقارير والتحليلات',
          ),
          IconButton(
            icon: const Icon(Icons.description),
            onPressed: () => Navigator.pushNamed(context, '/monthly-report'),
            tooltip: 'التقرير الشهري',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/attendance-history'),
            tooltip: 'السجل العام',
          ),
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: todayAttendance.when(
                  data: (data) => _buildTodayCard(context, ref, data),
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Center(child: Text('خطأ في تحميل بيانات اليوم: $e')),
                ),
              ),
              SliverToBoxAdapter(
                child: stats.when(
                  data: (s) => _buildStatsGrid(s, profile?.currency ?? 'ر.س'),
                  loading: () => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: LinearProgressIndicator(),
                  ),
                  error: (e, __) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('خطأ في الإحصائيات: $e', style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Text(
                    'إدارة السجلات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                        child: const Icon(Icons.add_circle_outline, color: Colors.blue),
                      ),
                      title: const Text('إضافة سجل حضور يدوياً'),
                      subtitle: const Text('للأيام السابقة أو عند تعطل البصمة'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                      onTap: () => UIHelpers.showModernBottomSheet(
                        context: context,
                        title: 'إضافة حضور يدوي',
                        child: const ManualAttendanceDialog(),
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          if (controllerState is AsyncLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('جاري معالجة الطلب...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTodayCard(BuildContext context, WidgetRef ref, dynamic today) {
    final isCheckedIn = today?.checkIn != null;
    final isCheckedOut = today?.checkOut != null;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (_, __) => Text(
              DateFormat('hh:mm:ss a', 'ar').format(DateTime.now()),
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'ar').format(DateTime.now()),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          const LiveSalaryCounter(),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.fingerprint,
                  label: isCheckedIn ? 'تم الحضور' : 'بصمة دخول',
                  isActive: !isCheckedIn,
                  onPressed: () => _handleAction(context, ref, isCheckIn: true),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  context,
                  icon: Icons.logout,
                  label: isCheckedOut ? 'تم الانصراف' : 'بصمة خروج',
                  isActive: isCheckedIn && !isCheckedOut,
                  onPressed: () => _handleAction(context, ref, isCheckIn: false),
                ),
              ),
            ],
          ),
          if (today != null) ...[
            const SizedBox(height: 24),
            const Divider(color: Colors.white24),
            const SizedBox(height: 12),
            _buildTodaySummary(today),
          ],
        ],
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, WidgetRef ref, {required bool isCheckIn}) async {
    if (isCheckIn) {
      await ref.read(attendanceControllerProvider.notifier).checkIn();
    } else {
      await ref.read(attendanceControllerProvider.notifier).checkOut();
    }
  }

  Widget _buildActionButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required bool isActive,
        required VoidCallback onPressed,
      }) {
    return Material(
      color: isActive ? Colors.white : Colors.white10,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: isActive ? onPressed : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 38,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white30,
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white30,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySummary(dynamic record) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (record.checkIn != null)
          _buildTimeInfo('وقت الدخول', DateHelpers.formatTime(record.checkIn!)),
        if (record.checkOut != null)
          _buildTimeInfo('وقت الخروج', DateHelpers.formatTime(record.checkOut!)),
        if (record.workedHours > 0 || record.workedMinutes > 0)
          _buildTimeInfo(
            'ساعات العمل',
            DateHelpers.formatDuration(
              (record.workedHours * 60) + record.workedMinutes,
            ),
          ),
      ],
    );
  }

  Widget _buildTimeInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(dynamic stats, String currency) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'الانضباط',
                  value: '${stats.actualWorkingDays} / ${stats.expectedWorkingDays} يوم',
                  icon: Icons.check_circle_outline,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'أيام الغياب',
                  value: '${stats.absentDays} أيام',
                  icon: Icons.person_off_outlined,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'ساعات الإضافي',
                  value: '${stats.totalOvertimeHours.toStringAsFixed(1)} س',
                  icon: Icons.add_chart,
                  color: Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatCard(
                  title: 'ساعات العجز',
                  value: '${(stats.totalLatenessHours + stats.totalAbsenceHours).toStringAsFixed(1)} س',
                  icon: Icons.history_toggle_off,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: stats.netExtraValue >= 0 
                  ? Colors.green.withValues(alpha: 0.1) 
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: stats.netExtraValue >= 0 ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('صافي التأثير المالي (هذا الشهر):', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  '${stats.netExtraValue.toStringAsFixed(2)} $currency',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: stats.netExtraValue >= 0 ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
