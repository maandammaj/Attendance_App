import 'package:flutter/material.dart';

/// غلاف بطاقة لجلسات اليوم — يفصل الإطار عن محتوى الخط الزمني.
class TodaySessionsCard extends StatelessWidget {
  const TodaySessionsCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 8),
        child: child,
      ),
    );
  }
}
