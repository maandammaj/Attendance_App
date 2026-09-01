import 'package:flutter/material.dart';

import '../../../../domain/entities/analytics_report_entity.dart';

/// يعرض تكوين الراتب سطراً بسطر: الأساسي، ثم كل زيادة وخصم، وصولاً للصافي.
///
/// شريط النسبة تحت كل بند يجعل حجم أثره مقروءاً دون قراءة الأرقام.
class SalaryWaterfall extends StatelessWidget {
  const SalaryWaterfall({
    super.key,
    required this.salary,
    required this.currency,
  });

  final SalaryBreakdown salary;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final positive = Colors.green.shade600;
    final negative = theme.colorScheme.error;

    final lines = <(String, double, Color?)>[
      ('الراتب الأساسي', salary.baseSalary, null),
      ('بدل العمل الإضافي', salary.overtimeValue, positive),
      ('خصم العجز والغياب', -salary.deficitValue, negative),
      (
        'بدلات وخصومات ثابتة',
        salary.adjustments,
        salary.adjustments >= 0 ? positive : negative
      ),
    ];

    final afterGross = <(String, double, Color?)>[
      ('سداد ديون', -salary.debtPayments, negative),
      ('مصروفات شخصية', -salary.expenses, negative),
    ];

    // المقياس يعتمد على أكبر بند مطلق حتى تُقارن الأشرطة ببعضها.
    final scale = [
      salary.baseSalary,
      salary.overtimeValue,
      salary.deficitValue,
      salary.adjustments.abs(),
      salary.debtPayments,
      salary.expenses,
    ].fold(1.0, (a, b) => a > b ? a : b);

    return Column(
      children: [
        for (final line in lines) _Line(line: line, scale: scale, currency: currency),
        const SizedBox(height: 10),
        _Total(
          label: 'إجمالي المستحق',
          value: salary.gross,
          currency: currency,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 12),
        for (final line in afterGross)
          _Line(line: line, scale: scale, currency: currency),
        const SizedBox(height: 10),
        _Total(
          label: 'الصافي بعد المصروفات',
          value: salary.net,
          currency: currency,
          color: salary.net >= 0 ? positive : negative,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('أجر الساعة ${salary.hourlyWage.toStringAsFixed(2)} $currency',
                style: theme.textTheme.bodySmall),
            Text(
                'الساعة الإضافية ${salary.overtimeHourlyRate.toStringAsFixed(2)} $currency',
                style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({
    required this.line,
    required this.scale,
    required this.currency,
  });

  final (String, double, Color?) line;
  final double scale;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = line.$3 ?? theme.colorScheme.onSurface;
    final ratio = scale <= 0 ? 0.0 : (line.$2.abs() / scale).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(line.$1, style: theme.textTheme.bodyMedium)),
              Text(
                '${line.$2.toStringAsFixed(0)} $currency',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 5,
              color: color,
              backgroundColor: color.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _Total extends StatelessWidget {
  const _Total({
    required this.label,
    required this.value,
    required this.currency,
    required this.color,
  });

  final String label;
  final double value;
  final String currency;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.titleSmall),
          Text(
            '${value.toStringAsFixed(0)} $currency',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
