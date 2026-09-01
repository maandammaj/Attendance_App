// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAttendanceModelCollection on Isar {
  IsarCollection<AttendanceModel> get attendanceModels => this.collection();
}

const AttendanceModelSchema = CollectionSchema(
  name: r'AttendanceModel',
  id: -8601204094621324448,
  properties: {
    r'checkIn': PropertySchema(
      id: 0,
      name: r'checkIn',
      type: IsarType.dateTime,
    ),
    r'checkOut': PropertySchema(
      id: 1,
      name: r'checkOut',
      type: IsarType.dateTime,
    ),
    r'companyId': PropertySchema(
      id: 2,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'date': PropertySchema(id: 3, name: r'date', type: IsarType.dateTime),
    r'dayType': PropertySchema(
      id: 4,
      name: r'dayType',
      type: IsarType.byte,
      enumMap: _AttendanceModeldayTypeEnumValueMap,
    ),
    r'deficitHours': PropertySchema(
      id: 5,
      name: r'deficitHours',
      type: IsarType.long,
    ),
    r'deficitMinutes': PropertySchema(
      id: 6,
      name: r'deficitMinutes',
      type: IsarType.long,
    ),
    r'deficitValue': PropertySchema(
      id: 7,
      name: r'deficitValue',
      type: IsarType.double,
    ),
    r'isAbsent': PropertySchema(id: 8, name: r'isAbsent', type: IsarType.bool),
    r'isBiometricVerified': PropertySchema(
      id: 9,
      name: r'isBiometricVerified',
      type: IsarType.bool,
    ),
    r'isOpen': PropertySchema(id: 10, name: r'isOpen', type: IsarType.bool),
    r'notes': PropertySchema(id: 11, name: r'notes', type: IsarType.string),
    r'overtimeHours': PropertySchema(
      id: 12,
      name: r'overtimeHours',
      type: IsarType.long,
    ),
    r'overtimeMinutes': PropertySchema(
      id: 13,
      name: r'overtimeMinutes',
      type: IsarType.long,
    ),
    r'overtimeValue': PropertySchema(
      id: 14,
      name: r'overtimeValue',
      type: IsarType.double,
    ),
    r'requiredHours': PropertySchema(
      id: 15,
      name: r'requiredHours',
      type: IsarType.long,
    ),
    r'requiredMinutes': PropertySchema(
      id: 16,
      name: r'requiredMinutes',
      type: IsarType.long,
    ),
    r'sessionCount': PropertySchema(
      id: 17,
      name: r'sessionCount',
      type: IsarType.long,
    ),
    r'sessions': PropertySchema(
      id: 18,
      name: r'sessions',
      type: IsarType.objectList,

      target: r'WorkSession',
    ),
    r'totalPresenceMinutes': PropertySchema(
      id: 19,
      name: r'totalPresenceMinutes',
      type: IsarType.long,
    ),
    r'workedHours': PropertySchema(
      id: 20,
      name: r'workedHours',
      type: IsarType.long,
    ),
    r'workedMinutes': PropertySchema(
      id: 21,
      name: r'workedMinutes',
      type: IsarType.long,
    ),
  },

  estimateSize: _attendanceModelEstimateSize,
  serialize: _attendanceModelSerialize,
  deserialize: _attendanceModelDeserialize,
  deserializeProp: _attendanceModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'companyId': IndexSchema(
      id: 482756417767355356,
      name: r'companyId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'companyId',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
    r'isOpen': IndexSchema(
      id: -7174700296139425417,
      name: r'isOpen',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isOpen',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {r'WorkSession': WorkSessionSchema},

  getId: _attendanceModelGetId,
  getLinks: _attendanceModelGetLinks,
  attach: _attendanceModelAttach,
  version: '3.3.0-dev.1',
);

int _attendanceModelEstimateSize(
  AttendanceModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.sessions.length * 3;
  {
    final offsets = allOffsets[WorkSession]!;
    for (var i = 0; i < object.sessions.length; i++) {
      final value = object.sessions[i];
      bytesCount += WorkSessionSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _attendanceModelSerialize(
  AttendanceModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.checkIn);
  writer.writeDateTime(offsets[1], object.checkOut);
  writer.writeLong(offsets[2], object.companyId);
  writer.writeDateTime(offsets[3], object.date);
  writer.writeByte(offsets[4], object.dayType.index);
  writer.writeLong(offsets[5], object.deficitHours);
  writer.writeLong(offsets[6], object.deficitMinutes);
  writer.writeDouble(offsets[7], object.deficitValue);
  writer.writeBool(offsets[8], object.isAbsent);
  writer.writeBool(offsets[9], object.isBiometricVerified);
  writer.writeBool(offsets[10], object.isOpen);
  writer.writeString(offsets[11], object.notes);
  writer.writeLong(offsets[12], object.overtimeHours);
  writer.writeLong(offsets[13], object.overtimeMinutes);
  writer.writeDouble(offsets[14], object.overtimeValue);
  writer.writeLong(offsets[15], object.requiredHours);
  writer.writeLong(offsets[16], object.requiredMinutes);
  writer.writeLong(offsets[17], object.sessionCount);
  writer.writeObjectList<WorkSession>(
    offsets[18],
    allOffsets,
    WorkSessionSchema.serialize,
    object.sessions,
  );
  writer.writeLong(offsets[19], object.totalPresenceMinutes);
  writer.writeLong(offsets[20], object.workedHours);
  writer.writeLong(offsets[21], object.workedMinutes);
}

AttendanceModel _attendanceModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AttendanceModel();
  object.checkIn = reader.readDateTimeOrNull(offsets[0]);
  object.checkOut = reader.readDateTimeOrNull(offsets[1]);
  object.companyId = reader.readLong(offsets[2]);
  object.date = reader.readDateTime(offsets[3]);
  object.dayType =
      _AttendanceModeldayTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      DayType.regular;
  object.deficitHours = reader.readLong(offsets[5]);
  object.deficitMinutes = reader.readLong(offsets[6]);
  object.deficitValue = reader.readDouble(offsets[7]);
  object.id = id;
  object.isAbsent = reader.readBool(offsets[8]);
  object.isBiometricVerified = reader.readBool(offsets[9]);
  object.isOpen = reader.readBool(offsets[10]);
  object.notes = reader.readStringOrNull(offsets[11]);
  object.overtimeHours = reader.readLong(offsets[12]);
  object.overtimeMinutes = reader.readLong(offsets[13]);
  object.overtimeValue = reader.readDouble(offsets[14]);
  object.requiredHours = reader.readLong(offsets[15]);
  object.requiredMinutes = reader.readLong(offsets[16]);
  object.sessionCount = reader.readLong(offsets[17]);
  object.sessions =
      reader.readObjectList<WorkSession>(
        offsets[18],
        WorkSessionSchema.deserialize,
        allOffsets,
        WorkSession(),
      ) ??
      [];
  object.totalPresenceMinutes = reader.readLong(offsets[19]);
  object.workedHours = reader.readLong(offsets[20]);
  object.workedMinutes = reader.readLong(offsets[21]);
  return object;
}

P _attendanceModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_AttendanceModeldayTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              DayType.regular)
          as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readLong(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readObjectList<WorkSession>(
                offset,
                WorkSessionSchema.deserialize,
                allOffsets,
                WorkSession(),
              ) ??
              [])
          as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readLong(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AttendanceModeldayTypeEnumValueMap = {
  'regular': 0,
  'thursday': 1,
  'friday': 2,
  'holiday': 3,
  'custom': 4,
};
const _AttendanceModeldayTypeValueEnumMap = {
  0: DayType.regular,
  1: DayType.thursday,
  2: DayType.friday,
  3: DayType.holiday,
  4: DayType.custom,
};

Id _attendanceModelGetId(AttendanceModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _attendanceModelGetLinks(AttendanceModel object) {
  return [];
}

void _attendanceModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  AttendanceModel object,
) {
  object.id = id;
}

extension AttendanceModelQueryWhereSort
    on QueryBuilder<AttendanceModel, AttendanceModel, QWhere> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhere> anyCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'companyId'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhere> anyIsOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isOpen'),
      );
    });
  }
}

extension AttendanceModelQueryWhere
    on QueryBuilder<AttendanceModel, AttendanceModel, QWhereClause> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  companyIdEqualTo(int companyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'companyId', value: [companyId]),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  companyIdNotEqualTo(int companyId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companyId',
                lower: [],
                upper: [companyId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companyId',
                lower: [companyId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companyId',
                lower: [companyId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'companyId',
                lower: [],
                upper: [companyId],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  companyIdGreaterThan(int companyId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'companyId',
          lower: [companyId],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  companyIdLessThan(int companyId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'companyId',
          lower: [],
          upper: [companyId],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  companyIdBetween(
    int lowerCompanyId,
    int upperCompanyId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'companyId',
          lower: [lowerCompanyId],
          includeLower: includeLower,
          upper: [upperCompanyId],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> dateEqualTo(
    DateTime date,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'date', value: [date]),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  dateNotEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [date],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'date',
                lower: [],
                upper: [date],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  dateGreaterThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [date],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  dateLessThan(DateTime date, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [],
          upper: [date],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'date',
          lower: [lowerDate],
          includeLower: includeLower,
          upper: [upperDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  isOpenEqualTo(bool isOpen) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'isOpen', value: [isOpen]),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterWhereClause>
  isOpenNotEqualTo(bool isOpen) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isOpen',
                lower: [],
                upper: [isOpen],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isOpen',
                lower: [isOpen],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isOpen',
                lower: [isOpen],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'isOpen',
                lower: [],
                upper: [isOpen],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension AttendanceModelQueryFilter
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkIn', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkInBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkIn',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkOut', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  checkOutBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkOut',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  companyIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'companyId', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  companyIdGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'companyId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  companyIdLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'companyId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  companyIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'companyId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'date',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'date',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dayTypeEqualTo(DayType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayType', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dayTypeGreaterThan(DayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dayTypeLessThan(DayType value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  dayTypeBetween(
    DayType lower,
    DayType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deficitHours', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitHoursGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deficitHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitHoursLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deficitHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deficitHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'deficitMinutes', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deficitMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deficitMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deficitMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitValueEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'deficitValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'deficitValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'deficitValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  deficitValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'deficitValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  isAbsentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isAbsent', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  isBiometricVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isBiometricVerified', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  isOpenEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isOpen', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'notes'),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'overtimeHours', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeHoursGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'overtimeHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeHoursLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'overtimeHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'overtimeHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'overtimeMinutes', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'overtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'overtimeMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'overtimeMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeValueEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'overtimeValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeValueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'overtimeValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeValueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'overtimeValue',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  overtimeValueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'overtimeValue',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  requiredHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'requiredHours', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  requiredMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'requiredMinutes', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
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

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionCount', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionCountGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionCountLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sessions', length, true, length, true);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sessions', 0, true, 0, true);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sessions', 0, false, 999999, true);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sessions', 0, true, length, include);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'sessions', length, include, 999999, true);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'sessions',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  totalPresenceMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalPresenceMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  totalPresenceMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalPresenceMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  totalPresenceMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalPresenceMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  totalPresenceMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalPresenceMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workedHours', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedHoursGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workedHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedHoursLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workedHours',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workedHours',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workedMinutes', value: value),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workedMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  workedMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workedMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension AttendanceModelQueryObject
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterFilterCondition>
  sessionsElement(FilterQuery<WorkSession> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sessions');
    });
  }
}

extension AttendanceModelQueryLinks
    on QueryBuilder<AttendanceModel, AttendanceModel, QFilterCondition> {}

extension AttendanceModelQuerySortBy
    on QueryBuilder<AttendanceModel, AttendanceModel, QSortBy> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByCheckOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByDayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitValue', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByDeficitValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitValue', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByIsAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbsent', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByIsAbsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbsent', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByIsBiometricVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricVerified', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByIsBiometricVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricVerified', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByIsOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpen', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByIsOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpen', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeValue', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByOvertimeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeValue', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByRequiredHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByRequiredHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByRequiredMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByRequiredMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByTotalPresenceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresenceMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByTotalPresenceMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresenceMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByWorkedHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByWorkedHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByWorkedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  sortByWorkedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedMinutes', Sort.desc);
    });
  }
}

extension AttendanceModelQuerySortThenBy
    on QueryBuilder<AttendanceModel, AttendanceModel, QSortThenBy> {
  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByCheckInDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkIn', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByCheckOutDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checkOut', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByDayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDayTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayType', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitValue', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByDeficitValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deficitValue', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByIsAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbsent', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByIsAbsentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAbsent', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByIsBiometricVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricVerified', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByIsBiometricVerifiedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBiometricVerified', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByIsOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpen', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByIsOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isOpen', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeValue', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByOvertimeValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overtimeValue', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByRequiredHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByRequiredHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByRequiredMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByRequiredMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'requiredMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenBySessionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionCount', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByTotalPresenceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresenceMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByTotalPresenceMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalPresenceMinutes', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByWorkedHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedHours', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByWorkedHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedHours', Sort.desc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByWorkedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedMinutes', Sort.asc);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QAfterSortBy>
  thenByWorkedMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workedMinutes', Sort.desc);
    });
  }
}

extension AttendanceModelQueryWhereDistinct
    on QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> {
  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByCheckIn() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkIn');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByCheckOut() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checkOut');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByDayType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayType');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByDeficitHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deficitHours');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByDeficitMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deficitMinutes');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByDeficitValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deficitValue');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByIsAbsent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAbsent');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByIsBiometricVerified() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBiometricVerified');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByIsOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isOpen');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct> distinctByNotes({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByOvertimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeHours');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByOvertimeMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeMinutes');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByOvertimeValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overtimeValue');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByRequiredHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requiredHours');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByRequiredMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'requiredMinutes');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctBySessionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionCount');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByTotalPresenceMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalPresenceMinutes');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByWorkedHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workedHours');
    });
  }

  QueryBuilder<AttendanceModel, AttendanceModel, QDistinct>
  distinctByWorkedMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workedMinutes');
    });
  }
}

extension AttendanceModelQueryProperty
    on QueryBuilder<AttendanceModel, AttendanceModel, QQueryProperty> {
  QueryBuilder<AttendanceModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AttendanceModel, DateTime?, QQueryOperations> checkInProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkIn');
    });
  }

  QueryBuilder<AttendanceModel, DateTime?, QQueryOperations>
  checkOutProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checkOut');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<AttendanceModel, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<AttendanceModel, DayType, QQueryOperations> dayTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayType');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> deficitHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deficitHours');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations>
  deficitMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deficitMinutes');
    });
  }

  QueryBuilder<AttendanceModel, double, QQueryOperations>
  deficitValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deficitValue');
    });
  }

  QueryBuilder<AttendanceModel, bool, QQueryOperations> isAbsentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAbsent');
    });
  }

  QueryBuilder<AttendanceModel, bool, QQueryOperations>
  isBiometricVerifiedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBiometricVerified');
    });
  }

  QueryBuilder<AttendanceModel, bool, QQueryOperations> isOpenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isOpen');
    });
  }

  QueryBuilder<AttendanceModel, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> overtimeHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeHours');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations>
  overtimeMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeMinutes');
    });
  }

  QueryBuilder<AttendanceModel, double, QQueryOperations>
  overtimeValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overtimeValue');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> requiredHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requiredHours');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations>
  requiredMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'requiredMinutes');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> sessionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionCount');
    });
  }

  QueryBuilder<AttendanceModel, List<WorkSession>, QQueryOperations>
  sessionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessions');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations>
  totalPresenceMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalPresenceMinutes');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> workedHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workedHours');
    });
  }

  QueryBuilder<AttendanceModel, int, QQueryOperations> workedMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workedMinutes');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const WorkSessionSchema = Schema(
  name: r'WorkSession',
  id: -4393819405090026064,
  properties: {
    r'checkIn': PropertySchema(
      id: 0,
      name: r'checkIn',
      type: IsarType.dateTime,
    ),
    r'checkOut': PropertySchema(
      id: 1,
      name: r'checkOut',
      type: IsarType.dateTime,
    ),
    r'isBiometricVerified': PropertySchema(
      id: 2,
      name: r'isBiometricVerified',
      type: IsarType.bool,
    ),
    r'note': PropertySchema(id: 3, name: r'note', type: IsarType.string),
  },

  estimateSize: _workSessionEstimateSize,
  serialize: _workSessionSerialize,
  deserialize: _workSessionDeserialize,
  deserializeProp: _workSessionDeserializeProp,
);

int _workSessionEstimateSize(
  WorkSession object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.note;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _workSessionSerialize(
  WorkSession object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.checkIn);
  writer.writeDateTime(offsets[1], object.checkOut);
  writer.writeBool(offsets[2], object.isBiometricVerified);
  writer.writeString(offsets[3], object.note);
}

WorkSession _workSessionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WorkSession();
  object.checkIn = reader.readDateTimeOrNull(offsets[0]);
  object.checkOut = reader.readDateTimeOrNull(offsets[1]);
  object.isBiometricVerified = reader.readBool(offsets[2]);
  object.note = reader.readStringOrNull(offsets[3]);
  return object;
}

P _workSessionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension WorkSessionQueryFilter
    on QueryBuilder<WorkSession, WorkSession, QFilterCondition> {
  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkInIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkInIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkIn'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> checkInEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkIn', value: value),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkInGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> checkInLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkIn',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> checkInBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkIn',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkOutIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkOutIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'checkOut'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> checkOutEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'checkOut', value: value),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkOutGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  checkOutLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'checkOut',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> checkOutBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'checkOut',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  isBiometricVerifiedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isBiometricVerified', value: value),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'note',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'note',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'note',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition> noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<WorkSession, WorkSession, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }
}

extension WorkSessionQueryObject
    on QueryBuilder<WorkSession, WorkSession, QFilterCondition> {}
