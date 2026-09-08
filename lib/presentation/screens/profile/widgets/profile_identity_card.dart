import 'package:flutter/material.dart';

import '../../../../core/constants/design_tokens.dart';

/// رأس الملف الشخصي: من أنت، وأين تعمل.
///
/// التبويب كان يفتح على حقل نص مباشرةً — شاشة «الملف الشخصي» بلا وجه ولا
/// اسم، فتقرأ كنموذج إعدادات لا كملفّ صاحبه.
///
/// سطح داكن بتدرّج العلامة كبطاقة الراتب: التبويبان هما وحدهما ما يحمل
/// هويةً لا رقماً، وبقية البطاقات أسطح محايدة.
class ProfileIdentityCard extends StatelessWidget {
  const ProfileIdentityCard({
    super.key,
    required this.fullName,
    required this.jobTitle,
    required this.companyName,
  });

  final String fullName;
  final String jobTitle;
  final String? companyName;

  /// أول حرفين من الاسم — بديل الصورة التي لا يملكها التطبيق أصلاً.
  String get _initials {
    final parts =
        fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '؟';
    if (parts.length == 1) return parts.first.characters.first;
    return '${parts.first.characters.first}${parts.elementAt(1).characters.first}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = context.palette;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        gradient: const LinearGradient(
          colors: AppPalette.brandGradient,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        boxShadow: AppElevation.raised(palette),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
            ),
            child: Text(
              _initials,
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: palette.accentOnBrand),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  jobTitle,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.78)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (companyName != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business_outlined,
                        size: AppIconSize.sm,
                        color: Colors.white.withValues(alpha: 0.62),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Flexible(
                        child: Text(
                          companyName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.62)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
