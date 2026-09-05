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
    r'activeCompanyId': PropertySchema(
      id: 0,
      name: r'activeCompanyId',
      type: IsarType.long,
    ),
    r'currency': PropertySchema(
      id: 1,
      name: r'currency',
      type: IsarType.string,
    ),
    r'fullName': PropertySchema(
      id: 2,
      name: r'fullName',
      type: IsarType.string,
    ),
    r'legacyAdjustments': PropertySchema(
      id: 3,
      name: r'legacyAdjustments',
      type: IsarType.objectList,

      target: r'SalaryAdjustment',
    ),
    r'legacyBaseMonthlySalary': PropertySchema(
      id: 4,
      name: r'legacyBaseMonthlySalary',
      type: IsarType.double,
    ),
    r'legacyCompanyName': PropertySchema(
      id: 5,
      name: r'legacyCompanyName',
      type: IsarType.string,
    ),
    r'legacyEmploymentStartDate': PropertySchema(
      id: 6,
      name: r'legacyEmploymentStartDate',
      type: IsarType.dateTime,
    ),
    r'legacyHourlyRate': PropertySchema(
      id: 7,
      name: r'legacyHourlyRate',
      type: IsarType.double,
    ),
    r'legacyJobTitle': PropertySchema(
      id: 8,
      name: r'legacyJobTitle',
      type: IsarType.string,
    ),
    r'legacyOvertimeRate': PropertySchema(
      id: 9,
      name: r'legacyOvertimeRate',
      type: IsarType.double,
    ),
    r'legacyWorkSchedule': PropertySchema(
      id: 10,
      name: r'legacyWorkSchedule',
      type: IsarType.objectList,

      target: r'WorkDayConfig',
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
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
  version: '3.3.2',
);

int _profileModelEstimateSize(
  ProfileModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.currency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fullName.length * 3;
  {
    final list = object.legacyAdjustments;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[SalaryAdjustment]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += SalaryAdjustmentSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.legacyCompanyName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.legacyJobTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.legacyWorkSchedule;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[WorkDayConfig]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += WorkDayConfigSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
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
  writer.writeLong(offsets[0], object.activeCompanyId);
  writer.writeString(offsets[1], object.currency);
  writer.writeString(offsets[2], object.fullName);
  writer.writeObjectList<SalaryAdjustment>(
    offsets[3],
    allOffsets,
    SalaryAdjustmentSchema.serialize,
    object.legacyAdjustments,
  );
  writer.writeDouble(offsets[4], object.legacyBaseMonthlySalary);
  writer.writeString(offsets[5], object.legacyCompanyName);
  writer.writeDateTime(offsets[6], object.legacyEmploymentStartDate);
  writer.writeDouble(offsets[7], object.legacyHourlyRate);
  writer.writeString(offsets[8], object.legacyJobTitle);
  writer.writeDouble(offsets[9], object.legacyOvertimeRate);
  writer.writeObjectList<WorkDayConfig>(
    offsets[10],
    allOffsets,
    WorkDayConfigSchema.serialize,
    object.legacyWorkSchedule,
  );
  writer.writeDateTime(offsets[11], object.updatedAt);
}

ProfileModel _profileModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProfileModel();
  object.activeCompanyId = reader.readLongOrNull(offsets[0]);
  object.currency = reader.readStringOrNull(offsets[1]);
  object.fullName = reader.readString(offsets[2]);
  object.id = id;
  object.legacyAdjustments = reader.readObjectList<SalaryAdjustment>(
    offsets[3],
    SalaryAdjustmentSchema.deserialize,
    allOffsets,
    SalaryAdjustment(),
  );
  object.legacyBaseMonthlySalary = reader.readDoubleOrNull(offsets[4]);
  object.legacyCompanyName = reader.readStringOrNull(offsets[5]);
  object.legacyEmploymentStartDate = reader.readDateTimeOrNull(offsets[6]);
  object.legacyHourlyRate = reader.readDoubleOrNull(offsets[7]);
  object.legacyJobTitle = reader.readStringOrNull(offsets[8]);
  object.legacyOvertimeRate = reader.readDoubleOrNull(offsets[9]);
  object.legacyWorkSchedule = reader.readObjectList<WorkDayConfig>(
    offsets[10],
    WorkDayConfigSchema.deserialize,
    allOffsets,
    WorkDayConfig(),
  );
  object.updatedAt = reader.readDateTime(offsets[11]);
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
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readObjectList<SalaryAdjustment>(
            offset,
            SalaryAdjustmentSchema.deserialize,
            allOffsets,
            SalaryAdjustment(),
          ))
          as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readObjectList<WorkDayConfig>(
            offset,
            WorkDayConfigSchema.deserialize,
            allOffsets,
            WorkDayConfig(),
          ))
          as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
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
  activeCompanyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'activeCompanyId'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  activeCompanyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'activeCompanyId'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  activeCompanyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'activeCompanyId', value: value),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  activeCompanyIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'activeCompanyId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  activeCompanyIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'activeCompanyId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  activeCompanyIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'activeCompanyId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
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
  legacyAdjustmentsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyAdjustments'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyAdjustments'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyAdjustments', length, true, length, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyAdjustments', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyAdjustments', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyAdjustments', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'legacyAdjustments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'legacyAdjustments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyBaseMonthlySalary'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyBaseMonthlySalary'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyBaseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyBaseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyBaseMonthlySalary',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyBaseMonthlySalaryBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyBaseMonthlySalary',
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
  legacyCompanyNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyCompanyName'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyCompanyName'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyCompanyName',
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
  legacyCompanyNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'legacyCompanyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'legacyCompanyName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'legacyCompanyName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyCompanyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'legacyCompanyName', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyEmploymentStartDate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyEmploymentStartDate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyEmploymentStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyEmploymentStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyEmploymentStartDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyEmploymentStartDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyEmploymentStartDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyHourlyRate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyHourlyRate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyHourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyHourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyHourlyRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyHourlyRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyHourlyRate',
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
  legacyJobTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyJobTitle'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyJobTitle'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyJobTitle',
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
  legacyJobTitleStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'legacyJobTitle',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'legacyJobTitle',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'legacyJobTitle', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyJobTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'legacyJobTitle', value: ''),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyOvertimeRate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyOvertimeRate'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'legacyOvertimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'legacyOvertimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'legacyOvertimeRate',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyOvertimeRateBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'legacyOvertimeRate',
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
  legacyWorkScheduleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'legacyWorkSchedule'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'legacyWorkSchedule'),
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'legacyWorkSchedule',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyWorkSchedule', 0, true, 0, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyWorkSchedule', 0, false, 999999, true);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'legacyWorkSchedule', 0, true, length, include);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'legacyWorkSchedule',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'legacyWorkSchedule',
        lower,
        includeLower,
        upper,
        includeUpper,
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
}

extension ProfileModelQueryObject
    on QueryBuilder<ProfileModel, ProfileModel, QFilterCondition> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyAdjustmentsElement(FilterQuery<SalaryAdjustment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'legacyAdjustments');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterFilterCondition>
  legacyWorkScheduleElement(FilterQuery<WorkDayConfig> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'legacyWorkSchedule');
    });
  }
}

extension ProfileModelQueryLinks
    on QueryBuilder<ProfileModel, ProfileModel, QFilterCondition> {}

extension ProfileModelQuerySortBy
    on QueryBuilder<ProfileModel, ProfileModel, QSortBy> {
  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByActiveCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeCompanyId', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByActiveCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeCompanyId', Sort.desc);
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyBaseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyBaseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyCompanyName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyCompanyName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyEmploymentStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyEmploymentStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyHourlyRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyHourlyRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyJobTitle', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyJobTitle', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyOvertimeRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  sortByLegacyOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyOvertimeRate', Sort.desc);
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
  thenByActiveCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeCompanyId', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByActiveCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'activeCompanyId', Sort.desc);
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

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyBaseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyBaseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyCompanyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyCompanyName', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyCompanyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyCompanyName', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyEmploymentStartDate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyEmploymentStartDate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyHourlyRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyHourlyRate', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyJobTitle', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyJobTitle', Sort.desc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyOvertimeRate', Sort.asc);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QAfterSortBy>
  thenByLegacyOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyOvertimeRate', Sort.desc);
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
  distinctByActiveCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'activeCompanyId');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByCurrency({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByFullName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fullName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByLegacyBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyBaseMonthlySalary');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByLegacyCompanyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'legacyCompanyName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByLegacyEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyEmploymentStartDate');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByLegacyHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyHourlyRate');
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct> distinctByLegacyJobTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'legacyJobTitle',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<ProfileModel, ProfileModel, QDistinct>
  distinctByLegacyOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyOvertimeRate');
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

  QueryBuilder<ProfileModel, int?, QQueryOperations> activeCompanyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'activeCompanyId');
    });
  }

  QueryBuilder<ProfileModel, String?, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<ProfileModel, String, QQueryOperations> fullNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fullName');
    });
  }

  QueryBuilder<ProfileModel, List<SalaryAdjustment>?, QQueryOperations>
  legacyAdjustmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyAdjustments');
    });
  }

  QueryBuilder<ProfileModel, double?, QQueryOperations>
  legacyBaseMonthlySalaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyBaseMonthlySalary');
    });
  }

  QueryBuilder<ProfileModel, String?, QQueryOperations>
  legacyCompanyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyCompanyName');
    });
  }

  QueryBuilder<ProfileModel, DateTime?, QQueryOperations>
  legacyEmploymentStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyEmploymentStartDate');
    });
  }

  QueryBuilder<ProfileModel, double?, QQueryOperations>
  legacyHourlyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyHourlyRate');
    });
  }

  QueryBuilder<ProfileModel, String?, QQueryOperations>
  legacyJobTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyJobTitle');
    });
  }

  QueryBuilder<ProfileModel, double?, QQueryOperations>
  legacyOvertimeRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyOvertimeRate');
    });
  }

  QueryBuilder<ProfileModel, List<WorkDayConfig>?, QQueryOperations>
  legacyWorkScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyWorkSchedule');
    });
  }

  QueryBuilder<ProfileModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
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
