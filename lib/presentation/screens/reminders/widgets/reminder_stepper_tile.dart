import 'package:flutter/material.dart';

/// حقل رقمي بزرّي زيادة ونقصان — أدق من Slider لقيم مثل "قبل 30 دقيقة"
/// وأسرع من إدخال نصي على الهاتف.
class ReminderStepperTile extends StatelessWidget {
  const ReminderStepperTile({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
    required this.step,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String title;
  final int value;
  final String unit;
  final int step;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 12, top: 4, bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.bodyMedium)),
          IconButton(
            onPressed: value - step >= min ? () => onChanged(value - step) : null,
            icon: const Icon(Icons.remove_circle_outline),
            tooltip: 'إنقاص',
          ),
          SizedBox(
            width: 78,
            child: Text(
              unit.isEmpty ? '$value' : '$value $unit',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall,
            ),
          ),
          IconButton(
            onPressed: value + step <= max ? () => onChanged(value + step) : null,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'زيادة',
          ),
        ],
      ),
    );
  }
}
