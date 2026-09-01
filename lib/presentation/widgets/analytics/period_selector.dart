import 'package:flutter/material.dart';

import '../../../domain/entities/analytics_report_entity.dart';

/// يختار الفترة المعروضة: أسبوع/شهر/سنة، أو مدى مخصص عبر منتقي التواريخ.
class PeriodSelector extends StatelessWidget {
  const PeriodSelector({
    super.key,
    required this.period,
    required this.onChanged,
  });

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final anchor = period.to;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'الفترة السابقة',
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onChanged(_shift(-1)),
            ),
            Expanded(
              child: Text(
                period.label,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'الفترة التالية',
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onChanged(_shift(1)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _chip(context, 'أسبوع', () => ReportPeriod.week(anchor)),
              const SizedBox(width: 8),
              _chip(context, 'شهر', () => ReportPeriod.month(anchor)),
              const SizedBox(width: 8),
              _chip(context, 'سنة', () => ReportPeriod.year(anchor)),
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(Icons.date_range_rounded, size: 16),
                label: const Text('مدى مخصص'),
                onPressed: () => _pickRange(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(
      BuildContext context, String label, ReportPeriod Function() build) {
    final candidate = build();
    final isSelected = candidate.label == period.label;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onChanged(candidate),
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
      initialDateRange: DateTimeRange(start: period.from, end: period.to),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      onChanged(ReportPeriod.custom(picked.start, picked.end));
    }
  }

  /// ينقل الفترة خطوة للأمام أو للخلف بنفس نوعها.
  ReportPeriod _shift(int direction) {
    final span = period.to.difference(period.from).inDays;

    if (span >= 360) {
      return ReportPeriod.year(DateTime(period.from.year + direction, 1, 1));
    }
    if (span >= 27) {
      return ReportPeriod.month(
          DateTime(period.from.year, period.from.month + direction, 1));
    }
    if (span == 6) {
      return ReportPeriod.week(
          period.from.add(Duration(days: 7 * direction)));
    }
    // مدى مخصص: يُزاح بطوله كاملاً.
    final shift = Duration(days: (span + 1) * direction);
    return ReportPeriod.custom(period.from.add(shift), period.to.add(shift));
  }
}
