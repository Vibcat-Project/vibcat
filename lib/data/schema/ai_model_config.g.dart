// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_model_config.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAIModelConfigCollection on Isar {
  IsarCollection<AIModelConfig> get aIModelConfigs => this.collection();
}

const AIModelConfigSchema = CollectionSchema(
  name: r'AIModelConfig',
  id: -7222244736861170368,
  properties: {
    r'apiKey': PropertySchema(
      id: 0,
      name: r'apiKey',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'customName': PropertySchema(
      id: 2,
      name: r'customName',
      type: IsarType.string,
    ),
    r'endPoint': PropertySchema(
      id: 3,
      name: r'endPoint',
      type: IsarType.string,
    ),
    r'provider': PropertySchema(
      id: 4,
      name: r'provider',
      type: IsarType.string,
      enumMap: _AIModelConfigproviderEnumValueMap,
    ),
    r'tokenInput': PropertySchema(
      id: 5,
      name: r'tokenInput',
      type: IsarType.long,
    ),
    r'tokenOutput': PropertySchema(
      id: 6,
      name: r'tokenOutput',
      type: IsarType.long,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _aIModelConfigEstimateSize,
  serialize: _aIModelConfigSerialize,
  deserialize: _aIModelConfigDeserialize,
  deserializeProp: _aIModelConfigDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _aIModelConfigGetId,
  getLinks: _aIModelConfigGetLinks,
  attach: _aIModelConfigAttach,
  version: '3.1.0+1',
);

int _aIModelConfigEstimateSize(
  AIModelConfig object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.apiKey.length * 3;
  bytesCount += 3 + object.customName.length * 3;
  bytesCount += 3 + object.endPoint.length * 3;
  bytesCount += 3 + object.provider.name.length * 3;
  return bytesCount;
}

void _aIModelConfigSerialize(
  AIModelConfig object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.apiKey);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.customName);
  writer.writeString(offsets[3], object.endPoint);
  writer.writeString(offsets[4], object.provider.name);
  writer.writeLong(offsets[5], object.tokenInput);
  writer.writeLong(offsets[6], object.tokenOutput);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

AIModelConfig _aIModelConfigDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AIModelConfig(
    apiKey: reader.readString(offsets[0]),
    customName: reader.readString(offsets[2]),
    endPoint: reader.readString(offsets[3]),
    provider: _AIModelConfigproviderValueEnumMap[
            reader.readStringOrNull(offsets[4])] ??
        AIProviderType.openAI,
  );
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.tokenInput = reader.readLong(offsets[5]);
  object.tokenOutput = reader.readLong(offsets[6]);
  object.updatedAt = reader.readDateTime(offsets[7]);
  return object;
}

P _aIModelConfigDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_AIModelConfigproviderValueEnumMap[
              reader.readStringOrNull(offset)] ??
          AIProviderType.openAI) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AIModelConfigproviderEnumValueMap = {
  r'openAI': r'openAI',
  r'azureOpenAI': r'azureOpenAI',
  r'claude': r'claude',
  r'gemini': r'gemini',
  r'deepseek': r'deepseek',
  r'siliconFlow': r'siliconFlow',
  r'groq': r'groq',
  r'openRouter': r'openRouter',
  r'volcanoEngine': r'volcanoEngine',
  r'ollama': r'ollama',
};
const _AIModelConfigproviderValueEnumMap = {
  r'openAI': AIProviderType.openAI,
  r'azureOpenAI': AIProviderType.azureOpenAI,
  r'claude': AIProviderType.claude,
  r'gemini': AIProviderType.gemini,
  r'deepseek': AIProviderType.deepseek,
  r'siliconFlow': AIProviderType.siliconFlow,
  r'groq': AIProviderType.groq,
  r'openRouter': AIProviderType.openRouter,
  r'volcanoEngine': AIProviderType.volcanoEngine,
  r'ollama': AIProviderType.ollama,
};

Id _aIModelConfigGetId(AIModelConfig object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _aIModelConfigGetLinks(AIModelConfig object) {
  return [];
}

void _aIModelConfigAttach(
    IsarCollection<dynamic> col, Id id, AIModelConfig object) {
  object.id = id;
}

extension AIModelConfigQueryWhereSort
    on QueryBuilder<AIModelConfig, AIModelConfig, QWhere> {
  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AIModelConfigQueryWhere
    on QueryBuilder<AIModelConfig, AIModelConfig, QWhereClause> {
  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterWhereClause> idBetween(
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

extension AIModelConfigQueryFilter
    on QueryBuilder<AIModelConfig, AIModelConfig, QFilterCondition> {
  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'apiKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'apiKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'apiKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'apiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      apiKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'apiKey',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      customNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customName',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endPoint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endPoint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endPoint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endPoint',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      endPointIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endPoint',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerEqualTo(
    AIProviderType value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerGreaterThan(
    AIProviderType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerLessThan(
    AIProviderType value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerBetween(
    AIProviderType lower,
    AIProviderType upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'provider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'provider',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'provider',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'provider',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      providerIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'provider',
        value: '',
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenInputEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenInput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenInputGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tokenInput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenInputLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tokenInput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenInputBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tokenInput',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenOutputEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tokenOutput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenOutputGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tokenOutput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenOutputLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tokenOutput',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      tokenOutputBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tokenOutput',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AIModelConfigQueryObject
    on QueryBuilder<AIModelConfig, AIModelConfig, QFilterCondition> {}

extension AIModelConfigQueryLinks
    on QueryBuilder<AIModelConfig, AIModelConfig, QFilterCondition> {}

extension AIModelConfigQuerySortBy
    on QueryBuilder<AIModelConfig, AIModelConfig, QSortBy> {
  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByEndPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByEndPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByTokenInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenInput', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByTokenInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenInput', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByTokenOutput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenOutput', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByTokenOutputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenOutput', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AIModelConfigQuerySortThenBy
    on QueryBuilder<AIModelConfig, AIModelConfig, QSortThenBy> {
  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByApiKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByApiKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'apiKey', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByCustomName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByCustomNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customName', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByEndPoint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByEndPointDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endPoint', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'provider', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByTokenInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenInput', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByTokenInputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenInput', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByTokenOutput() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenOutput', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByTokenOutputDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tokenOutput', Sort.desc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension AIModelConfigQueryWhereDistinct
    on QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> {
  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByApiKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'apiKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByCustomName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByEndPoint(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endPoint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByProvider(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'provider', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByTokenInput() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenInput');
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct>
      distinctByTokenOutput() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tokenOutput');
    });
  }

  QueryBuilder<AIModelConfig, AIModelConfig, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension AIModelConfigQueryProperty
    on QueryBuilder<AIModelConfig, AIModelConfig, QQueryProperty> {
  QueryBuilder<AIModelConfig, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AIModelConfig, String, QQueryOperations> apiKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'apiKey');
    });
  }

  QueryBuilder<AIModelConfig, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<AIModelConfig, String, QQueryOperations> customNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customName');
    });
  }

  QueryBuilder<AIModelConfig, String, QQueryOperations> endPointProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endPoint');
    });
  }

  QueryBuilder<AIModelConfig, AIProviderType, QQueryOperations>
      providerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'provider');
    });
  }

  QueryBuilder<AIModelConfig, int, QQueryOperations> tokenInputProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenInput');
    });
  }

  QueryBuilder<AIModelConfig, int, QQueryOperations> tokenOutputProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tokenOutput');
    });
  }

  QueryBuilder<AIModelConfig, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
