// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProfileModelCollection on Isar {
  IsarCollection<ProfileModel> get profileModels => this.collection();
}

const ProfileModelSchema = CollectionSchema(
  name: r'ProfileModel',
  id: 7663001939508120177,
  properties: {
    r'adjustments': PropertySchema(
      id: 0,
      name: r'adjustments',
      type: IsarType.objectList,

      target: r'SalaryAdjustment',
    ),
    r'baseMonthlySalary': PropertySchema(
      id: 1,
      name: r'baseMonthlySalary',
      type: IsarType.double,
    ),
    r'companyName': PropertySchema(
      id: 2,
      name: r'companyName',
      type: IsarType.string,
    ),
    r'currency': PropertySchema(
      id: 3,
      name: r'currency',
      type: IsarType.string,
    ),
    r'employmentStartDate': PropertySchema(
      id: 4,
      name: r'employmentStartDate',
      type: IsarType.dateTime,
    ),
    r'fullName': PropertySchema(
      id: 5,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'hourlyRate': PropertySchema(
      id: 6,
      name: r'hourlyRate',
      type: IsarType.double,
    ),
    r'jobTitle': PropertySchema(
      id: 7,
      name: r'jobTitle',
      type: IsarType.string,
    ),
    r'overtimeRate': PropertySchema(
      id: 8,
      name: r'overtimeRate',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 9,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workSchedule': PropertySchema(
      id: 10,
      name: r'workSchedule',
      type: IsarType.objectList,

      target: r'WorkDayConfig',
    ),
  },

  estimateSize: _profileModelEstimateSize,
  serialize: _profileModelSerialize,
  deserialize: _profileModelDeserialize,
  deserializeProp: _profileModelDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {
    r'WorkDayConfig': WorkDayConfigSchema,
    r'SalaryAdjustment': SalaryAdjustmentSchema,
  },

  getId: _profileModelGetId,
  getLinks: _profileModelGetLinks,
  attach: _profileModelAttach,
  version: '3.3.0-dev.1',
);

int _profileModelEstimateSize(
  ProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.adjustments.length * 3;
  {
    final offsets = allOffsets[SalaryAdjustment]!;
    for (var i = 0; i < object.adjustments.length; i++) {
      final value = object.adjustments[i];
      bytesCount += SalaryAdjustmentSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  {
    final value = object.companyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.currency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fullName.length * 3;
  bytesCount += 3 + object.jobTitle.length * 3;
  bytesCount += 3 + object.workSchedule.length * 3;
  {
    final offsets = allOffsets[WorkDayConfig]!;
    for (var i = 0; i < object.workSchedule.length; i++) {
      final value = object.workSchedule[i];
      bytesCount += WorkDayConfigSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _profileModelSerialize(
  ProfileModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<SalaryAdjustment>(
    offsets[0],
    allOffsets,
    SalaryAdjustmentSchema.serialize,
    object.adjustments,
  );
  writer.writeDouble(offsets[1], object.baseMonthlySalary);
  writer.writeString(offsets[2], object.companyName);
  writer.writeString(offsets[3], object.currency);
  writer.writeDateTime(offsets[4], object.employmentStartDate);
  writer.writeString(offsets[5], object.fullName);
  writer.writeDouble(offsets[6], object.hourlyRate);
  writer.writeString(offsets[7], object.jobTitle);
  writer.writeDouble(offsets[8], object.overtimeRate);
  writer.writeDateTime(offsets[9], object.updatedAt);
  writer.writeObjectList<WorkDayConfig>(
    offsets[10],
    allOffsets,
    WorkDayConfigSchema.serialize,
    object.workSchedule,
  );
}

ProfileModel _profileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileModel();
  object.adjustments =
      reader.readObjectList<SalaryAdjustment>(
        offsets[0],
        SalaryAdjustmentSchema.deserialize,
        allOffsets,
        SalaryAdjustment(),
      ) ??
      [];
  object.baseMonthlySalary = reader.readDouble(offsets[1]);
  object.companyName = reader.readStringOrNull(offsets[2]);
  object.currency = reader.readStringOrNull(offsets[3]);
  object.employmentStartDate = reader.readDateTimeOrNull(offsets[4]);
  object.fullName = reader.readString(offsets[5]);
  object.hourlyRate = reader.readDouble(offsets[6]);
  object.id = id;
  object.jobTitle = reader.readString(offsets[7]);
  object.overtimeRate = reader.readDouble(offsets[8]);
  object.updatedAt = reader.readDateTime(offsets[9]);
  object.workSchedule =
      reader.readObjectList<WorkDayConfig>(
        offsets[10],
        WorkDayConfigSchema.deserialize,
        allOffsets,
        WorkDayConfig(),
      ) ??
      [];
  return object;
}

P _profileModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<SalaryAdjustment>(
                offset,
                SalaryAdjustmentSchema.deserialize,
                allOffsets,
                SalaryAdjustment(),
              ) ??
              [])
          as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDateTime(offset)) as P;
    case 10:
      return (reader.readObjectList<WorkDayConfig>(
                offset,
                WorkDayConfigSchema.deserialize,
                allOffsets,
                WorkDayConfig(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _profileModelGetId(ProfileModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _profileModelGetLinks(ProfileModel object) {
  return [];
}

void _profileModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  ProfileModel object,
) {
  object.id = id;
}

extension ProfileModelQueryWhereSort
    on QueryBuilder<ProfileModel, ProfileModel, QWhere> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProfileModelQueryWhere
    on QueryBuilder<ProfileModel, ProfileModel, QWhereClause> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterWhereClause> idBetween(
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

extension ProfileModelQueryFilter
    on QueryBuilder<ProfileModel, ProfileModel, QFilterCondition> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', length, true, length, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adjustments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  baseMonthlySalaryEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'baseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  baseMonthlySalaryGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'baseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  baseMonthlySalaryLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'baseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  baseMonthlySalaryBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'baseMonthlySalary',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'companyName'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'companyName'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'companyName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'companyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'companyName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'companyName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  companyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'companyName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'currency'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'currency'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'currency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'currency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'employmentStartDate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'employmentStartDate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employmentStartDate', value: value),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'employmentStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'employmentStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  employmentStartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'employmentStartDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'fullName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'fullName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'fullName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'fullName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  fullNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'fullName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  hourlyRateEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'hourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  hourlyRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'hourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  hourlyRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'hourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  hourlyRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'hourlyRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'jobTitle',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'jobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'jobTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'jobTitle', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  jobTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'jobTitle', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  overtimeRateEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'overtimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  overtimeRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'overtimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  overtimeRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'overtimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  overtimeRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'overtimeRate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', length, true, length, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', length, include, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'workSchedule',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension ProfileModelQueryObject
    on QueryBuilder<ProfileModel, ProfileModel, QFilterCondition> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  adjustmentsElement(FilterQuery<SalaryAdjustment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'adjustments');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  workScheduleElement(FilterQuery<WorkDayConfig> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'workSchedule');
    });
  }
}

extension ProfileModelQueryLinks
    on QueryBuilder<ProfileModel, ProfileModel, QFilterCondition> {}

extension ProfileModelQuerySortBy
    on QueryBuilder<ProfileModel, ProfileModel, QSortBy> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ProfileModelQuerySortThenBy
    on QueryBuilder<ProfileModel, ProfileModel, QSortThenBy> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByFullName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByFullNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fullName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension ProfileModelQueryWhereDistinct
    on QueryBuilder<ProfileModel, ProfileModel, QDistinct> {
  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseMonthlySalary');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByCompanyName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByCurrency({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employmentStartDate');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourlyRate');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByJobTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jobTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeRate');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension ProfileModelQueryProperty
    on QueryBuilder<ProfileModel, ProfileModel, QQueryProperty> {
  QueryBuilder<ProfileModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProfileModel, List<SalaryAdjustment>, QQueryOperations>
  adjustmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adjustments');
    });
  }

  QueryBuilder<ProfileModel, double, QQueryOperations>
  baseMonthlySalaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseMonthlySalary');
    });
  }

  QueryBuilder<ProfileModel, String?, QQueryOperations> companyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyName');
    });
  }

  QueryBuilder<ProfileModel, String?, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<ProfileModel, DateTime?, QQueryOperations>
  employmentStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employmentStartDate');
    });
  }

  QueryBuilder<ProfileModel, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<ProfileModel, double, QQueryOperations> hourlyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourlyRate');
    });
  }

  QueryBuilder<ProfileModel, String, QQueryOperations> jobTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jobTitle');
    });
  }

  QueryBuilder<ProfileModel, double, QQueryOperations> overtimeRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeRate');
    });
  }

  QueryBuilder<ProfileModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<ProfileModel, List<WorkDayConfig>, QQueryOperations>
  workScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workSchedule');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const SalaryAdjustmentSchema = Schema(
  name: r'SalaryAdjustment',
  id: -3359139185595871952,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'isAddition': PropertySchema(
      id: 1,
      name: r'isAddition',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(id: 2, name: r'title', type: IsarType.string),
  },

  estimateSize: _salaryAdjustmentEstimateSize,
  serialize: _salaryAdjustmentSerialize,
  deserialize: _salaryAdjustmentDeserialize,
  deserializeProp: _salaryAdjustmentDeserializeProp,
);

int _salaryAdjustmentEstimateSize(
  SalaryAdjustment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _salaryAdjustmentSerialize(
  SalaryAdjustment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeBool(offsets[1], object.isAddition);
  writer.writeString(offsets[2], object.title);
}

SalaryAdjustment _salaryAdjustmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SalaryAdjustment();
  object.amount = reader.readDouble(offsets[0]);
  object.isAddition = reader.readBool(offsets[1]);
  object.title = reader.readString(offsets[2]);
  return object;
}

P _salaryAdjustmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension SalaryAdjustmentQueryFilter
    on QueryBuilder<SalaryAdjustment, SalaryAdjustment, QFilterCondition> {
  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  amountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'amount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'amount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  isAdditionEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAddition', value: value),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'title',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'title',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'title',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'title', value: ''),
      );
    });
  }

  QueryBuilder<SalaryAdjustment, SalaryAdjustment, QAfterFilterCondition>
  titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'title', value: ''),
      );
    });
  }
}

extension SalaryAdjustmentQueryObject
    on QueryBuilder<SalaryAdjustment, SalaryAdjustment, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WorkDayConfigSchema = Schema(
  name: r'WorkDayConfig',
  id: -7348122467609087063,
  properties: {
    r'dayOfWeek': PropertySchema(
      id: 0,
      name: r'dayOfWeek',
      type: IsarType.long,
    ),
    r'endTime': PropertySchema(id: 1, name: r'endTime', type: IsarType.string),
    r'isCrossDay': PropertySchema(
      id: 2,
      name: r'isCrossDay',
      type: IsarType.bool,
    ),
    r'isHoliday': PropertySchema(
      id: 3,
      name: r'isHoliday',
      type: IsarType.bool,
    ),
    r'isWorkingDay': PropertySchema(
      id: 4,
      name: r'isWorkingDay',
      type: IsarType.bool,
    ),
    r'requiredHours': PropertySchema(
      id: 5,
      name: r'requiredHours',
      type: IsarType.long,
    ),
    r'requiredMinutes': PropertySchema(
      id: 6,
      name: r'requiredMinutes',
      type: IsarType.long,
    ),
    r'startTime': PropertySchema(
      id: 7,
      name: r'startTime',
      type: IsarType.string,
    ),
  },

  estimateSize: _workDayConfigEstimateSize,
  serialize: _workDayConfigSerialize,
  deserialize: _workDayConfigDeserialize,
  deserializeProp: _workDayConfigDeserializeProp,
);

int _workDayConfigEstimateSize(
  WorkDayConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.endTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.startTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _workDayConfigSerialize(
  WorkDayConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayOfWeek);
  writer.writeString(offsets[1], object.endTime);
  writer.writeBool(offsets[2], object.isCrossDay);
  writer.writeBool(offsets[3], object.isHoliday);
  writer.writeBool(offsets[4], object.isWorkingDay);
  writer.writeLong(offsets[5], object.requiredHours);
  writer.writeLong(offsets[6], object.requiredMinutes);
  writer.writeString(offsets[7], object.startTime);
}

WorkDayConfig _workDayConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkDayConfig();
  object.dayOfWeek = reader.readLong(offsets[0]);
  object.endTime = reader.readStringOrNull(offsets[1]);
  object.isCrossDay = reader.readBool(offsets[2]);
  object.isHoliday = reader.readBool(offsets[3]);
  object.isWorkingDay = reader.readBool(offsets[4]);
  object.requiredHours = reader.readLong(offsets[5]);
  object.requiredMinutes = reader.readLong(offsets[6]);
  object.startTime = reader.readStringOrNull(offsets[7]);
  return object;
}

P _workDayConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WorkDayConfigQueryFilter
    on QueryBuilder<WorkDayConfig, WorkDayConfig, QFilterCondition> {
  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  dayOfWeekEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayOfWeek', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  dayOfWeekGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayOfWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  dayOfWeekLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayOfWeek',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  dayOfWeekBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayOfWeek',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'endTime'),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'endTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'endTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'endTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  endTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'endTime', value: ''),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  isCrossDayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCrossDay', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  isHolidayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isHoliday', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  isWorkingDayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isWorkingDay', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'requiredHours', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredHoursGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'requiredHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredHoursLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'requiredHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'requiredHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'requiredMinutes', value: value),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'requiredMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'requiredMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  requiredMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'requiredMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'startTime'),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startTime',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'startTime',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'startTime',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startTime', value: ''),
      );
    });
  }

  QueryBuilder<WorkDayConfig, WorkDayConfig, QAfterFilterCondition>
  startTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'startTime', value: ''),
      );
    });
  }
}

extension WorkDayConfigQueryObject
    on QueryBuilder<WorkDayConfig, WorkDayConfig, QFilterCondition> {}
