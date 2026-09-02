// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_limit_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBudgetLimitModelCollection on Isar {
  IsarCollection<BudgetLimitModel> get budgetLimitModels => this.collection();
}

const BudgetLimitModelSchema = CollectionSchema(
  name: r'BudgetLimitModel',
  id: -7304577755970098597,
  properties: {
    r'categoryName': PropertySchema(
      id: 0,
      name: r'categoryName',
      type: IsarType.string,
    ),
    r'companyId': PropertySchema(
      id: 1,
      name: r'companyId',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'isActive': PropertySchema(id: 3, name: r'isActive', type: IsarType.bool),
    r'monthlyLimit': PropertySchema(
      id: 4,
      name: r'monthlyLimit',
      type: IsarType.double,
    ),
    r'updatedAt': PropertySchema(
      id: 5,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
  },

  estimateSize: _budgetLimitModelEstimateSize,
  serialize: _budgetLimitModelSerialize,
  deserialize: _budgetLimitModelDeserialize,
  deserializeProp: _budgetLimitModelDeserializeProp,
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
    r'categoryName': IndexSchema(
      id: -7528967714848594133,
      name: r'categoryName',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'categoryName',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _budgetLimitModelGetId,
  getLinks: _budgetLimitModelGetLinks,
  attach: _budgetLimitModelAttach,
  version: '3.3.0-dev.1',
);

int _budgetLimitModelEstimateSize(
  BudgetLimitModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryName.length * 3;
  return bytesCount;
}

void _budgetLimitModelSerialize(
  BudgetLimitModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryName);
  writer.writeLong(offsets[1], object.companyId);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeBool(offsets[3], object.isActive);
  writer.writeDouble(offsets[4], object.monthlyLimit);
  writer.writeDateTime(offsets[5], object.updatedAt);
}

BudgetLimitModel _budgetLimitModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BudgetLimitModel();
  object.categoryName = reader.readString(offsets[0]);
  object.companyId = reader.readLong(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.id = id;
  object.isActive = reader.readBool(offsets[3]);
  object.monthlyLimit = reader.readDouble(offsets[4]);
  object.updatedAt = reader.readDateTime(offsets[5]);
  return object;
}

P _budgetLimitModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _budgetLimitModelGetId(BudgetLimitModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _budgetLimitModelGetLinks(BudgetLimitModel object) {
  return [];
}

void _budgetLimitModelAttach(
  IsarCollection<dynamic> col,
  Id id,
  BudgetLimitModel object,
) {
  object.id = id;
}

extension BudgetLimitModelQueryWhereSort
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QWhere> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhere> anyCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'companyId'),
      );
    });
  }
}

extension BudgetLimitModelQueryWhere
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QWhereClause> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
  idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
  idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause> idBetween(
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
  companyIdEqualTo(int companyId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'companyId', value: [companyId]),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
  categoryNameEqualTo(String categoryName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'categoryName',
          value: [categoryName],
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterWhereClause>
  categoryNameNotEqualTo(String categoryName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryName',
                lower: [],
                upper: [categoryName],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryName',
                lower: [categoryName],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryName',
                lower: [categoryName],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'categoryName',
                lower: [],
                upper: [categoryName],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension BudgetLimitModelQueryFilter
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QFilterCondition> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryName', value: ''),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  categoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryName', value: ''),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  companyIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'companyId', value: value),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  monthlyLimitEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'monthlyLimit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  monthlyLimitGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'monthlyLimit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  monthlyLimitLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'monthlyLimit',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  monthlyLimitBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'monthlyLimit',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
  updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'updatedAt', value: value),
      );
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterFilterCondition>
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

extension BudgetLimitModelQueryObject
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QFilterCondition> {}

extension BudgetLimitModelQueryLinks
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QFilterCondition> {}

extension BudgetLimitModelQuerySortBy
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QSortBy> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByMonthlyLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyLimit', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByMonthlyLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyLimit', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BudgetLimitModelQuerySortThenBy
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QSortThenBy> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCompanyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'companyId', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByMonthlyLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyLimit', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByMonthlyLimitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'monthlyLimit', Sort.desc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QAfterSortBy>
  thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension BudgetLimitModelQueryWhereDistinct
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct> {
  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByCategoryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByCompanyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'companyId');
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByMonthlyLimit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'monthlyLimit');
    });
  }

  QueryBuilder<BudgetLimitModel, BudgetLimitModel, QDistinct>
  distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension BudgetLimitModelQueryProperty
    on QueryBuilder<BudgetLimitModel, BudgetLimitModel, QQueryProperty> {
  QueryBuilder<BudgetLimitModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BudgetLimitModel, String, QQueryOperations>
  categoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryName');
    });
  }

  QueryBuilder<BudgetLimitModel, int, QQueryOperations> companyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'companyId');
    });
  }

  QueryBuilder<BudgetLimitModel, DateTime, QQueryOperations>
  createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<BudgetLimitModel, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<BudgetLimitModel, double, QQueryOperations>
  monthlyLimitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'monthlyLimit');
    });
  }

  QueryBuilder<BudgetLimitModel, DateTime, QQueryOperations>
  updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
