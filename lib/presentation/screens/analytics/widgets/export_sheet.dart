import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../../../core/constants/design_tokens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/export/report_export_service.dart';
import '../../../../domain/entities/analytics_report_entity.dart';
import '../../../providers/analytics_provider.dart';

/// خيارات تصدير التقرير الحالي: PDF للطباعة والمشاركة، وCSV لكل مجموعة بيانات.
class ExportSheet extends ConsumerWidget {
  const ExportSheet({super.key, required this.report});

  final AnalyticsReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = context.palette;
    final controller = ref.read(exportControllerProvider.notifier);

    void run(Future<void> Function() action) {
      Navigator.pop(context);
      action();
    }

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text('تصدير تقرير ${report.period.label}',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const Divider(height: 1),
          _Option(
            icon: Icons.picture_as_pdf_rounded,
            color: palette.negative,
            title: 'مشاركة كشف PDF',
            subtitle: 'كشف راتب وسجل حضور كامل بالعربية',
            onTap: () => run(
                () => controller.sharePdf(report, origin: _originOf(context))),
          ),
          _Option(
            icon: Icons.print_rounded,
            color: palette.onSurfaceVariant,
            title: 'طباعة',
            subtitle: 'معاينة الطباعة الأصلية للنظام',
            onTap: () => run(() => controller.printPdf(report)),
          ),
          const Divider(height: 1),
          _Option(
            icon: Icons.table_chart_rounded,
            color: palette.positive,
            title: 'سجل الحضور CSV',
            subtitle: 'يوماً بيوم — يفتح في Excel مباشرة',
            onTap: () => run(
                () => controller.shareCsv(report, CsvDataset.attendance,
                    origin: _originOf(context))),
          ),
          _Option(
            icon: Icons.receipt_long_rounded,
            color: palette.warning,
            title: 'المصروفات والدخل CSV',
            subtitle: 'مجمّعة حسب الفئة',
            onTap: () =>
                run(() => controller.shareCsv(report, CsvDataset.finance,
                    origin: _originOf(context))),
          ),
          _Option(
            icon: Icons.payments_rounded,
            color: Theme.of(context).colorScheme.primary,
            title: 'كشف الراتب CSV',
            subtitle: 'بنود المستحقات والخصومات',
            onTap: () =>
                run(() => controller.shareCsv(report, CsvDataset.salary,
                    origin: _originOf(context))),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      onTap: onTap,
    );
  }
}

/// موضع الورقة بإحداثيات الشاشة — نقطة ارتساء منبثق المشاركة على iPad.
Rect? _originOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}
