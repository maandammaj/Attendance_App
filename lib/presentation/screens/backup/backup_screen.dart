import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/design_tokens.dart';
import '../../../core/services/backup/drive_sync_service.dart';
import '../../../core/utils/date_helpers.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../providers/backup_provider.dart';
import '../../widgets/common/section_header.dart';

/// النسخ الاحتياطي والمزامنة مع Google Drive.
///
/// التطبيق بلا خادم، فحذفه يمحو كل شيء. هذه الشاشة هي الطريق الوحيد
/// لنقل البيانات إلى جهاز آخر أو استعادتها بعد فقد الهاتف.
class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final status = ref.watch(driveStatusProvider);
    final isBusy = ref.watch(backupControllerProvider) is AsyncLoading;

    ref.listen(backupControllerProvider, (_, next) {
      if (next is AsyncError) {
        UIHelpers.showErrorSnackBar(context, '${next.error}');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('النسخ الاحتياطي')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(AppSpacing.screen),
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: palette.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline,
                        size: AppIconSize.md, color: palette.info),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        'بياناتك محفوظة على جهازك وحده. حذف التطبيق يمحوها '
                        'نهائياً — النسخة على Drive هي طريق استعادتها.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const SectionHeader(title: 'Google Drive'),
              status.when(
                data: (data) => _DriveCard(status: data, isBusy: isBusy),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
                error: (error, _) => _SetupNeeded(message: '$error'),
              ),
            ],
          ),
          if (isBusy)
            ColoredBox(
              color: palette.scrim,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _DriveCard extends ConsumerWidget {
  const _DriveCard({required this.status, required this.isBusy});

  final DriveStatus status;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = context.palette;
    final controller = ref.read(backupControllerProvider.notifier);

    if (!status.isSignedIn) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('لم تربط حساباً بعد', style: theme.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'تُحفظ النسخة في مجلد خاص بالتطبيق داخل حسابك — لا يظهر في '
                'ملفاتك ولا يستطيع أي تطبيق آخر قراءته.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: palette.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: isBusy
                    ? null
                    : () async {
                        final email = await controller.signIn();
                        if (email != null && context.mounted) {
                          UIHelpers.showSuccessSnackBar(
                              context, 'رُبط الحساب $email');
                        }
                      },
                icon: const Icon(Icons.cloud_outlined),
                label: const Text('ربط حساب Google'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: palette.primary.withValues(alpha: 0.12),
              child: Icon(Icons.account_circle_outlined,
                  color: palette.primary),
            ),
            title: Text(status.email!, style: theme.textTheme.bodyLarge),
            subtitle: Text(
              status.hasBackup
                  ? 'آخر نسخة ${DateHelpers.formatShortDate(status.lastBackupAt!)}'
                      ' · ${_size(status.lastBackupSize)}'
                  : 'لا نسخة محفوظة بعد',
              style: theme.textTheme.bodySmall,
            ),
            trailing: TextButton(
              onPressed: isBusy ? null : controller.signOut,
              child: const Text('فصل'),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FilledButton.icon(
          onPressed: isBusy
              ? null
              : () async {
                  final at = await controller.upload();
                  if (at != null && context.mounted) {
                    UIHelpers.showSuccessSnackBar(context, 'رُفعت النسخة');
                  }
                },
          icon: const Icon(Icons.cloud_upload_outlined),
          label: const Text('رفع نسخة الآن'),
        ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: isBusy || !status.hasBackup
              ? null
              : () => _confirmRestore(context, ref),
          icon: const Icon(Icons.cloud_download_outlined),
          label: const Text('استعادة من Drive'),
        ),
      ],
    );
  }

  Future<void> _confirmRestore(BuildContext context, WidgetRef ref) async {
    // الاستعادة تستبدل كل شيء — تأكيد إلزامي قبل أي إجراء لا رجعة فيه.
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('استعادة النسخة'),
        content: const Text(
          'سيُستبدل كل ما على هذا الجهاز ببيانات النسخة: الجهات والدوام '
          'والمعاملات والديون. لا يمكن التراجع.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error),
            child: const Text('استبدال'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final rows = await ref.read(backupControllerProvider.notifier).restore();
    if (rows != null && context.mounted) {
      UIHelpers.showSuccessSnackBar(context, 'استُعيد $rows سجلاً');
    }
  }

  static String _size(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes بايت';
    return '${(bytes / 1024).toStringAsFixed(0)} ك.ب';
  }
}

/// يظهر حين يفشل Drive بسبب إعداد OAuth الناقص — الخطأ الأرجح.
class _SetupNeeded extends StatelessWidget {
  const _SetupNeeded({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: palette.warning),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text('المزامنة غير مُعدّة',
                      style: theme.textTheme.titleMedium),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'تحتاج المزامنة مفاتيح OAuth من Google Cloud. الخطوات في '
              'docs/google-drive-setup.md',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: palette.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(message, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}
