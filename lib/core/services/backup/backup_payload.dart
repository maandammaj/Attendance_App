/// نسخة كاملة من قاعدة البيانات بصيغة قابلة للنقل.
///
/// الصيغة JSON لا نسخة ملف Isar الثنائي: الملف الثنائي مرتبط بإصدار المحرك
/// ومعماريّة الجهاز، فنسخة من هاتف قد لا تُفتح على آخر. JSON يُقرأ في كل
/// مكان ويحتمل تطوّر المخطط.
class BackupPayload {
  const BackupPayload({
    required this.version,
    required this.createdAt,
    required this.appVersion,
    required this.tables,
  });

  /// إصدار صيغة النسخة. يُرفع عند أي تغيير غير متوافق في البنية.
  static const int currentVersion = 1;

  final int version;
  final DateTime createdAt;
  final String appVersion;

  /// اسم الجدول ← صفوفه.
  final Map<String, List<Map<String, dynamic>>> tables;

  int get rowCount =>
      tables.values.fold(0, (sum, rows) => sum + rows.length);

  Map<String, dynamic> toJson() => {
        'version': version,
        'createdAt': createdAt.toIso8601String(),
        'appVersion': appVersion,
        'tables': tables,
      };

  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final version = json['version'] as int?;
    if (version == null) {
      throw const BackupFormatException('الملف ليس نسخة احتياطية صالحة');
    }
    if (version > currentVersion) {
      throw BackupFormatException(
        'النسخة أُنشئت بإصدار أحدث من التطبيق ($version). حدّث التطبيق أولاً.',
      );
    }

    final rawTables = json['tables'];
    if (rawTables is! Map) {
      throw const BackupFormatException('بنية النسخة تالفة');
    }

    return BackupPayload(
      version: version,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime(2020),
      appVersion: json['appVersion'] as String? ?? '',
      tables: {
        for (final entry in rawTables.entries)
          entry.key as String: [
            for (final row in (entry.value as List))
              Map<String, dynamic>.from(row as Map),
          ],
      },
    );
  }
}

/// ملف ليس نسخة صالحة — رسالة عربية جاهزة للعرض.
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => message;
}
