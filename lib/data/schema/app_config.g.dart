// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppConfigCollection on Isar {
  IsarCollection<AppConfig> get appConfigs => this.collection();
}

const AppConfigSchema = CollectionSchema(
  name: r'AppConfig',
  id: -7085420701237142207,
  properties: {
    r'defaultConvAIProviderId': PropertySchema(
      id: 0,
      name: r'defaultConvAIProviderId',
      type: IsarType.long,
    ),
    r'defaultConvAIProviderModelId': PropertySchema(
      id: 1,
      name: r'defaultConvAIProviderModelId',
      type: IsarType.string,
    ),
    r'hapticFeedback': PropertySchema(
      id: 2,
      name: r'hapticFeedback',
      type: IsarType.bool,
    ),
    r'newConvUseLastModel': PropertySchema(
      id: 3,
      name: r'newConvUseLastModel',
      type: IsarType.bool,
    ),
    r'topicNamingAIProviderId': PropertySchema(
      id: 4,
      name: r'topicNamingAIProviderId',
      type: IsarType.long,
    ),
    r'topicNamingAIProviderModelId': PropertySchema(
      id: 5,
      name: r'topicNamingAIProviderModelId',
      type: IsarType.string,
    )
  },
  estimateSize: _appConfigEstimateSize,
  serialize: _appConfigSerialize,
  deserialize: _appConfigDeserialize,
  deserializeProp: _appConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appConfigGetId,
  getLinks: _appConfigGetLinks,
  attach: _appConfigAttach,
  version: '3.1.0+1',
);

int _appConfigEstimateSize(
  AppConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.defaultConvAIProviderModelId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.topicNamingAIProviderModelId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _appConfigSerialize(
  AppConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.defaultConvAIProviderId);
  writer.writeString(offsets[1], object.defaultConvAIProviderModelId);
  writer.writeBool(offsets[2], object.hapticFeedback);
  writer.writeBool(offsets[3], object.newConvUseLastModel);
  writer.writeLong(offsets[4], object.topicNamingAIProviderId);
  writer.writeString(offsets[5], object.topicNamingAIProviderModelId);
}

AppConfig _appConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppConfig();
  object.defaultConvAIProviderId = reader.readLongOrNull(offsets[0]);
  object.defaultConvAIProviderModelId = reader.readStringOrNull(offsets[1]);
  object.hapticFeedback = reader.readBool(offsets[2]);
  object.newConvUseLastModel = reader.readBool(offsets[3]);
  object.topicNamingAIProviderId = reader.readLongOrNull(offsets[4]);
  object.topicNamingAIProviderModelId = reader.readStringOrNull(offsets[5]);
  return object;
}

P _appConfigDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appConfigGetId(AppConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appConfigGetLinks(AppConfig object) {
  return [];
}

void _appConfigAttach(IsarCollection<dynamic> col, Id id, AppConfig object) {}

extension AppConfigQueryWhereSort
    on QueryBuilder<AppConfig, AppConfig, QWhere> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppConfigQueryWhere
    on QueryBuilder<AppConfig, AppConfig, QWhereClause> {
  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AppConfigQueryFilter
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {
  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultConvAIProviderId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultConvAIProviderId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultConvAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultConvAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultConvAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultConvAIProviderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'defaultConvAIProviderModelId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'defaultConvAIProviderModelId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultConvAIProviderModelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'defaultConvAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'defaultConvAIProviderModelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultConvAIProviderModelId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      defaultConvAIProviderModelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'defaultConvAIProviderModelId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      hapticFeedbackEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hapticFeedback',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      newConvUseLastModelEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'newConvUseLastModel',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topicNamingAIProviderId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topicNamingAIProviderId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicNamingAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topicNamingAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topicNamingAIProviderId',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topicNamingAIProviderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'topicNamingAIProviderModelId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'topicNamingAIProviderModelId',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topicNamingAIProviderModelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topicNamingAIProviderModelId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topicNamingAIProviderModelId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicNamingAIProviderModelId',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterFilterCondition>
      topicNamingAIProviderModelIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topicNamingAIProviderModelId',
        value: '',
      ));
    });
  }
}

extension AppConfigQueryObject
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {}

extension AppConfigQueryLinks
    on QueryBuilder<AppConfig, AppConfig, QFilterCondition> {}

extension AppConfigQuerySortBy on QueryBuilder<AppConfig, AppConfig, QSortBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDefaultConvAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDefaultConvAIProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDefaultConvAIProviderModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderModelId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByDefaultConvAIProviderModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderModelId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticFeedback', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByHapticFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticFeedback', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> sortByNewConvUseLastModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newConvUseLastModel', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByNewConvUseLastModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newConvUseLastModel', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByTopicNamingAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByTopicNamingAIProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByTopicNamingAIProviderModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderModelId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      sortByTopicNamingAIProviderModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderModelId', Sort.desc);
    });
  }
}

extension AppConfigQuerySortThenBy
    on QueryBuilder<AppConfig, AppConfig, QSortThenBy> {
  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDefaultConvAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDefaultConvAIProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDefaultConvAIProviderModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderModelId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByDefaultConvAIProviderModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultConvAIProviderModelId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticFeedback', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByHapticFeedbackDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hapticFeedback', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy> thenByNewConvUseLastModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newConvUseLastModel', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByNewConvUseLastModelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'newConvUseLastModel', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByTopicNamingAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByTopicNamingAIProviderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderId', Sort.desc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByTopicNamingAIProviderModelId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderModelId', Sort.asc);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QAfterSortBy>
      thenByTopicNamingAIProviderModelIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicNamingAIProviderModelId', Sort.desc);
    });
  }
}

extension AppConfigQueryWhereDistinct
    on QueryBuilder<AppConfig, AppConfig, QDistinct> {
  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByDefaultConvAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultConvAIProviderId');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByDefaultConvAIProviderModelId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultConvAIProviderModelId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct> distinctByHapticFeedback() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hapticFeedback');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByNewConvUseLastModel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'newConvUseLastModel');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByTopicNamingAIProviderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topicNamingAIProviderId');
    });
  }

  QueryBuilder<AppConfig, AppConfig, QDistinct>
      distinctByTopicNamingAIProviderModelId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topicNamingAIProviderModelId',
          caseSensitive: caseSensitive);
    });
  }
}

extension AppConfigQueryProperty
    on QueryBuilder<AppConfig, AppConfig, QQueryProperty> {
  QueryBuilder<AppConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppConfig, int?, QQueryOperations>
      defaultConvAIProviderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultConvAIProviderId');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations>
      defaultConvAIProviderModelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultConvAIProviderModelId');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations> hapticFeedbackProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hapticFeedback');
    });
  }

  QueryBuilder<AppConfig, bool, QQueryOperations>
      newConvUseLastModelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'newConvUseLastModel');
    });
  }

  QueryBuilder<AppConfig, int?, QQueryOperations>
      topicNamingAIProviderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topicNamingAIProviderId');
    });
  }

  QueryBuilder<AppConfig, String?, QQueryOperations>
      topicNamingAIProviderModelIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topicNamingAIProviderModelId');
    });
  }
}
