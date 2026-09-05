import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../data/local/database/isar_database.dart';
import '../../../data/models/account_model.dart';
import '../../../data/models/attendance_model.dart';
import '../../../data/models/budget_limit_model.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/company_model.dart';
import '../../../data/models/debt_model.dart';
import '../../../data/models/profile_model.dart';
import '../../../data/models/reminder_settings_model.dart';
import '../../../data/models/transaction_model.dart';
import '../../constants/app_constants.dart';
import 'backup_payload.dart';

/// يحوّل قاعدة البيانات إلى JSON والعكس.
///
/// كل جدول يُسلسَل يدوياً بدل الاعتماد على توليد آلي: الترتيب صريح، وإضافة
/// حقل تعني تحرير مكان واحد لكل اتجاه — وهو ما يجعل نسيان حقل ظاهراً في
/// المراجعة بدل أن يضيع صامتاً.
class BackupService {
  const BackupService();

  static const _profiles = 'profiles';
  static const _companies = 'companies';
  static const _attendance = 'attendance';
  static const _transactions = 'transactions';
  static const _debts = 'debts';
  static const _accounts = 'accounts';
  static const _categories = 'categories';
  static const _budgetLimits = 'budgetLimits';
  static const _reminderSettings = 'reminderSettings';

  // سجل التنبيهات لا يُنسخ عمداً: مشتق وقابل لإعادة التوليد، وحجمه ينمو
  // بلا حد فيضخّم النسخة دون فائدة.

  Future<BackupPayload> export() async {
    final isar = await IsarDatabase.instance;

    return BackupPayload(
      version: BackupPayload.currentVersion,
      createdAt: DateTime.now(),
      appVersion: AppConstants.appVersion,
      tables: {
        _profiles: (await isar.profileModels.where().findAll())
            .map(_profileToJson)
            .toList(),
        _companies: (await isar.companyModels.where().findAll())
            .map(_companyToJson)
            .toList(),
        _attendance: (await isar.attendanceModels.where().findAll())
            .map(_attendanceToJson)
            .toList(),
        _transactions: (await isar.transactionModels.where().findAll())
            .map(_transactionToJson)
            .toList(),
        _debts:
            (await isar.debtModels.where().findAll()).map(_debtToJson).toList(),
        _accounts: (await isar.accountModels.where().findAll())
            .map(_accountToJson)
            .toList(),
        _categories: (await isar.categoryModels.where().findAll())
            .map(_categoryToJson)
            .toList(),
        _budgetLimits: (await isar.budgetLimitModels.where().findAll())
            .map(_budgetLimitToJson)
            .toList(),
        _reminderSettings: (await isar.reminderSettingsModels.where().findAll())
            .map(_reminderSettingsToJson)
            .toList(),
      },
    );
  }

  Future<String> exportJson() async =>
      const JsonEncoder.withIndent('  ').convert((await export()).toJson());

  /// يستبدل محتوى القاعدة بالكامل بمحتوى النسخة.
  ///
  /// الاستبدال لا الدمج: دمج صفوف بمعرّفات متضاربة من جهازين ينتج بيانات
  /// مالية خاطئة بصمت، والاستبدال يُبقي الحالة مفهومة. العملية داخل معاملة
  /// واحدة فإما أن تكتمل أو لا يتغيّر شيء.
  Future<int> restore(BackupPayload payload) async {
    final isar = await IsarDatabase.instance;
    var restored = 0;

    await isar.writeTxn(() async {
      await isar.profileModels.clear();
      await isar.companyModels.clear();
      await isar.attendanceModels.clear();
      await isar.transactionModels.clear();
      await isar.debtModels.clear();
      await isar.accountModels.clear();
      await isar.categoryModels.clear();
      await isar.budgetLimitModels.clear();
      await isar.reminderSettingsModels.clear();

      restored += await _put(payload, _profiles,
          (r) => isar.profileModels.put(_profileFromJson(r)));
      restored += await _put(payload, _companies,
          (r) => isar.companyModels.put(_companyFromJson(r)));
      restored += await _put(payload, _attendance,
          (r) => isar.attendanceModels.put(_attendanceFromJson(r)));
      restored += await _put(payload, _transactions,
          (r) => isar.transactionModels.put(_transactionFromJson(r)));
      restored += await _put(
          payload, _debts, (r) => isar.debtModels.put(_debtFromJson(r)));
      restored += await _put(payload, _accounts,
          (r) => isar.accountModels.put(_accountFromJson(r)));
      restored += await _put(payload, _categories,
          (r) => isar.categoryModels.put(_categoryFromJson(r)));
      restored += await _put(payload, _budgetLimits,
          (r) => isar.budgetLimitModels.put(_budgetLimitFromJson(r)));
      restored += await _put(payload, _reminderSettings,
          (r) => isar.reminderSettingsModels.put(_reminderSettingsFromJson(r)));
    });

    return restored;
  }

  Future<int> restoreJson(String json) async {
    try {
      return await restore(
          BackupPayload.fromJson(jsonDecode(json) as Map<String, dynamic>));
    } on FormatException {
      throw const BackupFormatException('الملف ليس JSON صالحاً');
    }
  }

  static Future<int> _put(
    BackupPayload payload,
    String table,
    Future<void> Function(Map<String, dynamic> row) write,
  ) async {
    final rows = payload.tables[table] ?? const [];
    for (final row in rows) {
      await write(row);
    }
    return rows.length;
  }

  // ── التسلسل ─────────────────────────────────────────────────────

  static String? _iso(DateTime? value) => value?.toIso8601String();
  static DateTime? _date(Object? value) =>
      value == null ? null : DateTime.tryParse(value as String);
  static DateTime _dateOr(Object? value) => _date(value) ?? DateTime(2020);

  static Map<String, dynamic> _workDayToJson(WorkDayConfig d) => {
        'dayOfWeek': d.dayOfWeek,
        'isWorkingDay': d.isWorkingDay,
        'requiredHours': d.requiredHours,
        'requiredMinutes': d.requiredMinutes,
        'isHoliday': d.isHoliday,
        'startTime': d.startTime,
        'endTime': d.endTime,
        'isCrossDay': d.isCrossDay,
      };

  static WorkDayConfig _workDayFromJson(Map<String, dynamic> j) =>
      WorkDayConfig()
        ..dayOfWeek = j['dayOfWeek'] as int? ?? 0
        ..isWorkingDay = j['isWorkingDay'] as bool? ?? false
        ..requiredHours = j['requiredHours'] as int? ?? 0
        ..requiredMinutes = j['requiredMinutes'] as int? ?? 0
        ..isHoliday = j['isHoliday'] as bool? ?? false
        ..startTime = j['startTime'] as String?
        ..endTime = j['endTime'] as String?
        ..isCrossDay = j['isCrossDay'] as bool? ?? false;

  static Map<String, dynamic> _adjustmentToJson(SalaryAdjustment a) => {
        'title': a.title,
        'amount': a.amount,
        'isAddition': a.isAddition,
      };

  static SalaryAdjustment _adjustmentFromJson(Map<String, dynamic> j) =>
      SalaryAdjustment()
        ..title = j['title'] as String? ?? ''
        ..amount = (j['amount'] as num?)?.toDouble() ?? 0
        ..isAddition = j['isAddition'] as bool? ?? true;

  static Map<String, dynamic> _profileToJson(ProfileModel m) => {
        'id': m.id,
        'fullName': m.fullName,
        'activeCompanyId': m.activeCompanyId,
        'currency': m.currency,
        'updatedAt': _iso(m.updatedAt),
      };

  static ProfileModel _profileFromJson(Map<String, dynamic> j) => ProfileModel()
    ..id = j['id'] as int? ?? 0
    ..fullName = j['fullName'] as String? ?? 'المستخدم'
    ..activeCompanyId = j['activeCompanyId'] as int?
    ..currency = j['currency'] as String?
    ..updatedAt = _dateOr(j['updatedAt']);

  static Map<String, dynamic> _companyToJson(CompanyModel m) => {
        'id': m.id,
        'name': m.name,
        'jobTitle': m.jobTitle,
        'baseMonthlySalary': m.baseMonthlySalary,
        'hourlyRate': m.hourlyRate,
        'overtimeRate': m.overtimeRate,
        'workSchedule': m.workSchedule.map(_workDayToJson).toList(),
        'adjustments': m.adjustments.map(_adjustmentToJson).toList(),
        'currency': m.currency,
        'employmentStartDate': _iso(m.employmentStartDate),
        'colorIndex': m.colorIndex,
        'isArchived': m.isArchived,
        'createdAt': _iso(m.createdAt),
        'updatedAt': _iso(m.updatedAt),
      };

  static CompanyModel _companyFromJson(Map<String, dynamic> j) => CompanyModel()
    ..id = j['id'] as int? ?? Isar.autoIncrement
    ..name = j['name'] as String? ?? 'جهة العمل'
    ..jobTitle = j['jobTitle'] as String? ?? ''
    ..baseMonthlySalary = (j['baseMonthlySalary'] as num?)?.toDouble() ?? 0
    ..hourlyRate = (j['hourlyRate'] as num?)?.toDouble() ?? 0
    ..overtimeRate = (j['overtimeRate'] as num?)?.toDouble() ?? 1.5
    ..workSchedule = [
      for (final d in (j['workSchedule'] as List? ?? []))
        _workDayFromJson(Map<String, dynamic>.from(d as Map)),
    ]
    ..adjustments = [
      for (final a in (j['adjustments'] as List? ?? []))
        _adjustmentFromJson(Map<String, dynamic>.from(a as Map)),
    ]
    ..currency = j['currency'] as String?
    ..employmentStartDate = _date(j['employmentStartDate'])
    ..colorIndex = j['colorIndex'] as int? ?? 0
    ..isArchived = j['isArchived'] as bool? ?? false
    ..createdAt = _dateOr(j['createdAt'])
    ..updatedAt = _dateOr(j['updatedAt']);

  static Map<String, dynamic> _sessionToJson(WorkSession s) => {
        'checkIn': _iso(s.checkIn),
        'checkOut': _iso(s.checkOut),
        'isBiometricVerified': s.isBiometricVerified,
        'note': s.note,
      };

  static WorkSession _sessionFromJson(Map<String, dynamic> j) => WorkSession()
    ..checkIn = _date(j['checkIn'])
    ..checkOut = _date(j['checkOut'])
    ..isBiometricVerified = j['isBiometricVerified'] as bool? ?? false
    ..note = j['note'] as String?;

  static Map<String, dynamic> _attendanceToJson(AttendanceModel m) => {
        'id': m.id,
        'companyId': m.companyId,
        'date': _iso(m.date),
        'sessions': m.sessions.map(_sessionToJson).toList(),
        'isOpen': m.isOpen,
        'checkIn': _iso(m.checkIn),
        'checkOut': _iso(m.checkOut),
        'totalPresenceMinutes': m.totalPresenceMinutes,
        'sessionCount': m.sessionCount,
        'workedHours': m.workedHours,
        'workedMinutes': m.workedMinutes,
        'requiredHours': m.requiredHours,
        'requiredMinutes': m.requiredMinutes,
        'overtimeHours': m.overtimeHours,
        'overtimeMinutes': m.overtimeMinutes,
        'overtimeValue': m.overtimeValue,
        'deficitHours': m.deficitHours,
        'deficitMinutes': m.deficitMinutes,
        'deficitValue': m.deficitValue,
        'notes': m.notes,
        'isBiometricVerified': m.isBiometricVerified,
        'dayType': m.dayType.name,
        'isAbsent': m.isAbsent,
      };

  static AttendanceModel _attendanceFromJson(Map<String, dynamic> j) =>
      AttendanceModel()
        ..id = j['id'] as int? ?? Isar.autoIncrement
        ..companyId = j['companyId'] as int? ?? 0
        ..date = _dateOr(j['date'])
        ..sessions = [
          for (final s in (j['sessions'] as List? ?? []))
            _sessionFromJson(Map<String, dynamic>.from(s as Map)),
        ]
        ..isOpen = j['isOpen'] as bool? ?? false
        ..checkIn = _date(j['checkIn'])
        ..checkOut = _date(j['checkOut'])
        ..totalPresenceMinutes = j['totalPresenceMinutes'] as int? ?? 0
        ..sessionCount = j['sessionCount'] as int? ?? 0
        ..workedHours = j['workedHours'] as int? ?? 0
        ..workedMinutes = j['workedMinutes'] as int? ?? 0
        ..requiredHours = j['requiredHours'] as int? ?? 0
        ..requiredMinutes = j['requiredMinutes'] as int? ?? 0
        ..overtimeHours = j['overtimeHours'] as int? ?? 0
        ..overtimeMinutes = j['overtimeMinutes'] as int? ?? 0
        ..overtimeValue = (j['overtimeValue'] as num?)?.toDouble() ?? 0
        ..deficitHours = j['deficitHours'] as int? ?? 0
        ..deficitMinutes = j['deficitMinutes'] as int? ?? 0
        ..deficitValue = (j['deficitValue'] as num?)?.toDouble() ?? 0
        ..notes = j['notes'] as String?
        ..isBiometricVerified = j['isBiometricVerified'] as bool? ?? false
        ..dayType = DayType.values.firstWhere(
          (v) => v.name == j['dayType'],
          orElse: () => DayType.regular,
        )
        ..isAbsent = j['isAbsent'] as bool? ?? false;

  static Map<String, dynamic> _transactionToJson(TransactionModel m) => {
        'id': m.id,
        'companyId': m.companyId,
        'amount': m.amount,
        'date': _iso(m.date),
        'categoryName': m.categoryName,
        'categoryId': m.categoryId,
        'accountId': m.accountId,
        'note': m.note,
        'type': m.type.name,
        'isRecurring': m.isRecurring,
        'recurringDay': m.recurringDay,
      };

  static TransactionModel _transactionFromJson(Map<String, dynamic> j) =>
      TransactionModel()
        ..id = j['id'] as int? ?? Isar.autoIncrement
        ..companyId = j['companyId'] as int? ?? 0
        ..amount = (j['amount'] as num?)?.toDouble() ?? 0
        ..date = _dateOr(j['date'])
        ..categoryName = j['categoryName'] as String? ?? ''
        ..categoryId = j['categoryId'] as int? ?? 0
        ..accountId = j['accountId'] as int?
        ..note = j['note'] as String?
        ..type = TransactionType.values.firstWhere(
          (v) => v.name == j['type'],
          orElse: () => TransactionType.expense,
        )
        ..isRecurring = j['isRecurring'] as bool? ?? false
        ..recurringDay = j['recurringDay'] as int?;

  static Map<String, dynamic> _paymentToJson(PaymentRecord p) => {
        'amount': p.amount,
        'date': _iso(p.date),
        'note': p.note,
      };

  static PaymentRecord _paymentFromJson(Map<String, dynamic> j) => PaymentRecord()
    ..amount = (j['amount'] as num?)?.toDouble() ?? 0
    ..date = _dateOr(j['date'])
    ..note = j['note'] as String?;

  static Map<String, dynamic> _debtToJson(DebtModel m) => {
        'id': m.id,
        'companyId': m.companyId,
        'debtType': m.debtType.name,
        'personName': m.personName,
        'accountId': m.accountId,
        'personPhone': m.personPhone,
        'personAvatar': m.personAvatar,
        'totalAmount': m.totalAmount,
        'paidAmount': m.paidAmount,
        'remainingAmount': m.remainingAmount,
        'createdAt': _iso(m.createdAt),
        'dueDate': _iso(m.dueDate),
        'lastPaymentDate': _iso(m.lastPaymentDate),
        'description': m.description,
        'category': m.category,
        'status': m.status.name,
        'paymentHistory':
            m.paymentHistory?.map(_paymentToJson).toList() ?? const [],
        'hasReminder': m.hasReminder,
        'reminderDate': _iso(m.reminderDate),
      };

  static DebtModel _debtFromJson(Map<String, dynamic> j) => DebtModel()
    ..id = j['id'] as int? ?? Isar.autoIncrement
    ..companyId = j['companyId'] as int? ?? 0
    ..debtType = DebtType.values.firstWhere(
      (v) => v.name == j['debtType'],
      orElse: () => DebtType.owe,
    )
    ..personName = j['personName'] as String? ?? ''
    ..accountId = j['accountId'] as int?
    ..personPhone = j['personPhone'] as String?
    ..personAvatar = j['personAvatar'] as String?
    ..totalAmount = (j['totalAmount'] as num?)?.toDouble() ?? 0
    ..paidAmount = (j['paidAmount'] as num?)?.toDouble() ?? 0
    ..remainingAmount = (j['remainingAmount'] as num?)?.toDouble() ?? 0
    ..createdAt = _dateOr(j['createdAt'])
    ..dueDate = _date(j['dueDate'])
    ..lastPaymentDate = _date(j['lastPaymentDate'])
    ..description = j['description'] as String?
    ..category = j['category'] as String?
    ..status = DebtStatus.values.firstWhere(
      (v) => v.name == j['status'],
      orElse: () => DebtStatus.active,
    )
    ..paymentHistory = [
      for (final p in (j['paymentHistory'] as List? ?? []))
        _paymentFromJson(Map<String, dynamic>.from(p as Map)),
    ]
    ..hasReminder = j['hasReminder'] as bool?
    ..reminderDate = _date(j['reminderDate']);

  static Map<String, dynamic> _accountToJson(AccountModel m) => {
        'id': m.id,
        'companyId': m.companyId,
        'name': m.name,
        'type': m.type.name,
        'totalBalance': m.totalBalance,
        'phoneNumber': m.phoneNumber,
        'note': m.note,
        'createdAt': _iso(m.createdAt),
        'updatedAt': _iso(m.updatedAt),
      };

  static AccountModel _accountFromJson(Map<String, dynamic> j) => AccountModel()
    ..id = j['id'] as int? ?? Isar.autoIncrement
    ..companyId = j['companyId'] as int? ?? 0
    ..name = j['name'] as String? ?? ''
    ..type = AccountType.values.firstWhere(
      (v) => v.name == j['type'],
      orElse: () => AccountType.personal,
    )
    ..totalBalance = (j['totalBalance'] as num?)?.toDouble() ?? 0
    ..phoneNumber = j['phoneNumber'] as String?
    ..note = j['note'] as String?
    ..createdAt = _dateOr(j['createdAt'])
    ..updatedAt = _dateOr(j['updatedAt']);

  static Map<String, dynamic> _categoryToJson(CategoryModel m) => {
        'id': m.id,
        'name': m.name,
        'iconData': m.iconData,
        'colorValue': m.colorValue,
        'isExpense': m.isExpense,
      };

  static CategoryModel _categoryFromJson(Map<String, dynamic> j) =>
      CategoryModel()
        ..id = j['id'] as int? ?? Isar.autoIncrement
        ..name = j['name'] as String? ?? ''
        ..iconData = j['iconData'] as String? ?? ''
        ..colorValue = j['colorValue'] as int? ?? 0
        ..isExpense = j['isExpense'] as bool? ?? true;

  static Map<String, dynamic> _budgetLimitToJson(BudgetLimitModel m) => {
        'id': m.id,
        'companyId': m.companyId,
        'categoryName': m.categoryName,
        'monthlyLimit': m.monthlyLimit,
        'isActive': m.isActive,
        'createdAt': _iso(m.createdAt),
        'updatedAt': _iso(m.updatedAt),
      };

  static BudgetLimitModel _budgetLimitFromJson(Map<String, dynamic> j) =>
      BudgetLimitModel()
        ..id = j['id'] as int? ?? Isar.autoIncrement
        ..companyId = j['companyId'] as int? ?? 0
        ..categoryName = j['categoryName'] as String? ?? ''
        ..monthlyLimit = (j['monthlyLimit'] as num?)?.toDouble() ?? 0
        ..isActive = j['isActive'] as bool? ?? true
        ..createdAt = _dateOr(j['createdAt'])
        ..updatedAt = _dateOr(j['updatedAt']);

  static Map<String, dynamic> _reminderSettingsToJson(
          ReminderSettingsModel m) =>
      {
        'id': m.id,
        'shiftStartEnabled': m.shiftStartEnabled,
        'shiftStartLeadMinutes': m.shiftStartLeadMinutes,
        'shiftEndEnabled': m.shiftEndEnabled,
        'shiftEndLeadMinutes': m.shiftEndLeadMinutes,
        'requiredHoursDoneEnabled': m.requiredHoursDoneEnabled,
        'forgotCheckOutEnabled': m.forgotCheckOutEnabled,
        'forgotCheckOutAfterHours': m.forgotCheckOutAfterHours,
        'missedCheckInEnabled': m.missedCheckInEnabled,
        'missedCheckInAfterMinutes': m.missedCheckInAfterMinutes,
        'debtDueEnabled': m.debtDueEnabled,
        'debtDueLeadDays': m.debtDueLeadDays,
        'debtOverdueEnabled': m.debtOverdueEnabled,
        'budgetOverrunEnabled': m.budgetOverrunEnabled,
        'budgetWarnThreshold': m.budgetWarnThreshold,
        'unusualSpendingEnabled': m.unusualSpendingEnabled,
        'debtRatioEnabled': m.debtRatioEnabled,
        'debtRatioThreshold': m.debtRatioThreshold,
        'monthEndForecastEnabled': m.monthEndForecastEnabled,
        'dailySummaryEnabled': m.dailySummaryEnabled,
        'dailySummaryTime': m.dailySummaryTime,
        'weeklySummaryEnabled': m.weeklySummaryEnabled,
        'weeklySummaryDayOfWeek': m.weeklySummaryDayOfWeek,
        'weeklySummaryTime': m.weeklySummaryTime,
        'monthlySummaryEnabled': m.monthlySummaryEnabled,
        'monthlySummaryDayOfMonth': m.monthlySummaryDayOfMonth,
        'monthlySummaryTime': m.monthlySummaryTime,
        'recurringExpenseEnabled': m.recurringExpenseEnabled,
        'quietHoursEnabled': m.quietHoursEnabled,
        'quietHoursStart': m.quietHoursStart,
        'quietHoursEnd': m.quietHoursEnd,
        'requireBiometricForAttendance': m.requireBiometricForAttendance,
        'allowDeviceCredential': m.allowDeviceCredential,
        'appLockEnabled': m.appLockEnabled,
        'updatedAt': _iso(m.updatedAt),
      };

  static ReminderSettingsModel _reminderSettingsFromJson(
      Map<String, dynamic> j) {
    final m = ReminderSettingsModel()..id = j['id'] as int? ?? 0;
    bool b(String k, bool fallback) => j[k] as bool? ?? fallback;
    int i(String k, int fallback) => j[k] as int? ?? fallback;
    double d(String k, double fallback) =>
        (j[k] as num?)?.toDouble() ?? fallback;
    String s(String k, String fallback) => j[k] as String? ?? fallback;

    return m
      ..shiftStartEnabled = b('shiftStartEnabled', true)
      ..shiftStartLeadMinutes = i('shiftStartLeadMinutes', 30)
      ..shiftEndEnabled = b('shiftEndEnabled', true)
      ..shiftEndLeadMinutes = i('shiftEndLeadMinutes', 15)
      ..requiredHoursDoneEnabled = b('requiredHoursDoneEnabled', true)
      ..forgotCheckOutEnabled = b('forgotCheckOutEnabled', true)
      ..forgotCheckOutAfterHours = i('forgotCheckOutAfterHours', 12)
      ..missedCheckInEnabled = b('missedCheckInEnabled', true)
      ..missedCheckInAfterMinutes = i('missedCheckInAfterMinutes', 45)
      ..debtDueEnabled = b('debtDueEnabled', true)
      ..debtDueLeadDays = [
        for (final v in (j['debtDueLeadDays'] as List? ?? const [7, 3, 1]))
          v as int,
      ]
      ..debtOverdueEnabled = b('debtOverdueEnabled', true)
      ..budgetOverrunEnabled = b('budgetOverrunEnabled', true)
      ..budgetWarnThreshold = d('budgetWarnThreshold', 0.8)
      ..unusualSpendingEnabled = b('unusualSpendingEnabled', true)
      ..debtRatioEnabled = b('debtRatioEnabled', true)
      ..debtRatioThreshold = d('debtRatioThreshold', 0.5)
      ..monthEndForecastEnabled = b('monthEndForecastEnabled', true)
      ..dailySummaryEnabled = b('dailySummaryEnabled', true)
      ..dailySummaryTime = s('dailySummaryTime', '21:00')
      ..weeklySummaryEnabled = b('weeklySummaryEnabled', true)
      ..weeklySummaryDayOfWeek = i('weeklySummaryDayOfWeek', 4)
      ..weeklySummaryTime = s('weeklySummaryTime', '20:00')
      ..monthlySummaryEnabled = b('monthlySummaryEnabled', true)
      ..monthlySummaryDayOfMonth = i('monthlySummaryDayOfMonth', 28)
      ..monthlySummaryTime = s('monthlySummaryTime', '19:00')
      ..recurringExpenseEnabled = b('recurringExpenseEnabled', true)
      ..quietHoursEnabled = b('quietHoursEnabled', false)
      ..quietHoursStart = s('quietHoursStart', '23:00')
      ..quietHoursEnd = s('quietHoursEnd', '07:00')
      ..requireBiometricForAttendance = b('requireBiometricForAttendance', true)
      ..allowDeviceCredential = b('allowDeviceCredential', true)
      ..appLockEnabled = b('appLockEnabled', false)
      ..updatedAt = _dateOr(j['updatedAt']);
  }
}
