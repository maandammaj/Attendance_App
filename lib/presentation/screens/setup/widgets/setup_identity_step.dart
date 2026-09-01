import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';
import 'setup_step_header.dart';

class SetupIdentityStep extends StatelessWidget {
  const SetupIdentityStep({
    super.key,
    required this.formKey,
    required this.name,
    required this.job,
    required this.company,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController job;
  final TextEditingController company;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          const SetupStepHeader(
            icon: Icons.badge_outlined,
            title: 'من أنت؟',
            subtitle: 'يظهر اسمك ومسمّاك على كشف الراتب المُصدَّر.',
          ),
          TextFormField(
            controller: name,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'الاسم الكامل',
              prefixIcon: Icon(Icons.person_outline_rounded),
            ),
            validator: (value) =>
                (value == null || value.trim().isEmpty) ? 'أدخل اسمك' : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: job,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'المسمّى الوظيفي',
              prefixIcon: Icon(Icons.work_outline_rounded),
            ),
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'أدخل مسمّاك الوظيفي'
                : null,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextFormField(
            controller: company,
            decoration: const InputDecoration(
              labelText: 'جهة العمل (اختياري)',
              prefixIcon: Icon(Icons.business_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
