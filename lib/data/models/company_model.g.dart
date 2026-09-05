// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCompanyModelCollection on Isar {
  IsarCollection<CompanyModel> get companyModels => this.collection();
}

const CompanyModelSchema = CollectionSchema(
  name: r'CompanyModel',
  id: -1827242308681231162,
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
    r'colorIndex': PropertySchema(
      id: 2,
      name: r'colorIndex',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currency': PropertySchema(
      id: 4,
      name: r'currency',
      type: IsarType.string,
    ),
    r'employmentStartDate': PropertySchema(
      id: 5,
      name: r'employmentStartDate',
      type: IsarType.dateTime,
    ),
    r'hourlyRate': PropertySchema(
      id: 6,
      name: r'hourlyRate',
      type: IsarType.double,
    ),
    r'isArchived': PropertySchema(
      id: 7,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'jobTitle': PropertySchema(
      id: 8,
      name: r'jobTitle',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 9, name: r'name', type: IsarType.string),
    r'overtimeRate': PropertySchema(
      id: 10,
      name: r'overtimeRate',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 11,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'workSchedule': PropertySchema(
      id: 12,
      name: r'workSchedule',
      type: IsarType.objectList,

      target: r'WorkDayConfig',
    ),
  },

  estimateSize: _companyModelEstimateSize,
  serialize: _companyModelSerialize,
  deserialize: _companyModelDeserialize,
  deserializeProp: _companyModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'isArchived': IndexSchema(
      id: 655844772568347876,
      name: r'isArchived',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isArchived',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'WorkDayConfig': WorkDayConfigSchema,
    r'SalaryAdjustment': SalaryAdjustmentSchema,
  },

  getId: _companyModelGetId,
  getLinks: _companyModelGetLinks,
  attach: _companyModelAttach,
  version: '3.3.2',
);

int _companyModelEstimateSize(
  CompanyModel object,
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
    final value = object.currency;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.jobTitle.length * 3;
  bytesCount += 3 + object.name.length * 3;
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

void _companyModelSerialize(
  CompanyModel object,
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
  writer.writeLong(offsets[2], object.colorIndex);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.currency);
  writer.writeDateTime(offsets[5], object.employmentStartDate);
  writer.writeDouble(offsets[6], object.hourlyRate);
  writer.writeBool(offsets[7], object.isArchived);
  writer.writeString(offsets[8], object.jobTitle);
  writer.writeString(offsets[9], object.name);
  writer.writeDouble(offsets[10], object.overtimeRate);
  writer.writeDateTime(offsets[11], object.updatedAt);
  writer.writeObjectList<WorkDayConfig>(
    offsets[12],
    allOffsets,
    WorkDayConfigSchema.serialize,
    object.workSchedule,
  );
}

CompanyModel _companyModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CompanyModel();
  object.adjustments =
      reader.readObjectList<SalaryAdjustment>(
        offsets[0],
        SalaryAdjustmentSchema.deserialize,
        allOffsets,
        SalaryAdjustment(),
      ) ??
      [];
  object.baseMonthlySalary = reader.readDouble(offsets[1]);
  object.colorIndex = reader.readLong(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.currency = reader.readStringOrNull(offsets[4]);
  object.employmentStartDate = reader.readDateTimeOrNull(offsets[5]);
  object.hourlyRate = reader.readDouble(offsets[6]);
  object.id = id;
  object.isArchived = reader.readBool(offsets[7]);
  object.jobTitle = reader.readString(offsets[8]);
  object.name = reader.readString(offsets[9]);
  object.overtimeRate = reader.readDouble(offsets[10]);
  object.updatedAt = reader.readDateTime(offsets[11]);
  object.workSchedule =
      reader.readObjectList<WorkDayConfig>(
        offsets[12],
        WorkDayConfigSchema.deserialize,
        allOffsets,
        WorkDayConfig(),
      ) ??
      [];
  return object;
}

P _companyModelDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    case 12:
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

Id _companyModelGetId(CompanyModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _companyModelGetLinks(CompanyModel object) {
  return [];
}

void _companyModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  CompanyModel object,
) {
  object.id = id;
}

extension CompanyModelQueryWhereSort
    on QueryBuilder<CompanyModel, CompanyModel, QWhere> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhere> anyIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isArchived'),
      );
    });
  }
}

extension CompanyModelQueryWhere
    on QueryBuilder<CompanyModel, CompanyModel, QWhereClause> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause> isArchivedEqualTo(
    bool isArchived,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isArchived', value: [isArchived]),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterWhereClause>
  isArchivedNotEqualTo(bool isArchived) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [],
                upper: [isArchived],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [isArchived],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [isArchived],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isArchived',
                lower: [],
                upper: [isArchived],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension CompanyModelQueryFilter
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', length, true, length, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, true, 0, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, false, 999999, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', 0, true, length, include);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'adjustments', length, include, 999999, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  colorIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'colorIndex', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  colorIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'colorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  colorIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'colorIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  colorIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'colorIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  createdAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  createdAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  currencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'currency'),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  currencyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'currency'),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'currency', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  employmentStartDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'employmentStartDate'),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  employmentStartDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'employmentStartDate'),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  employmentStartDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'employmentStartDate', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  jobTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'jobTitle', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  jobTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'jobTitle', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', length, true, length, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, true, 0, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, false, 999999, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', 0, true, length, include);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'workSchedule', length, include, 999999, true);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
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

extension CompanyModelQueryObject
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  adjustmentsElement(FilterQuery<SalaryAdjustment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'adjustments');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterFilterCondition>
  workScheduleElement(FilterQuery<WorkDayConfig> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'workSchedule');
    });
  }
}

extension CompanyModelQueryLinks
    on QueryBuilder<CompanyModel, CompanyModel, QFilterCondition> {}

extension CompanyModelQuerySortBy
    on QueryBuilder<CompanyModel, CompanyModel, QSortBy> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorIndex', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorIndex', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  sortByOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CompanyModelQuerySortThenBy
    on QueryBuilder<CompanyModel, CompanyModel, QSortThenBy> {
  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByBaseMonthlySalaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseMonthlySalary', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorIndex', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByColorIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorIndex', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByEmploymentStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'employmentStartDate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByHourlyRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hourlyRate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByJobTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByJobTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jobTitle', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy>
  thenByOvertimeRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeRate', Sort.desc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension CompanyModelQueryWhereDistinct
    on QueryBuilder<CompanyModel, CompanyModel, QDistinct> {
  QueryBuilder<CompanyModel, CompanyModel, QDistinct>
  distinctByBaseMonthlySalary() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseMonthlySalary');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByColorIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorIndex');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByCurrency({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct>
  distinctByEmploymentStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'employmentStartDate');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByHourlyRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hourlyRate');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByJobTitle({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jobTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByOvertimeRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeRate');
    });
  }

  QueryBuilder<CompanyModel, CompanyModel, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension CompanyModelQueryProperty
    on QueryBuilder<CompanyModel, CompanyModel, QQueryProperty> {
  QueryBuilder<CompanyModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CompanyModel, List<SalaryAdjustment>, QQueryOperations>
  adjustmentsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adjustments');
    });
  }

  QueryBuilder<CompanyModel, double, QQueryOperations>
  baseMonthlySalaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseMonthlySalary');
    });
  }

  QueryBuilder<CompanyModel, int, QQueryOperations> colorIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorIndex');
    });
  }

  QueryBuilder<CompanyModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<CompanyModel, String?, QQueryOperations> currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<CompanyModel, DateTime?, QQueryOperations>
  employmentStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'employmentStartDate');
    });
  }

  QueryBuilder<CompanyModel, double, QQueryOperations> hourlyRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hourlyRate');
    });
  }

  QueryBuilder<CompanyModel, bool, QQueryOperations> isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> jobTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jobTitle');
    });
  }

  QueryBuilder<CompanyModel, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<CompanyModel, double, QQueryOperations> overtimeRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeRate');
    });
  }

  QueryBuilder<CompanyModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<CompanyModel, List<WorkDayConfig>, QQueryOperations>
  workScheduleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workSchedule');
    });
  }
}
