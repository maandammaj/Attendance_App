import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../providers/reminder_provider.dart';

/// يشرح لماذا لا تصل التنبيهات، ويقدّم الإصلاح في مكانه.
///
/// ثلاثة أسباب تمنع الوصول ولا يظهر أيٌّ منها كخطأ: الإذن مرفوض، الجدولة
/// الدقيقة ممنوعة، أو النظام يقتل التطبيق. الأول والثاني يُصلحان من هنا،
/// والثالث يحتاج استثناء التطبيق من توفير البطارية.
class DeliveryHealthCard extends ConsumerWidget {
  const DeliveryHealthCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final diagnostics = ref.watch(notificationDiagnosticsProvider).value;
    if (diagnostics == null) return const SizedBox.shrink();

    final controller = ref.read(reminderControllerProvider.notifier);
    final isHealthy = diagnostics.isHealthy;
    final color = isHealthy ? palette.positive : palette.warning;

    return Card(
      margin: const EdgeInsetsDirectional.only(bottom: AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: BorderSide(color: color.withValues(alpha: 0.35)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy
                      ? Icons.notifications_active_outlined
                      : Icons.notifications_off_outlined,
                  color: color,
                  size: AppIconSize.lg,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    isHealthy ? 'التنبيهات تعمل' : 'التنبيهات لن تصل',
                    style: theme.textTheme.titleMedium?.copyWith(color: color),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _Check(
              label: 'إذن الإشعارات',
              ok: diagnostics.permissionGranted,
              hint: 'من إعدادات النظام › التطبيقات › الإشعارات',
            ),
            _Check(
              label: 'الجدولة في وقت دقيق',
              ok: diagnostics.exactAlarmsAllowed,
              hint: 'بدونها تصل التذكيرات متأخرة أو لا تصل',
              onFix: diagnostics.exactAlarmsAllowed
                  ? null
                  : controller.grantExactAlarms,
            ),
            const Divider(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${diagnostics.pendingCount} تنبيه مجدول',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: palette.onSurfaceVariant),
                  ),
                ),
                TextButton.icon(
                  onPressed: controller.sendTest,
                  icon: const Icon(Icons.send_rounded, size: AppIconSize.sm),
                  label: const Text('جرّب الآن'),
                ),
              ],
            ),
            if (!isHealthy) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'إن ظلّت لا تصل بعد ذلك، فالنظام يوقف التطبيق في الخلفية — '
                'استثنِه من توفير البطارية من إعدادات الجهاز.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: palette.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Check extends StatelessWidget {
  const _Check({
    required this.label,
    required this.ok,
    required this.hint,
    this.onFix,
  });

  final String label;
  final bool ok;
  final String hint;
  final VoidCallback? onFix;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: AppIconSize.md,
            color: ok ? palette.positive : palette.negative,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                if (!ok)
                  Text(hint,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: palette.onSurfaceVariant)),
              ],
            ),
          ),
          if (onFix != null)
            TextButton(onPressed: onFix, child: const Text('السماح')),
        ],
      ),
    );
  }
}
