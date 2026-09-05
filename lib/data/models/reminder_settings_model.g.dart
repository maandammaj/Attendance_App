// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReminderSettingsModelCollection on Isar {
  IsarCollection<ReminderSettingsModel> get reminderSettingsModels =>
      this.collection();
}

const ReminderSettingsModelSchema = CollectionSchema(
  name: r'ReminderSettingsModel',
  id: 1656663795440154833,
  properties: {
    r'allowDeviceCredential': PropertySchema(
      id: 0,
      name: r'allowDeviceCredential',
      type: IsarType.bool,
    ),
    r'appLockEnabled': PropertySchema(
      id: 1,
      name: r'appLockEnabled',
      type: IsarType.bool,
    ),
    r'budgetOverrunEnabled': PropertySchema(
      id: 2,
      name: r'budgetOverrunEnabled',
      type: IsarType.bool,
    ),
    r'budgetWarnThreshold': PropertySchema(
      id: 3,
      name: r'budgetWarnThreshold',
      type: IsarType.double,
    ),
    r'dailySummaryEnabled': PropertySchema(
      id: 4,
      name: r'dailySummaryEnabled',
      type: IsarType.bool,
    ),
    r'dailySummaryTime': PropertySchema(
      id: 5,
      name: r'dailySummaryTime',
      type: IsarType.string,
    ),
    r'debtDueEnabled': PropertySchema(
      id: 6,
      name: r'debtDueEnabled',
      type: IsarType.bool,
    ),
    r'debtDueLeadDays': PropertySchema(
      id: 7,
      name: r'debtDueLeadDays',
      type: IsarType.longList,
    ),
    r'debtOverdueEnabled': PropertySchema(
      id: 8,
      name: r'debtOverdueEnabled',
      type: IsarType.bool,
    ),
    r'debtRatioEnabled': PropertySchema(
      id: 9,
      name: r'debtRatioEnabled',
      type: IsarType.bool,
    ),
    r'debtRatioThreshold': PropertySchema(
      id: 10,
      name: r'debtRatioThreshold',
      type: IsarType.double,
    ),
    r'forgotCheckOutAfterHours': PropertySchema(
      id: 11,
      name: r'forgotCheckOutAfterHours',
      type: IsarType.long,
    ),
    r'forgotCheckOutEnabled': PropertySchema(
      id: 12,
      name: r'forgotCheckOutEnabled',
      type: IsarType.bool,
    ),
    r'missedCheckInAfterMinutes': PropertySchema(
      id: 13,
      name: r'missedCheckInAfterMinutes',
      type: IsarType.long,
    ),
    r'missedCheckInEnabled': PropertySchema(
      id: 14,
      name: r'missedCheckInEnabled',
      type: IsarType.bool,
    ),
    r'monthEndForecastEnabled': PropertySchema(
      id: 15,
      name: r'monthEndForecastEnabled',
      type: IsarType.bool,
    ),
    r'monthlySummaryDayOfMonth': PropertySchema(
      id: 16,
      name: r'monthlySummaryDayOfMonth',
      type: IsarType.long,
    ),
    r'monthlySummaryEnabled': PropertySchema(
      id: 17,
      name: r'monthlySummaryEnabled',
      type: IsarType.bool,
    ),
    r'monthlySummaryTime': PropertySchema(
      id: 18,
      name: r'monthlySummaryTime',
      type: IsarType.string,
    ),
    r'quietHoursEnabled': PropertySchema(
      id: 19,
      name: r'quietHoursEnabled',
      type: IsarType.bool,
    ),
    r'quietHoursEnd': PropertySchema(
      id: 20,
      name: r'quietHoursEnd',
      type: IsarType.string,
    ),
    r'quietHoursStart': PropertySchema(
      id: 21,
      name: r'quietHoursStart',
      type: IsarType.string,
    ),
    r'recurringExpenseEnabled': PropertySchema(
      id: 22,
      name: r'recurringExpenseEnabled',
      type: IsarType.bool,
    ),
    r'requireBiometricForAttendance': PropertySchema(
      id: 23,
      name: r'requireBiometricForAttendance',
      type: IsarType.bool,
    ),
    r'requiredHoursDoneEnabled': PropertySchema(
      id: 24,
      name: r'requiredHoursDoneEnabled',
      type: IsarType.bool,
    ),
    r'shiftEndEnabled': PropertySchema(
      id: 25,
      name: r'shiftEndEnabled',
      type: IsarType.bool,
    ),
    r'shiftEndLeadMinutes': PropertySchema(
      id: 26,
      name: r'shiftEndLeadMinutes',
      type: IsarType.long,
    ),
    r'shiftStartEnabled': PropertySchema(
      id: 27,
      name: r'shiftStartEnabled',
      type: IsarType.bool,
    ),
    r'shiftStartLeadMinutes': PropertySchema(
      id: 28,
      name: r'shiftStartLeadMinutes',
      type: IsarType.long,
    ),
    r'unusualSpendingEnabled': PropertySchema(
      id: 29,
      name: r'unusualSpendingEnabled',
      type: IsarType.bool,
    ),
    r'updatedAt': PropertySchema(
      id: 30,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'weeklySummaryDayOfWeek': PropertySchema(
      id: 31,
      name: r'weeklySummaryDayOfWeek',
      type: IsarType.long,
    ),
    r'weeklySummaryEnabled': PropertySchema(
      id: 32,
      name: r'weeklySummaryEnabled',
      type: IsarType.bool,
    ),
    r'weeklySummaryTime': PropertySchema(
      id: 33,
      name: r'weeklySummaryTime',
      type: IsarType.string,
    ),
  },

  estimateSize: _reminderSettingsModelEstimateSize,
  serialize: _reminderSettingsModelSerialize,
  deserialize: _reminderSettingsModelDeserialize,
  deserializeProp: _reminderSettingsModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _reminderSettingsModelGetId,
  getLinks: _reminderSettingsModelGetLinks,
  attach: _reminderSettingsModelAttach,
  version: '3.3.2',
);

int _reminderSettingsModelEstimateSize(
  ReminderSettingsModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.dailySummaryTime.length * 3;
  bytesCount += 3 + object.debtDueLeadDays.length * 8;
  bytesCount += 3 + object.monthlySummaryTime.length * 3;
  bytesCount += 3 + object.quietHoursEnd.length * 3;
  bytesCount += 3 + object.quietHoursStart.length * 3;
  bytesCount += 3 + object.weeklySummaryTime.length * 3;
  return bytesCount;
}

void _reminderSettingsModelSerialize(
  ReminderSettingsModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.allowDeviceCredential);
  writer.writeBool(offsets[1], object.appLockEnabled);
  writer.writeBool(offsets[2], object.budgetOverrunEnabled);
  writer.writeDouble(offsets[3], object.budgetWarnThreshold);
  writer.writeBool(offsets[4], object.dailySummaryEnabled);
  writer.writeString(offsets[5], object.dailySummaryTime);
  writer.writeBool(offsets[6], object.debtDueEnabled);
  writer.writeLongList(offsets[7], object.debtDueLeadDays);
  writer.writeBool(offsets[8], object.debtOverdueEnabled);
  writer.writeBool(offsets[9], object.debtRatioEnabled);
  writer.writeDouble(offsets[10], object.debtRatioThreshold);
  writer.writeLong(offsets[11], object.forgotCheckOutAfterHours);
  writer.writeBool(offsets[12], object.forgotCheckOutEnabled);
  writer.writeLong(offsets[13], object.missedCheckInAfterMinutes);
  writer.writeBool(offsets[14], object.missedCheckInEnabled);
  writer.writeBool(offsets[15], object.monthEndForecastEnabled);
  writer.writeLong(offsets[16], object.monthlySummaryDayOfMonth);
  writer.writeBool(offsets[17], object.monthlySummaryEnabled);
  writer.writeString(offsets[18], object.monthlySummaryTime);
  writer.writeBool(offsets[19], object.quietHoursEnabled);
  writer.writeString(offsets[20], object.quietHoursEnd);
  writer.writeString(offsets[21], object.quietHoursStart);
  writer.writeBool(offsets[22], object.recurringExpenseEnabled);
  writer.writeBool(offsets[23], object.requireBiometricForAttendance);
  writer.writeBool(offsets[24], object.requiredHoursDoneEnabled);
  writer.writeBool(offsets[25], object.shiftEndEnabled);
  writer.writeLong(offsets[26], object.shiftEndLeadMinutes);
  writer.writeBool(offsets[27], object.shiftStartEnabled);
  writer.writeLong(offsets[28], object.shiftStartLeadMinutes);
  writer.writeBool(offsets[29], object.unusualSpendingEnabled);
  writer.writeDateTime(offsets[30], object.updatedAt);
  writer.writeLong(offsets[31], object.weeklySummaryDayOfWeek);
  writer.writeBool(offsets[32], object.weeklySummaryEnabled);
  writer.writeString(offsets[33], object.weeklySummaryTime);
}

ReminderSettingsModel _reminderSettingsModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ReminderSettingsModel();
  object.allowDeviceCredential = reader.readBool(offsets[0]);
  object.appLockEnabled = reader.readBool(offsets[1]);
  object.budgetOverrunEnabled = reader.readBool(offsets[2]);
  object.budgetWarnThreshold = reader.readDouble(offsets[3]);
  object.dailySummaryEnabled = reader.readBool(offsets[4]);
  object.dailySummaryTime = reader.readString(offsets[5]);
  object.debtDueEnabled = reader.readBool(offsets[6]);
  object.debtDueLeadDays = reader.readLongList(offsets[7]) ?? [];
  object.debtOverdueEnabled = reader.readBool(offsets[8]);
  object.debtRatioEnabled = reader.readBool(offsets[9]);
  object.debtRatioThreshold = reader.readDouble(offsets[10]);
  object.forgotCheckOutAfterHours = reader.readLong(offsets[11]);
  object.forgotCheckOutEnabled = reader.readBool(offsets[12]);
  object.id = id;
  object.missedCheckInAfterMinutes = reader.readLong(offsets[13]);
  object.missedCheckInEnabled = reader.readBool(offsets[14]);
  object.monthEndForecastEnabled = reader.readBool(offsets[15]);
  object.monthlySummaryDayOfMonth = reader.readLong(offsets[16]);
  object.monthlySummaryEnabled = reader.readBool(offsets[17]);
  object.monthlySummaryTime = reader.readString(offsets[18]);
  object.quietHoursEnabled = reader.readBool(offsets[19]);
  object.quietHoursEnd = reader.readString(offsets[20]);
  object.quietHoursStart = reader.readString(offsets[21]);
  object.recurringExpenseEnabled = reader.readBool(offsets[22]);
  object.requireBiometricForAttendance = reader.readBool(offsets[23]);
  object.requiredHoursDoneEnabled = reader.readBool(offsets[24]);
  object.shiftEndEnabled = reader.readBool(offsets[25]);
  object.shiftEndLeadMinutes = reader.readLong(offsets[26]);
  object.shiftStartEnabled = reader.readBool(offsets[27]);
  object.shiftStartLeadMinutes = reader.readLong(offsets[28]);
  object.unusualSpendingEnabled = reader.readBool(offsets[29]);
  object.updatedAt = reader.readDateTime(offsets[30]);
  object.weeklySummaryDayOfWeek = reader.readLong(offsets[31]);
  object.weeklySummaryEnabled = reader.readBool(offsets[32]);
  object.weeklySummaryTime = reader.readString(offsets[33]);
  return object;
}

P _reminderSettingsModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLongList(offset) ?? []) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readBool(offset)) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readBool(offset)) as P;
    case 20:
      return (reader.readString(offset)) as P;
    case 21:
      return (reader.readString(offset)) as P;
    case 22:
      return (reader.readBool(offset)) as P;
    case 23:
      return (reader.readBool(offset)) as P;
    case 24:
      return (reader.readBool(offset)) as P;
    case 25:
      return (reader.readBool(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (reader.readBool(offset)) as P;
    case 28:
      return (reader.readLong(offset)) as P;
    case 29:
      return (reader.readBool(offset)) as P;
    case 30:
      return (reader.readDateTime(offset)) as P;
    case 31:
      return (reader.readLong(offset)) as P;
    case 32:
      return (reader.readBool(offset)) as P;
    case 33:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _reminderSettingsModelGetId(ReminderSettingsModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reminderSettingsModelGetLinks(
  ReminderSettingsModel object,
) {
  return [];
}

void _reminderSettingsModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ReminderSettingsModel object,
) {
  object.id = id;
}

extension ReminderSettingsModelQueryWhereSort
    on QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QWhere> {
  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhere>
  anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ReminderSettingsModelQueryWhere
    on
        QueryBuilder<
          ReminderSettingsModel,
          ReminderSettingsModel,
          QWhereClause
        > {
  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhereClause>
  idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhereClause>
  idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterWhereClause>
  idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension ReminderSettingsModelQueryFilter
    on
        QueryBuilder<
          ReminderSettingsModel,
          ReminderSettingsModel,
          QFilterCondition
        > {
  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  allowDeviceCredentialEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'allowDeviceCredential',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  appLockEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'appLockEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  budgetOverrunEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'budgetOverrunEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  budgetWarnThresholdEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'budgetWarnThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  budgetWarnThresholdGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'budgetWarnThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  budgetWarnThresholdLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'budgetWarnThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  budgetWarnThresholdBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'budgetWarnThreshold',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailySummaryEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dailySummaryTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'dailySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'dailySummaryTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dailySummaryTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  dailySummaryTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'dailySummaryTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtDueEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtDueLeadDays', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysElementGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debtDueLeadDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysElementLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debtDueLeadDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debtDueLeadDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'debtDueLeadDays', length, true, length, true);
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'debtDueLeadDays', 0, true, 0, true);
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'debtDueLeadDays', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'debtDueLeadDays', 0, true, length, include);
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'debtDueLeadDays',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtDueLeadDaysLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'debtDueLeadDays',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtOverdueEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtOverdueEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtRatioEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtRatioEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtRatioThresholdEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'debtRatioThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtRatioThresholdGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debtRatioThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtRatioThresholdLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debtRatioThreshold',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  debtRatioThresholdBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debtRatioThreshold',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  forgotCheckOutAfterHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'forgotCheckOutAfterHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  forgotCheckOutAfterHoursGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'forgotCheckOutAfterHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  forgotCheckOutAfterHoursLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'forgotCheckOutAfterHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  forgotCheckOutAfterHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'forgotCheckOutAfterHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  forgotCheckOutEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'forgotCheckOutEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  idGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  idLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  missedCheckInAfterMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'missedCheckInAfterMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  missedCheckInAfterMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'missedCheckInAfterMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  missedCheckInAfterMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'missedCheckInAfterMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  missedCheckInAfterMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'missedCheckInAfterMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  missedCheckInEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'missedCheckInEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthEndForecastEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthEndForecastEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryDayOfMonthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlySummaryDayOfMonth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryDayOfMonthGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlySummaryDayOfMonth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryDayOfMonthLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlySummaryDayOfMonth',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryDayOfMonthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlySummaryDayOfMonth',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlySummaryEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlySummaryTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'monthlySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'monthlySummaryTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'monthlySummaryTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  monthlySummaryTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'monthlySummaryTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quietHoursEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quietHoursEnd',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'quietHoursEnd',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'quietHoursEnd',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quietHoursEnd', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursEndIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'quietHoursEnd', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'quietHoursStart',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'quietHoursStart',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'quietHoursStart',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'quietHoursStart', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  quietHoursStartIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'quietHoursStart', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  recurringExpenseEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'recurringExpenseEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  requireBiometricForAttendanceEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'requireBiometricForAttendance',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  requiredHoursDoneEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'requiredHoursDoneEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftEndEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shiftEndEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftEndLeadMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shiftEndLeadMinutes', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftEndLeadMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shiftEndLeadMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftEndLeadMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shiftEndLeadMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftEndLeadMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shiftEndLeadMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftStartEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'shiftStartEnabled', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftStartLeadMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'shiftStartLeadMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftStartLeadMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'shiftStartLeadMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftStartLeadMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'shiftStartLeadMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  shiftStartLeadMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'shiftStartLeadMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  unusualSpendingEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'unusualSpendingEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  updatedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  updatedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'updatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'updatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryDayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weeklySummaryDayOfWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryDayOfWeekGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weeklySummaryDayOfWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryDayOfWeekLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weeklySummaryDayOfWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryDayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weeklySummaryDayOfWeek',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weeklySummaryEnabled',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weeklySummaryTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'weeklySummaryTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'weeklySummaryTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weeklySummaryTime', value: ''),
      );
    });
  }

  QueryBuilder<
    ReminderSettingsModel,
    ReminderSettingsModel,
    QAfterFilterCondition
  >
  weeklySummaryTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'weeklySummaryTime', value: ''),
      );
    });
  }
}

extension ReminderSettingsModelQueryObject
    on
        QueryBuilder<
          ReminderSettingsModel,
          ReminderSettingsModel,
          QFilterCondition
        > {}

extension ReminderSettingsModelQueryLinks
    on
        QueryBuilder<
          ReminderSettingsModel,
          ReminderSettingsModel,
          QFilterCondition
        > {}

extension ReminderSettingsModelQuerySortBy
    on QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QSortBy> {
  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByAllowDeviceCredential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowDeviceCredential', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByAllowDeviceCredentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowDeviceCredential', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByAppLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByBudgetOverrunEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOverrunEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByBudgetOverrunEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOverrunEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByBudgetWarnThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetWarnThreshold', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByBudgetWarnThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetWarnThreshold', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDailySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDailySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtDueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtDueEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtDueEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtDueEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtOverdueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtOverdueEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtOverdueEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtOverdueEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtRatioEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtRatioEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtRatioThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioThreshold', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByDebtRatioThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioThreshold', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByForgotCheckOutAfterHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutAfterHours', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByForgotCheckOutAfterHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutAfterHours', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByForgotCheckOutEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByForgotCheckOutEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMissedCheckInAfterMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInAfterMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMissedCheckInAfterMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInAfterMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMissedCheckInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMissedCheckInEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthEndForecastEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthEndForecastEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthEndForecastEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthEndForecastEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryDayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryDayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByMonthlySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRecurringExpenseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringExpenseEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRecurringExpenseEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringExpenseEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRequireBiometricForAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireBiometricForAttendance', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRequireBiometricForAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireBiometricForAttendance', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRequiredHoursDoneEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHoursDoneEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByRequiredHoursDoneEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHoursDoneEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftEndEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftEndEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftEndLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndLeadMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftEndLeadMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndLeadMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftStartEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftStartEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftStartLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartLeadMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByShiftStartLeadMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartLeadMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByUnusualSpendingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unusualSpendingEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByUnusualSpendingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unusualSpendingEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  sortByWeeklySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryTime', Sort.desc);
    });
  }
}

extension ReminderSettingsModelQuerySortThenBy
    on QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QSortThenBy> {
  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByAllowDeviceCredential() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowDeviceCredential', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByAllowDeviceCredentialDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'allowDeviceCredential', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByAppLockEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'appLockEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByBudgetOverrunEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOverrunEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByBudgetOverrunEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetOverrunEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByBudgetWarnThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetWarnThreshold', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByBudgetWarnThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'budgetWarnThreshold', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDailySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDailySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDailySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dailySummaryTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtDueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtDueEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtDueEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtDueEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtOverdueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtOverdueEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtOverdueEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtOverdueEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtRatioEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtRatioEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtRatioThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioThreshold', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByDebtRatioThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtRatioThreshold', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByForgotCheckOutAfterHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutAfterHours', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByForgotCheckOutAfterHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutAfterHours', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByForgotCheckOutEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByForgotCheckOutEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'forgotCheckOutEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMissedCheckInAfterMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInAfterMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMissedCheckInAfterMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInAfterMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMissedCheckInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMissedCheckInEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missedCheckInEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthEndForecastEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthEndForecastEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthEndForecastEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthEndForecastEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryDayOfMonth', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryDayOfMonthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryDayOfMonth', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByMonthlySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlySummaryTime', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursEnd', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByQuietHoursStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quietHoursStart', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRecurringExpenseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringExpenseEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRecurringExpenseEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recurringExpenseEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRequireBiometricForAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireBiometricForAttendance', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRequireBiometricForAttendanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requireBiometricForAttendance', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRequiredHoursDoneEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHoursDoneEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByRequiredHoursDoneEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHoursDoneEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftEndEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftEndEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftEndLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndLeadMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftEndLeadMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftEndLeadMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftStartEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftStartEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftStartLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartLeadMinutes', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByShiftStartLeadMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'shiftStartLeadMinutes', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByUnusualSpendingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unusualSpendingEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByUnusualSpendingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unusualSpendingEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryDayOfWeek', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryDayOfWeekDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryDayOfWeek', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryEnabled', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryEnabled', Sort.desc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryTime', Sort.asc);
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QAfterSortBy>
  thenByWeeklySummaryTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weeklySummaryTime', Sort.desc);
    });
  }
}

extension ReminderSettingsModelQueryWhereDistinct
    on QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct> {
  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByAllowDeviceCredential() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'allowDeviceCredential');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByAppLockEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'appLockEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByBudgetOverrunEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetOverrunEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByBudgetWarnThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'budgetWarnThreshold');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDailySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDailySummaryTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'dailySummaryTime',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDebtDueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtDueEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDebtDueLeadDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtDueLeadDays');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDebtOverdueEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtOverdueEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDebtRatioEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtRatioEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByDebtRatioThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtRatioThreshold');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByForgotCheckOutAfterHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forgotCheckOutAfterHours');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByForgotCheckOutEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'forgotCheckOutEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMissedCheckInAfterMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missedCheckInAfterMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMissedCheckInEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missedCheckInEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMonthEndForecastEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthEndForecastEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMonthlySummaryDayOfMonth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySummaryDayOfMonth');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMonthlySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByMonthlySummaryTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'monthlySummaryTime',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByQuietHoursEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quietHoursEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByQuietHoursEnd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'quietHoursEnd',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByQuietHoursStart({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'quietHoursStart',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByRecurringExpenseEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recurringExpenseEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByRequireBiometricForAttendance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requireBiometricForAttendance');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByRequiredHoursDoneEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requiredHoursDoneEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByShiftEndEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftEndEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByShiftEndLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftEndLeadMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByShiftStartEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftStartEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByShiftStartLeadMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'shiftStartLeadMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByUnusualSpendingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unusualSpendingEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByWeeklySummaryDayOfWeek() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklySummaryDayOfWeek');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByWeeklySummaryEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weeklySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, ReminderSettingsModel, QDistinct>
  distinctByWeeklySummaryTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'weeklySummaryTime',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension ReminderSettingsModelQueryProperty
    on
        QueryBuilder<
          ReminderSettingsModel,
          ReminderSettingsModel,
          QQueryProperty
        > {
  QueryBuilder<ReminderSettingsModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  allowDeviceCredentialProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'allowDeviceCredential');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  appLockEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'appLockEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  budgetOverrunEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetOverrunEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, double, QQueryOperations>
  budgetWarnThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'budgetWarnThreshold');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  dailySummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, String, QQueryOperations>
  dailySummaryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dailySummaryTime');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  debtDueEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtDueEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, List<int>, QQueryOperations>
  debtDueLeadDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtDueLeadDays');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  debtOverdueEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtOverdueEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  debtRatioEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtRatioEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, double, QQueryOperations>
  debtRatioThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtRatioThreshold');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  forgotCheckOutAfterHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forgotCheckOutAfterHours');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  forgotCheckOutEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'forgotCheckOutEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  missedCheckInAfterMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missedCheckInAfterMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  missedCheckInEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missedCheckInEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  monthEndForecastEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthEndForecastEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  monthlySummaryDayOfMonthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySummaryDayOfMonth');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  monthlySummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, String, QQueryOperations>
  monthlySummaryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlySummaryTime');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  quietHoursEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, String, QQueryOperations>
  quietHoursEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursEnd');
    });
  }

  QueryBuilder<ReminderSettingsModel, String, QQueryOperations>
  quietHoursStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quietHoursStart');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  recurringExpenseEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recurringExpenseEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  requireBiometricForAttendanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requireBiometricForAttendance');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  requiredHoursDoneEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requiredHoursDoneEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  shiftEndEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftEndEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  shiftEndLeadMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftEndLeadMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  shiftStartEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftStartEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  shiftStartLeadMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'shiftStartLeadMinutes');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  unusualSpendingEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unusualSpendingEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ReminderSettingsModel, int, QQueryOperations>
  weeklySummaryDayOfWeekProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklySummaryDayOfWeek');
    });
  }

  QueryBuilder<ReminderSettingsModel, bool, QQueryOperations>
  weeklySummaryEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklySummaryEnabled');
    });
  }

  QueryBuilder<ReminderSettingsModel, String, QQueryOperations>
  weeklySummaryTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weeklySummaryTime');
    });
  }
}
