// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDebtModelCollection on Isar {
  IsarCollection<DebtModel> get debtModels => this.collection();
}

const DebtModelSchema = CollectionSchema(
  name: r'DebtModel',
  id: 7879871328374011369,
  properties: {
    r'accountId': PropertySchema(
      id: 0,
      name: r'accountId',
      type: IsarType.long,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 2,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'debtType': PropertySchema(
      id: 4,
      name: r'debtType',
      type: IsarType.byte,
      enumMap: _DebtModeldebtTypeEnumValueMap,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'dueDate': PropertySchema(
      id: 6,
      name: r'dueDate',
      type: IsarType.dateTime,
    ),
    r'hasReminder': PropertySchema(
      id: 7,
      name: r'hasReminder',
      type: IsarType.bool,
    ),
    r'lastPaymentDate': PropertySchema(
      id: 8,
      name: r'lastPaymentDate',
      type: IsarType.dateTime,
    ),
    r'paidAmount': PropertySchema(
      id: 9,
      name: r'paidAmount',
      type: IsarType.double,
    ),
    r'paymentHistory': PropertySchema(
      id: 10,
      name: r'paymentHistory',
      type: IsarType.objectList,

      target: r'PaymentRecord',
    ),
    r'personAvatar': PropertySchema(
      id: 11,
      name: r'personAvatar',
      type: IsarType.string,
    ),
    r'personName': PropertySchema(
      id: 12,
      name: r'personName',
      type: IsarType.string,
    ),
    r'personPhone': PropertySchema(
      id: 13,
      name: r'personPhone',
      type: IsarType.string,
    ),
    r'remainingAmount': PropertySchema(
      id: 14,
      name: r'remainingAmount',
      type: IsarType.double,
    ),
    r'reminderDate': PropertySchema(
      id: 15,
      name: r'reminderDate',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 16,
      name: r'status',
      type: IsarType.byte,
      enumMap: _DebtModelstatusEnumValueMap,
    ),
    r'totalAmount': PropertySchema(
      id: 17,
      name: r'totalAmount',
      type: IsarType.double,
    ),
  },

  estimateSize: _debtModelEstimateSize,
  serialize: _debtModelSerialize,
  deserialize: _debtModelDeserialize,
  deserializeProp: _debtModelDeserializeProp,
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
  },
  links: {},
  embeddedSchemas: {r'PaymentRecord': PaymentRecordSchema},

  getId: _debtModelGetId,
  getLinks: _debtModelGetLinks,
  attach: _debtModelAttach,
  version: '3.3.0-dev.1',
);

int _debtModelEstimateSize(
  DebtModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.category;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.paymentHistory;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        final offsets = allOffsets[PaymentRecord]!;
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += PaymentRecordSchema.estimateSize(
            value,
            offsets,
            allOffsets,
          );
        }
      }
    }
  }
  {
    final value = object.personAvatar;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.personName.length * 3;
  {
    final value = object.personPhone;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _debtModelSerialize(
  DebtModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.accountId);
  writer.writeString(offsets[1], object.category);
  writer.writeLong(offsets[2], object.companyId);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeByte(offsets[4], object.debtType.index);
  writer.writeString(offsets[5], object.description);
  writer.writeDateTime(offsets[6], object.dueDate);
  writer.writeBool(offsets[7], object.hasReminder);
  writer.writeDateTime(offsets[8], object.lastPaymentDate);
  writer.writeDouble(offsets[9], object.paidAmount);
  writer.writeObjectList<PaymentRecord>(
    offsets[10],
    allOffsets,
    PaymentRecordSchema.serialize,
    object.paymentHistory,
  );
  writer.writeString(offsets[11], object.personAvatar);
  writer.writeString(offsets[12], object.personName);
  writer.writeString(offsets[13], object.personPhone);
  writer.writeDouble(offsets[14], object.remainingAmount);
  writer.writeDateTime(offsets[15], object.reminderDate);
  writer.writeByte(offsets[16], object.status.index);
  writer.writeDouble(offsets[17], object.totalAmount);
}

DebtModel _debtModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DebtModel();
  object.accountId = reader.readLongOrNull(offsets[0]);
  object.category = reader.readStringOrNull(offsets[1]);
  object.companyId = reader.readLong(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.debtType =
      _DebtModeldebtTypeValueEnumMap[reader.readByteOrNull(offsets[4])] ??
      DebtType.owe;
  object.description = reader.readStringOrNull(offsets[5]);
  object.dueDate = reader.readDateTimeOrNull(offsets[6]);
  object.hasReminder = reader.readBoolOrNull(offsets[7]);
  object.id = id;
  object.lastPaymentDate = reader.readDateTimeOrNull(offsets[8]);
  object.paidAmount = reader.readDouble(offsets[9]);
  object.paymentHistory = reader.readObjectList<PaymentRecord>(
    offsets[10],
    PaymentRecordSchema.deserialize,
    allOffsets,
    PaymentRecord(),
  );
  object.personAvatar = reader.readStringOrNull(offsets[11]);
  object.personName = reader.readString(offsets[12]);
  object.personPhone = reader.readStringOrNull(offsets[13]);
  object.remainingAmount = reader.readDouble(offsets[14]);
  object.reminderDate = reader.readDateTimeOrNull(offsets[15]);
  object.status =
      _DebtModelstatusValueEnumMap[reader.readByteOrNull(offsets[16])] ??
      DebtStatus.active;
  object.totalAmount = reader.readDouble(offsets[17]);
  return object;
}

P _debtModelDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (_DebtModeldebtTypeValueEnumMap[reader.readByteOrNull(offset)] ??
              DebtType.owe)
          as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readBoolOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readObjectList<PaymentRecord>(
            offset,
            PaymentRecordSchema.deserialize,
            allOffsets,
            PaymentRecord(),
          ))
          as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (_DebtModelstatusValueEnumMap[reader.readByteOrNull(offset)] ??
              DebtStatus.active)
          as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DebtModeldebtTypeEnumValueMap = {'owe': 0, 'owed': 1};
const _DebtModeldebtTypeValueEnumMap = {0: DebtType.owe, 1: DebtType.owed};
const _DebtModelstatusEnumValueMap = {
  'active': 0,
  'partiallyPaid': 1,
  'paid': 2,
  'overdue': 3,
};
const _DebtModelstatusValueEnumMap = {
  0: DebtStatus.active,
  1: DebtStatus.partiallyPaid,
  2: DebtStatus.paid,
  3: DebtStatus.overdue,
};

Id _debtModelGetId(DebtModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _debtModelGetLinks(DebtModel object) {
  return [];
}

void _debtModelAttach(IsarCollection<dynamic> col, Id id, DebtModel object) {
  object.id = id;
}

extension DebtModelQueryWhereSort
    on QueryBuilder<DebtModel, DebtModel, QWhere> {
  QueryBuilder<DebtModel, DebtModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterWhere> anyCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'companyId'),
      );
    });
  }
}

extension DebtModelQueryWhere
    on QueryBuilder<DebtModel, DebtModel, QWhereClause> {
  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> companyIdEqualTo(
    int companyId,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'companyId', value: [companyId]),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> companyIdNotEqualTo(
    int companyId,
  ) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> companyIdGreaterThan(
    int companyId, {
    bool include = false,
  }) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> companyIdLessThan(
    int companyId, {
    bool include = false,
  }) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterWhereClause> companyIdBetween(
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
}

extension DebtModelQueryFilter
    on QueryBuilder<DebtModel, DebtModel, QFilterCondition> {
  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> accountIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'accountId'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  accountIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'accountId'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> accountIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'accountId', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  accountIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'accountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> accountIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'accountId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> accountIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'accountId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'category'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  categoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'category'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> companyIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'companyId', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> companyIdLessThan(
    int value, {
    bool include = false,
  }) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> companyIdBetween(
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> debtTypeEqualTo(
    DebtType value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'debtType', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> debtTypeGreaterThan(
    DebtType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'debtType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> debtTypeLessThan(
    DebtType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'debtType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> debtTypeBetween(
    DebtType lower,
    DebtType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'debtType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'description'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'description'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> descriptionMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'dueDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'dueDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dueDate', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dueDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> dueDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dueDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  hasReminderIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'hasReminder'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  hasReminderIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'hasReminder'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> hasReminderEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'hasReminder', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPaymentDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPaymentDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPaymentDate', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPaymentDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPaymentDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  lastPaymentDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPaymentDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> paidAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'paidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paidAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'paidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> paidAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'paidAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> paidAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'paidAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'paymentHistory'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'paymentHistory'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'paymentHistory', length, true, length, true);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'paymentHistory', 0, true, 0, true);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'paymentHistory', 0, false, 999999, true);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'paymentHistory', 0, true, length, include);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'paymentHistory', length, include, 999999, true);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'paymentHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personAvatar'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personAvatar'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personAvatarEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personAvatarBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'personAvatar',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'personAvatar',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personAvatarMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'personAvatar',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'personAvatar', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personAvatarIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'personAvatar', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'personName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'personName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personNameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'personName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'personName', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'personName', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'personPhone'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'personPhone'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'personPhone',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'personPhone',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> personPhoneMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'personPhone',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'personPhone', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  personPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'personPhone', value: ''),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  remainingAmountEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'remainingAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  remainingAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remainingAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  remainingAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remainingAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  remainingAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remainingAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  reminderDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'reminderDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  reminderDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'reminderDate'),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> reminderDateEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'reminderDate', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  reminderDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'reminderDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  reminderDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'reminderDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> reminderDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'reminderDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> statusEqualTo(
    DebtStatus value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'status', value: value),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> statusGreaterThan(
    DebtStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> statusLessThan(
    DebtStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'status',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> statusBetween(
    DebtStatus lower,
    DebtStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'status',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> totalAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  totalAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> totalAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalAmount',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition> totalAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalAmount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }
}

extension DebtModelQueryObject
    on QueryBuilder<DebtModel, DebtModel, QFilterCondition> {
  QueryBuilder<DebtModel, DebtModel, QAfterFilterCondition>
  paymentHistoryElement(FilterQuery<PaymentRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'paymentHistory');
    });
  }
}

extension DebtModelQueryLinks
    on QueryBuilder<DebtModel, DebtModel, QFilterCondition> {}

extension DebtModelQuerySortBy on QueryBuilder<DebtModel, DebtModel, QSortBy> {
  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDebtType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtType', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDebtTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtType', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByHasReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReminder', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByHasReminderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReminder', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByLastPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personAvatar', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personAvatar', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personPhone', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByPersonPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personPhone', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByRemainingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByReminderDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> sortByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension DebtModelQuerySortThenBy
    on QueryBuilder<DebtModel, DebtModel, QSortThenBy> {
  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByAccountIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountId', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDebtType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtType', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDebtTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debtType', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByDueDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dueDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByHasReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReminder', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByHasReminderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasReminder', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByLastPaymentDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPaymentDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPaidAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paidAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonAvatar() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personAvatar', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonAvatarDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personAvatar', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personName', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personPhone', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByPersonPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'personPhone', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByRemainingAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingAmount', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByReminderDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reminderDate', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.asc);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QAfterSortBy> thenByTotalAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalAmount', Sort.desc);
    });
  }
}

extension DebtModelQueryWhereDistinct
    on QueryBuilder<DebtModel, DebtModel, QDistinct> {
  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByAccountId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountId');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByDebtType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debtType');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByDescription({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByDueDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dueDate');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByHasReminder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasReminder');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByLastPaymentDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPaymentDate');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByPaidAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paidAmount');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByPersonAvatar({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personAvatar', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByPersonName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByPersonPhone({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'personPhone', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByRemainingAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingAmount');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByReminderDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reminderDate');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DebtModel, DebtModel, QDistinct> distinctByTotalAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalAmount');
    });
  }
}

extension DebtModelQueryProperty
    on QueryBuilder<DebtModel, DebtModel, QQueryProperty> {
  QueryBuilder<DebtModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DebtModel, int?, QQueryOperations> accountIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountId');
    });
  }

  QueryBuilder<DebtModel, String?, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<DebtModel, int, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<DebtModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DebtModel, DebtType, QQueryOperations> debtTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debtType');
    });
  }

  QueryBuilder<DebtModel, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<DebtModel, DateTime?, QQueryOperations> dueDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dueDate');
    });
  }

  QueryBuilder<DebtModel, bool?, QQueryOperations> hasReminderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasReminder');
    });
  }

  QueryBuilder<DebtModel, DateTime?, QQueryOperations>
  lastPaymentDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPaymentDate');
    });
  }

  QueryBuilder<DebtModel, double, QQueryOperations> paidAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paidAmount');
    });
  }

  QueryBuilder<DebtModel, List<PaymentRecord>?, QQueryOperations>
  paymentHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentHistory');
    });
  }

  QueryBuilder<DebtModel, String?, QQueryOperations> personAvatarProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personAvatar');
    });
  }

  QueryBuilder<DebtModel, String, QQueryOperations> personNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personName');
    });
  }

  QueryBuilder<DebtModel, String?, QQueryOperations> personPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'personPhone');
    });
  }

  QueryBuilder<DebtModel, double, QQueryOperations> remainingAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingAmount');
    });
  }

  QueryBuilder<DebtModel, DateTime?, QQueryOperations> reminderDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reminderDate');
    });
  }

  QueryBuilder<DebtModel, DebtStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DebtModel, double, QQueryOperations> totalAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalAmount');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const PaymentRecordSchema = Schema(
  name: r'PaymentRecord',
  id: -157825587411876126,
  properties: {
    r'amount': PropertySchema(id: 0, name: r'amount', type: IsarType.double),
    r'date': PropertySchema(id: 1, name: r'date', type: IsarType.dateTime),
    r'note': PropertySchema(id: 2, name: r'note', type: IsarType.string),
  },

  estimateSize: _paymentRecordEstimateSize,
  serialize: _paymentRecordSerialize,
  deserialize: _paymentRecordDeserialize,
  deserializeProp: _paymentRecordDeserializeProp,
);

int _paymentRecordEstimateSize(
  PaymentRecord object,
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

void _paymentRecordSerialize(
  PaymentRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.note);
}

PaymentRecord _paymentRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PaymentRecord();
  object.amount = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.note = reader.readStringOrNull(offsets[2]);
  return object;
}

P _paymentRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension PaymentRecordQueryFilter
    on QueryBuilder<PaymentRecord, PaymentRecord, QFilterCondition> {
  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition> dateEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'date', value: value),
      );
    });
  }

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'note'),
      );
    });
  }

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'note'),
      );
    });
  }

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition> noteEqualTo(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteGreaterThan(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteLessThan(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition> noteBetween(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteStartsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteEndsWith(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition> noteMatches(
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

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'note', value: ''),
      );
    });
  }

  QueryBuilder<PaymentRecord, PaymentRecord, QAfterFilterCondition>
  noteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'note', value: ''),
      );
    });
  }
}

extension PaymentRecordQueryObject
    on QueryBuilder<PaymentRecord, PaymentRecord, QFilterCondition> {}
