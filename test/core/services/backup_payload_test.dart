import 'dart:convert';

import 'package:attendance_budget_app/core/services/backup/backup_payload.dart';
import 'package:flutter_test/flutter_test.dart';

BackupPayload _payload({int version = BackupPayload.currentVersion}) {
  return BackupPayload(
    version: version,
    createdAt: DateTime(2026, 9, 2, 14, 30),
    appVersion: '1.0.0',
    tables: {
      'companies': [
        {'id': 1, 'name': 'Alpha', 'baseMonthlySalary': 3000.0},
      ],
      'attendance': [
        {'id': 10, 'companyId': 1, 'workedHours': 8},
        {'id': 11, 'companyId': 1, 'workedHours': 6},
      ],
    },
  );
}

void main() {
  group('جولة كاملة عبر JSON', () {
    test('البيانات تعود كما هي بعد الترميز وفكّه', () {
      final original = _payload();
      final restored =
          BackupPayload.fromJson(jsonDecode(jsonEncode(original.toJson())));

      expect(restored.version, original.version);
      expect(restored.appVersion, '1.0.0');
      expect(restored.createdAt, original.createdAt);
      expect(restored.tables.keys, containsAll(['companies', 'attendance']));
      expect(restored.tables['attendance'], hasLength(2));
      expect(restored.tables['companies']!.first['name'], 'Alpha');
      // الأرقام العشرية تنجو من الترميز.
      expect(restored.tables['companies']!.first['baseMonthlySalary'], 3000.0);
    });

    test('عدّاد الصفوف يجمع كل الجداول', () {
      expect(_payload().rowCount, 3);
    });
  });

  group('رفض الملفات غير الصالحة', () {
    test('ملف بلا إصدار يُرفض برسالة عربية', () {
      expect(
        () => BackupPayload.fromJson({'tables': <String, dynamic>{}}),
        throwsA(isA<BackupFormatException>().having(
            (e) => e.message, 'message', contains('ليس نسخة احتياطية'))),
      );
    });

    test('نسخة من إصدار أحدث تُرفض بدل استيراد ناقص', () {
      // استيراد صيغة لا يفهمها التطبيق يكتب بيانات مالية ناقصة بصمت.
      expect(
        () => BackupPayload.fromJson(
            _payload(version: BackupPayload.currentVersion + 1).toJson()),
        throwsA(isA<BackupFormatException>()
            .having((e) => e.message, 'message', contains('أحدث'))),
      );
    });

    test('بنية جداول تالفة تُرفض', () {
      expect(
        () => BackupPayload.fromJson({'version': 1, 'tables': 'not a map'}),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('تاريخ غير صالح لا يُسقط الاستيراد', () {
      final restored = BackupPayload.fromJson({
        'version': 1,
        'createdAt': 'ليس تاريخاً',
        'tables': <String, dynamic>{},
      });
      expect(restored.createdAt.year, 2020);
    });
  });
}
