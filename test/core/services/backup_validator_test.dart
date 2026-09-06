import 'package:attendance_budget_app/core/services/backup/backup_payload.dart';
import 'package:attendance_budget_app/core/services/backup/backup_validator.dart';
import 'package:flutter_test/flutter_test.dart';

BackupPayload _payload(Map<String, List<Map<String, dynamic>>> tables) =>
    BackupPayload(
      version: BackupPayload.currentVersion,
      createdAt: DateTime(2026, 9, 1),
      appVersion: '1.0.0',
      tables: tables,
    );

void main() {
  group('مراجع الجهات', () {
    test('صف يشير إلى جهة غير موجودة يُسقط ويُبلَّغ عنه', () {
      final result = BackupValidator.validate(_payload({
        'companies': [
          {'id': 1, 'name': 'أ'}
        ],
        'attendance': [
          {'id': 10, 'companyId': 1},
          {'id': 11, 'companyId': 99}, // جهة غير موجودة
        ],
      }));

      expect(result.isRestorable, isTrue);
      expect(result.droppedRows, 1);
      expect(result.droppedRowsByTable['attendance'], contains(1));
      expect(result.issues.single.message, contains('سجلات الدوام'));
    });

    test('صف بلا معرّف جهة يُسقط أيضاً', () {
      final result = BackupValidator.validate(_payload({
        'companies': [
          {'id': 1}
        ],
        'debts': [
          {'id': 5}
        ],
      }));
      expect(result.droppedRows, 1);
    });

    test('نسخة سليمة لا تُبلِّغ عن شيء', () {
      final result = BackupValidator.validate(_payload({
        'companies': [
          {'id': 1},
          {'id': 2}
        ],
        'attendance': [
          {'id': 10, 'companyId': 1},
          {'id': 11, 'companyId': 2},
        ],
        'leaves': [
          {'id': 20, 'companyId': 2}
        ],
      }));
      expect(result.isClean, isTrue);
      expect(result.droppedRows, 0);
    });

    test('يوم تقويم عام مقبول، ويوم جهة مفقودة يُسقط', () {
      final result = BackupValidator.validate(_payload({
        'companies': [
          {'id': 1}
        ],
        'calendarDays': [
          {'id': 30, 'companyId': null}, // عام — يسري على الكل
          {'id': 31, 'companyId': 1},
          {'id': 32, 'companyId': 77}, // جهة غير موجودة
        ],
      }));
      expect(result.droppedRows, 1);
      expect(result.droppedRowsByTable['calendarDays'], contains(2));
    });
  });

  group('التكرار', () {
    test('معرّف مكرّر يُسقط الصف اللاحق ويُبلَّغ عنه', () {
      final result = BackupValidator.validate(_payload({
        'companies': [
          {'id': 1},
          {'id': 1}, // مكرّر — الكتابة كانت ستستبدل بصمت
        ],
      }));
      expect(result.droppedRows, 1);
      expect(result.issues.single.message, contains('مكرّرة'));
    });
  });

  group('ما يمنع الاستعادة', () {
    test('نسخة فيها بيانات بلا جهات ترفض', () {
      final result = BackupValidator.validate(_payload({
        'attendance': [
          {'id': 1, 'companyId': 1}
        ],
      }));
      expect(result.isRestorable, isFalse);
      expect(result.issues.any((i) => i.isFatal), isTrue);
    });

    test('نسخة فارغة تماماً مقبولة', () {
      final result = BackupValidator.validate(_payload({}));
      expect(result.isRestorable, isTrue);
    });
  });

  test('الجهة المعروضة المفقودة تُبلَّغ ولا تمنع', () {
    final result = BackupValidator.validate(_payload({
      'companies': [
        {'id': 1}
      ],
      'profiles': [
        {'id': 0, 'activeCompanyId': 42}
      ],
    }));
    expect(result.isRestorable, isTrue);
    expect(result.issues.single.message, contains('الجهة المعروضة'));
    expect(result.droppedRows, 0);
  });
}
