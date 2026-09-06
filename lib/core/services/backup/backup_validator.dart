import 'backup_payload.dart';

/// خلل وُجد في نسخة احتياطية.
class BackupIssue {
  const BackupIssue({
    required this.message,
    required this.affectedRows,
    this.isFatal = false,
  });

  /// نصّ عربي جاهز للعرض.
  final String message;

  /// عدد الصفوف التي يمسّها.
  final int affectedRows;

  /// خلل لا يمكن إصلاحه بإسقاط صفوف — تُرفض الاستعادة معه.
  final bool isFatal;
}

/// نتيجة فحص نسخة قبل استعادتها.
class BackupValidation {
  const BackupValidation({
    required this.issues,
    required this.droppedRowsByTable,
  });

  final List<BackupIssue> issues;

  /// صفوف يجب تخطّيها عند الاستعادة، مفهرسة باسم الجدول ثم موقع الصف.
  final Map<String, Set<int>> droppedRowsByTable;

  bool get isRestorable => !issues.any((i) => i.isFatal);

  int get droppedRows =>
      droppedRowsByTable.values.fold(0, (sum, s) => sum + s.length);

  bool get isClean => issues.isEmpty;
}

/// يفحص نسخة قبل الكتابة، لا بعدها.
///
/// الخطر الذي يعالجه ليس ملفاً تالفاً يرفضه المحلّل — ذاك يُكتشف وحده — بل
/// ملفاً سليم البنية يحمل مراجع معطوبة: سجل دوام يشير إلى جهة غير موجودة
/// يُكتب بنجاح ثم لا يظهر في أي استعلام مُرشَّح بالجهة. بيانات موجودة لا
/// يمكن رؤيتها، وهي أسوأ من بيانات مفقودة لأن المستخدم لا يعرف أنها ضاعت.
class BackupValidator {
  const BackupValidator._();

  /// الجداول المرتبطة بجهة عمل، واسم الحقل الرابط.
  static const _scopedTables = <String, String>{
    'attendance': 'companyId',
    'transactions': 'companyId',
    'debts': 'companyId',
    'accounts': 'companyId',
    'budgetLimits': 'companyId',
    'leaves': 'companyId',
  };

  static BackupValidation validate(BackupPayload payload) {
    final issues = <BackupIssue>[];
    final dropped = <String, Set<int>>{};

    final companies = payload.tables['companies'] ?? const [];
    final companyIds = <int>{
      for (final row in companies)
        if (row['id'] is int) row['id'] as int,
    };

    if (companies.isEmpty && payload.rowCount > 0) {
      issues.add(const BackupIssue(
        message: 'النسخة بلا جهات عمل، ولا يمكن نسبة بياناتها إلى شيء',
        affectedRows: 0,
        isFatal: true,
      ));
    }

    // ── مراجع معطوبة إلى جهات غير موجودة ──────────────────────────
    for (final entry in _scopedTables.entries) {
      final rows = payload.tables[entry.key] ?? const [];
      final orphans = <int>{};

      for (var i = 0; i < rows.length; i++) {
        final companyId = rows[i][entry.value];
        if (companyId is! int || !companyIds.contains(companyId)) {
          orphans.add(i);
        }
      }

      if (orphans.isNotEmpty) {
        dropped.putIfAbsent(entry.key, () => {}).addAll(orphans);
        issues.add(BackupIssue(
          message:
              'صفوف في «${_tableLabel(entry.key)}» تشير إلى جهة عمل غير موجودة',
          affectedRows: orphans.length,
        ));
      }
    }

    // ── تقويم عام مسموح، وتقويم جهة يجب أن تكون موجودة ────────────
    final calendar = payload.tables['calendarDays'] ?? const [];
    final calendarOrphans = <int>{};
    for (var i = 0; i < calendar.length; i++) {
      final companyId = calendar[i]['companyId'];
      if (companyId != null &&
          (companyId is! int || !companyIds.contains(companyId))) {
        calendarOrphans.add(i);
      }
    }
    if (calendarOrphans.isNotEmpty) {
      dropped.putIfAbsent('calendarDays', () => {}).addAll(calendarOrphans);
      issues.add(BackupIssue(
        message: 'أيام في «تقويم العمل» تشير إلى جهة عمل غير موجودة',
        affectedRows: calendarOrphans.length,
      ));
    }

    // ── معرّفات مكرّرة داخل الجدول الواحد ──────────────────────────
    for (final table in payload.tables.keys) {
      final rows = payload.tables[table]!;
      final seen = <int>{};
      final duplicates = <int>{};

      for (var i = 0; i < rows.length; i++) {
        final id = rows[i]['id'];
        if (id is! int) continue;
        if (!seen.add(id)) duplicates.add(i);
      }

      if (duplicates.isNotEmpty) {
        dropped.putIfAbsent(table, () => {}).addAll(duplicates);
        issues.add(BackupIssue(
          message: 'صفوف مكرّرة المعرّف في «${_tableLabel(table)}» — '
              'الكتابة كانت ستُبقي الأخير وتُسقط ما قبله بصمت',
          affectedRows: duplicates.length,
        ));
      }
    }

    // ── الجهة المعروضة تشير إلى جهة موجودة ────────────────────────
    final profiles = payload.tables['profiles'] ?? const [];
    for (final profile in profiles) {
      final activeId = profile['activeCompanyId'];
      if (activeId is int && !companyIds.contains(activeId)) {
        issues.add(const BackupIssue(
          message: 'الجهة المعروضة في النسخة غير موجودة — '
              'سيُفتح التطبيق على أول جهة متاحة',
          affectedRows: 1,
        ));
      }
    }

    return BackupValidation(issues: issues, droppedRowsByTable: dropped);
  }

  static String _tableLabel(String table) => switch (table) {
        'profiles' => 'الملف الشخصي',
        'companies' => 'جهات العمل',
        'attendance' => 'سجلات الدوام',
        'transactions' => 'الحركات المالية',
        'debts' => 'الديون',
        'accounts' => 'الحسابات',
        'categories' => 'التصنيفات',
        'budgetLimits' => 'حدود الميزانية',
        'reminderSettings' => 'إعدادات التذكير',
        'calendarDays' => 'تقويم العمل',
        'leaves' => 'الإجازات',
        _ => table,
      };
}

/// حصيلة استعادة: ما كُتب، وما أُسقط، ولماذا.
///
/// تُعاد بدل رقم مجرّد لأن «استُعيد 500 صف» لا يقول إن عشرين منها أُسقطت
/// لأنها تشير إلى جهة محذوفة — والمستخدم يستحق أن يعرف.
class RestoreReport {
  const RestoreReport({
    required this.rowsRestored,
    required this.rowsDropped,
    required this.rowsCounted,
    required this.expectedRows,
    required this.issues,
  });

  final int rowsRestored;
  final int rowsDropped;

  /// ما وجدته القاعدة فعلاً بعد الكتابة.
  final int rowsCounted;

  final int expectedRows;
  final List<BackupIssue> issues;

  /// المكتوب يطابق المتوقَّع — تحقّقٌ بعديّ لا يكفي نجاح المعاملة عنه.
  bool get isVerified => rowsCounted == expectedRows;

  bool get isClean => issues.isEmpty && isVerified;
}
