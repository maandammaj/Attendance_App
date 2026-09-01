import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import '../../../../core/utils/biometric_auth.dart';

/// يعرض ما يدعمه الجهاز فعلاً، حتى لا يبقى المستخدم يخمّن سبب فشل التحقق.
class BiometricStatusTile extends StatefulWidget {
  const BiometricStatusTile({super.key});

  @override
  State<BiometricStatusTile> createState() => _BiometricStatusTileState();
}

class _BiometricStatusTileState extends State<BiometricStatusTile> {
  late Future<BiometricCapability> _capability;

  @override
  void initState() {
    super.initState();
    _capability = BiometricAuthService().capability();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return FutureBuilder<BiometricCapability>(
      future: _capability,
      builder: (context, snapshot) {
        final capability = snapshot.data;
        final isReady = capability?.isReady ?? false;
        final color = capability == null
            ? theme.disabledColor
            : (isReady ? palette.positive : palette.warning);

        return Container(
          margin: const EdgeInsetsDirectional.only(top: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.field),
          ),
          child: Row(
            children: [
              Icon(
                isReady ? Icons.verified_user_rounded : Icons.info_outline,
                size: 20,
                color: color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('حالة التحقق على هذا الجهاز',
                        style: theme.textTheme.labelSmall),
                    Text(
                      capability?.label ?? 'جارٍ الفحص…',
                      style: theme.textTheme.bodySmall?.copyWith(color: color),
                    ),
                  ],
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                tooltip: 'إعادة الفحص',
                onPressed: () => setState(() {
                  _capability = BiometricAuthService().capability();
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
