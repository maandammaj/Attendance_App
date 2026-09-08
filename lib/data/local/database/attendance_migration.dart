import 'dart:developer' as developer;

import 'package:isar_community/isar.dart';

import '../../models/attendance_model.dart';

/// يحوّل السجلات المكتوبة قبل دعم الجلسات المتعددة إلى الشكل الجديد.
///
/// السجل القديم يحمل `checkIn`/`checkOut` مباشرةً وقائمة `sessions` فارغة.
/// بدون هذا الترحيل يظهر لصاحب التطبيق أن أيامه السابقة بلا جلسات، رغم أن
/// ساعاتها وقيمها المالية ما تزال مخزّنة.
class AttendanceMigration {
  AttendanceMigration._();

  static Future<int> run(Isar isar) async {
    final legacy = await isar.attendanceModels
        .filter()
        .checkInIsNotNull()
        .findAll();

    final pending = legacy.where((record) => record.sessions.isEmpty).toList();
    if (pending.isEmpty) return 0;

    for (final record in pending) {
      record.sessions = [
        WorkSession()
          ..checkIn = record.checkIn
          ..checkOut = record.checkOut
          // السجل القديم يحمل علماً واحداً لليوم كله، ننسبه للجلسة الوحيدة.
          ..isBiometricVerified = record.isBiometricVerified,
      ];
      record.isOpen = record.checkOut == null;
      record.sessionCount = record.checkOut == null ? 0 : 1;
      record.totalPresenceMinutes = record.checkOut == null
          ? 0
          : record.checkOut!.difference(record.checkIn!).inMinutes;
    }

    await isar.writeTxn(() async {
      await isar.attendanceModels.putAll(pending);
    });

    developer.log(
      'رُحّل ${pending.length} سجل حضور إلى نظام الجلسات',
      name: 'db.migration',
      level: 500,
    );
    return pending.length;
  }
}
