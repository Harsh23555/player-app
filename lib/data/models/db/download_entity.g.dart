// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadEntityCollection on Isar {
  IsarCollection<DownloadEntity> get downloadEntitys => this.collection();
}

const DownloadEntitySchema = CollectionSchema(
  name: r'DownloadEntity',
  id: 8960427990331199440,
  properties: {
    r'checksum': PropertySchema(
      id: 0,
      name: r'checksum',
      type: IsarType.string,
    ),
    r'checksumType': PropertySchema(
      id: 1,
      name: r'checksumType',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 2,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'downloadedBytes': PropertySchema(
      id: 4,
      name: r'downloadedBytes',
      type: IsarType.long,
    ),
    r'errorMessage': PropertySchema(
      id: 5,
      name: r'errorMessage',
      type: IsarType.string,
    ),
    r'eta': PropertySchema(
      id: 6,
      name: r'eta',
      type: IsarType.long,
    ),
    r'fileName': PropertySchema(
      id: 7,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'isBackground': PropertySchema(
      id: 8,
      name: r'isBackground',
      type: IsarType.bool,
    ),
    r'mimeType': PropertySchema(
      id: 9,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'priority': PropertySchema(
      id: 10,
      name: r'priority',
      type: IsarType.long,
    ),
    r'progress': PropertySchema(
      id: 11,
      name: r'progress',
      type: IsarType.double,
    ),
    r'resumeMetadata': PropertySchema(
      id: 12,
      name: r'resumeMetadata',
      type: IsarType.string,
    ),
    r'savePath': PropertySchema(
      id: 13,
      name: r'savePath',
      type: IsarType.string,
    ),
    r'scheduledAt': PropertySchema(
      id: 14,
      name: r'scheduledAt',
      type: IsarType.dateTime,
    ),
    r'speed': PropertySchema(
      id: 15,
      name: r'speed',
      type: IsarType.double,
    ),
    r'status': PropertySchema(
      id: 16,
      name: r'status',
      type: IsarType.long,
    ),
    r'supportsResume': PropertySchema(
      id: 17,
      name: r'supportsResume',
      type: IsarType.bool,
    ),
    r'taskId': PropertySchema(
      id: 18,
      name: r'taskId',
      type: IsarType.string,
    ),
    r'threadCount': PropertySchema(
      id: 19,
      name: r'threadCount',
      type: IsarType.long,
    ),
    r'thumbnailUrl': PropertySchema(
      id: 20,
      name: r'thumbnailUrl',
      type: IsarType.string,
    ),
    r'totalBytes': PropertySchema(
      id: 21,
      name: r'totalBytes',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 22,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadEntityEstimateSize,
  serialize: _downloadEntitySerialize,
  deserialize: _downloadEntityDeserialize,
  deserializeProp: _downloadEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'taskId': IndexSchema(
      id: -6391211041487498726,
      name: r'taskId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'taskId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _downloadEntityGetId,
  getLinks: _downloadEntityGetLinks,
  attach: _downloadEntityAttach,
  version: '3.1.0+1',
);

int _downloadEntityEstimateSize(
  DownloadEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.checksum;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.checksumType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.errorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fileName.length * 3;
  {
    final value = object.mimeType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.resumeMetadata;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.savePath.length * 3;
  bytesCount += 3 + object.taskId.length * 3;
  {
    final value = object.thumbnailUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _downloadEntitySerialize(
  DownloadEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.checksum);
  writer.writeString(offsets[1], object.checksumType);
  writer.writeDateTime(offsets[2], object.completedAt);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeLong(offsets[4], object.downloadedBytes);
  writer.writeString(offsets[5], object.errorMessage);
  writer.writeLong(offsets[6], object.eta);
  writer.writeString(offsets[7], object.fileName);
  writer.writeBool(offsets[8], object.isBackground);
  writer.writeString(offsets[9], object.mimeType);
  writer.writeLong(offsets[10], object.priority);
  writer.writeDouble(offsets[11], object.progress);
  writer.writeString(offsets[12], object.resumeMetadata);
  writer.writeString(offsets[13], object.savePath);
  writer.writeDateTime(offsets[14], object.scheduledAt);
  writer.writeDouble(offsets[15], object.speed);
  writer.writeLong(offsets[16], object.status);
  writer.writeBool(offsets[17], object.supportsResume);
  writer.writeString(offsets[18], object.taskId);
  writer.writeLong(offsets[19], object.threadCount);
  writer.writeString(offsets[20], object.thumbnailUrl);
  writer.writeLong(offsets[21], object.totalBytes);
  writer.writeString(offsets[22], object.url);
}

DownloadEntity _downloadEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadEntity();
  object.checksum = reader.readStringOrNull(offsets[0]);
  object.checksumType = reader.readStringOrNull(offsets[1]);
  object.completedAt = reader.readDateTimeOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.downloadedBytes = reader.readLong(offsets[4]);
  object.errorMessage = reader.readStringOrNull(offsets[5]);
  object.eta = reader.readLong(offsets[6]);
  object.fileName = reader.readString(offsets[7]);
  object.id = id;
  object.isBackground = reader.readBool(offsets[8]);
  object.mimeType = reader.readStringOrNull(offsets[9]);
  object.priority = reader.readLong(offsets[10]);
  object.progress = reader.readDouble(offsets[11]);
  object.resumeMetadata = reader.readStringOrNull(offsets[12]);
  object.savePath = reader.readString(offsets[13]);
  object.scheduledAt = reader.readDateTimeOrNull(offsets[14]);
  object.speed = reader.readDouble(offsets[15]);
  object.status = reader.readLong(offsets[16]);
  object.supportsResume = reader.readBool(offsets[17]);
  object.taskId = reader.readString(offsets[18]);
  object.threadCount = reader.readLong(offsets[19]);
  object.thumbnailUrl = reader.readStringOrNull(offsets[20]);
  object.totalBytes = reader.readLong(offsets[21]);
  object.url = reader.readString(offsets[22]);
  return object;
}

P _downloadEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readLong(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readString(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readLong(offset)) as P;
    case 22:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadEntityGetId(DownloadEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadEntityGetLinks(DownloadEntity object) {
  return [];
}

void _downloadEntityAttach(
    IsarCollection<dynamic> col, Id id, DownloadEntity object) {
  object.id = id;
}

extension DownloadEntityByIndex on IsarCollection<DownloadEntity> {
  Future<DownloadEntity?> getByTaskId(String taskId) {
    return getByIndex(r'taskId', [taskId]);
  }

  DownloadEntity? getByTaskIdSync(String taskId) {
    return getByIndexSync(r'taskId', [taskId]);
  }

  Future<bool> deleteByTaskId(String taskId) {
    return deleteByIndex(r'taskId', [taskId]);
  }

  bool deleteByTaskIdSync(String taskId) {
    return deleteByIndexSync(r'taskId', [taskId]);
  }

  Future<List<DownloadEntity?>> getAllByTaskId(List<String> taskIdValues) {
    final values = taskIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'taskId', values);
  }

  List<DownloadEntity?> getAllByTaskIdSync(List<String> taskIdValues) {
    final values = taskIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'taskId', values);
  }

  Future<int> deleteAllByTaskId(List<String> taskIdValues) {
    final values = taskIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'taskId', values);
  }

  int deleteAllByTaskIdSync(List<String> taskIdValues) {
    final values = taskIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'taskId', values);
  }

  Future<Id> putByTaskId(DownloadEntity object) {
    return putByIndex(r'taskId', object);
  }

  Id putByTaskIdSync(DownloadEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'taskId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByTaskId(List<DownloadEntity> objects) {
    return putAllByIndex(r'taskId', objects);
  }

  List<Id> putAllByTaskIdSync(List<DownloadEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'taskId', objects, saveLinks: saveLinks);
  }
}

extension DownloadEntityQueryWhereSort
    on QueryBuilder<DownloadEntity, DownloadEntity, QWhere> {
  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadEntityQueryWhere
    on QueryBuilder<DownloadEntity, DownloadEntity, QWhereClause> {
  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> idBetween(
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause> taskIdEqualTo(
      String taskId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'taskId',
        value: [taskId],
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterWhereClause>
      taskIdNotEqualTo(String taskId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [taskId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'taskId',
              lower: [],
              upper: [taskId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DownloadEntityQueryFilter
    on QueryBuilder<DownloadEntity, DownloadEntity, QFilterCondition> {
  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checksum',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checksum',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checksum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checksum',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksum',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checksum',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checksumType',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checksumType',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checksumType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checksumType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checksumType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksumType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      checksumTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checksumType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      downloadedBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      downloadedBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      downloadedBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'downloadedBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      downloadedBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'downloadedBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'errorMessage',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'errorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'errorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'errorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      errorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'errorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      etaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      etaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      etaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'eta',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      etaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'eta',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      isBackgroundEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBackground',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      priorityEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      progressEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      progressGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      progressLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'progress',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      progressBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'progress',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resumeMetadata',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resumeMetadata',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resumeMetadata',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resumeMetadata',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resumeMetadata',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resumeMetadata',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      resumeMetadataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resumeMetadata',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'savePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      savePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'savePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      scheduledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      speedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      speedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      speedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      speedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      statusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      statusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      statusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      supportsResumeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supportsResume',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taskId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taskId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taskId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      taskIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taskId',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      threadCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'threadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      threadCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'threadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      threadCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'threadCount',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      threadCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'threadCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'thumbnailUrl',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'thumbnailUrl',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'thumbnailUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'thumbnailUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'thumbnailUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'thumbnailUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      thumbnailUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'thumbnailUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      totalBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      totalBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      totalBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      totalBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterFilterCondition>
      urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension DownloadEntityQueryObject
    on QueryBuilder<DownloadEntity, DownloadEntity, QFilterCondition> {}

extension DownloadEntityQueryLinks
    on QueryBuilder<DownloadEntity, DownloadEntity, QFilterCondition> {}

extension DownloadEntityQuerySortBy
    on QueryBuilder<DownloadEntity, DownloadEntity, QSortBy> {
  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByChecksum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByChecksumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByChecksumType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksumType', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByChecksumTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksumType', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByEtaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByIsBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBackground', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByIsBackgroundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBackground', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByResumeMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeMetadata', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByResumeMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeMetadata', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortBySavePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortBySavePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortBySupportsResume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsResume', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortBySupportsResumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsResume', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByThreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadCount', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByThreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadCount', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByThumbnailUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailUrl', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByThumbnailUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailUrl', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      sortByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadEntityQuerySortThenBy
    on QueryBuilder<DownloadEntity, DownloadEntity, QSortThenBy> {
  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByChecksum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByChecksumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByChecksumType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksumType', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByChecksumTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksumType', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByDownloadedBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'downloadedBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'errorMessage', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByEtaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'eta', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByIsBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBackground', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByIsBackgroundDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isBackground', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByProgressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'progress', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByResumeMetadata() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeMetadata', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByResumeMetadataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeMetadata', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenBySavePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenBySavePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenBySpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speed', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenBySupportsResume() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsResume', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenBySupportsResumeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supportsResume', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByTaskId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByTaskIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taskId', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByThreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadCount', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByThreadCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'threadCount', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByThumbnailUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailUrl', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByThumbnailUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'thumbnailUrl', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy>
      thenByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QAfterSortBy> thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadEntityQueryWhereDistinct
    on QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> {
  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByChecksum(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checksum', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByChecksumType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checksumType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByDownloadedBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'downloadedBytes');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'errorMessage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByEta() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'eta');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByFileName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByIsBackground() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isBackground');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByMimeType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByProgress() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'progress');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByResumeMetadata({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resumeMetadata',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctBySavePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAt');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctBySpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speed');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctBySupportsResume() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supportsResume');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByTaskId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taskId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByThreadCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'threadCount');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByThumbnailUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'thumbnailUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct>
      distinctByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBytes');
    });
  }

  QueryBuilder<DownloadEntity, DownloadEntity, QDistinct> distinctByUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadEntityQueryProperty
    on QueryBuilder<DownloadEntity, DownloadEntity, QQueryProperty> {
  QueryBuilder<DownloadEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations> checksumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checksum');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations>
      checksumTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checksumType');
    });
  }

  QueryBuilder<DownloadEntity, DateTime?, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<DownloadEntity, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations>
      downloadedBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'downloadedBytes');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations>
      errorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'errorMessage');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations> etaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'eta');
    });
  }

  QueryBuilder<DownloadEntity, String, QQueryOperations> fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<DownloadEntity, bool, QQueryOperations> isBackgroundProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isBackground');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations> mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<DownloadEntity, double, QQueryOperations> progressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'progress');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations>
      resumeMetadataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resumeMetadata');
    });
  }

  QueryBuilder<DownloadEntity, String, QQueryOperations> savePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savePath');
    });
  }

  QueryBuilder<DownloadEntity, DateTime?, QQueryOperations>
      scheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAt');
    });
  }

  QueryBuilder<DownloadEntity, double, QQueryOperations> speedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speed');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<DownloadEntity, bool, QQueryOperations>
      supportsResumeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supportsResume');
    });
  }

  QueryBuilder<DownloadEntity, String, QQueryOperations> taskIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taskId');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations> threadCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'threadCount');
    });
  }

  QueryBuilder<DownloadEntity, String?, QQueryOperations>
      thumbnailUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'thumbnailUrl');
    });
  }

  QueryBuilder<DownloadEntity, int, QQueryOperations> totalBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBytes');
    });
  }

  QueryBuilder<DownloadEntity, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadHistoryEntityCollection on Isar {
  IsarCollection<DownloadHistoryEntity> get downloadHistoryEntitys =>
      this.collection();
}

const DownloadHistoryEntitySchema = CollectionSchema(
  name: r'DownloadHistoryEntity',
  id: -7329415782548243922,
  properties: {
    r'checksum': PropertySchema(
      id: 0,
      name: r'checksum',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'durationMs': PropertySchema(
      id: 2,
      name: r'durationMs',
      type: IsarType.long,
    ),
    r'fileName': PropertySchema(
      id: 3,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'mimeType': PropertySchema(
      id: 4,
      name: r'mimeType',
      type: IsarType.string,
    ),
    r'savePath': PropertySchema(
      id: 5,
      name: r'savePath',
      type: IsarType.string,
    ),
    r'totalBytes': PropertySchema(
      id: 6,
      name: r'totalBytes',
      type: IsarType.long,
    ),
    r'url': PropertySchema(
      id: 7,
      name: r'url',
      type: IsarType.string,
    )
  },
  estimateSize: _downloadHistoryEntityEstimateSize,
  serialize: _downloadHistoryEntitySerialize,
  deserialize: _downloadHistoryEntityDeserialize,
  deserializeProp: _downloadHistoryEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _downloadHistoryEntityGetId,
  getLinks: _downloadHistoryEntityGetLinks,
  attach: _downloadHistoryEntityAttach,
  version: '3.1.0+1',
);

int _downloadHistoryEntityEstimateSize(
  DownloadHistoryEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.checksum;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fileName.length * 3;
  {
    final value = object.mimeType;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.savePath.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _downloadHistoryEntitySerialize(
  DownloadHistoryEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.checksum);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeLong(offsets[2], object.durationMs);
  writer.writeString(offsets[3], object.fileName);
  writer.writeString(offsets[4], object.mimeType);
  writer.writeString(offsets[5], object.savePath);
  writer.writeLong(offsets[6], object.totalBytes);
  writer.writeString(offsets[7], object.url);
}

DownloadHistoryEntity _downloadHistoryEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadHistoryEntity();
  object.checksum = reader.readStringOrNull(offsets[0]);
  object.completedAt = reader.readDateTime(offsets[1]);
  object.durationMs = reader.readLong(offsets[2]);
  object.fileName = reader.readString(offsets[3]);
  object.id = id;
  object.mimeType = reader.readStringOrNull(offsets[4]);
  object.savePath = reader.readString(offsets[5]);
  object.totalBytes = reader.readLong(offsets[6]);
  object.url = reader.readString(offsets[7]);
  return object;
}

P _downloadHistoryEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadHistoryEntityGetId(DownloadHistoryEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadHistoryEntityGetLinks(
    DownloadHistoryEntity object) {
  return [];
}

void _downloadHistoryEntityAttach(
    IsarCollection<dynamic> col, Id id, DownloadHistoryEntity object) {
  object.id = id;
}

extension DownloadHistoryEntityQueryWhereSort
    on QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QWhere> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadHistoryEntityQueryWhere on QueryBuilder<DownloadHistoryEntity,
    DownloadHistoryEntity, QWhereClause> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhereClause>
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

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterWhereClause>
      idBetween(
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

extension DownloadHistoryEntityQueryFilter on QueryBuilder<
    DownloadHistoryEntity, DownloadHistoryEntity, QFilterCondition> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'checksum',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'checksum',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'checksum',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      checksumContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'checksum',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      checksumMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'checksum',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'checksum',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> checksumIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'checksum',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> completedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> completedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> durationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> durationMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> durationMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> durationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mimeType',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mimeType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      mimeTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mimeType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      mimeTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mimeType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> mimeTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mimeType',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'savePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      savePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'savePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      savePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'savePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'savePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> savePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'savePath',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> totalBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> totalBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> totalBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> totalBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
          QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity,
      QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }
}

extension DownloadHistoryEntityQueryObject on QueryBuilder<
    DownloadHistoryEntity, DownloadHistoryEntity, QFilterCondition> {}

extension DownloadHistoryEntityQueryLinks on QueryBuilder<DownloadHistoryEntity,
    DownloadHistoryEntity, QFilterCondition> {}

extension DownloadHistoryEntityQuerySortBy
    on QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QSortBy> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByChecksum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByChecksumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortBySavePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortBySavePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadHistoryEntityQuerySortThenBy
    on QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QSortThenBy> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByChecksum() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByChecksumDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'checksum', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationMs', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByMimeType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByMimeTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mimeType', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenBySavePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenBySavePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'savePath', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QAfterSortBy>
      thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }
}

extension DownloadHistoryEntityQueryWhereDistinct
    on QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct> {
  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByChecksum({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'checksum', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationMs');
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByMimeType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mimeType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctBySavePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'savePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBytes');
    });
  }

  QueryBuilder<DownloadHistoryEntity, DownloadHistoryEntity, QDistinct>
      distinctByUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }
}

extension DownloadHistoryEntityQueryProperty on QueryBuilder<
    DownloadHistoryEntity, DownloadHistoryEntity, QQueryProperty> {
  QueryBuilder<DownloadHistoryEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadHistoryEntity, String?, QQueryOperations>
      checksumProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'checksum');
    });
  }

  QueryBuilder<DownloadHistoryEntity, DateTime, QQueryOperations>
      completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<DownloadHistoryEntity, int, QQueryOperations>
      durationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationMs');
    });
  }

  QueryBuilder<DownloadHistoryEntity, String, QQueryOperations>
      fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<DownloadHistoryEntity, String?, QQueryOperations>
      mimeTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mimeType');
    });
  }

  QueryBuilder<DownloadHistoryEntity, String, QQueryOperations>
      savePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'savePath');
    });
  }

  QueryBuilder<DownloadHistoryEntity, int, QQueryOperations>
      totalBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBytes');
    });
  }

  QueryBuilder<DownloadHistoryEntity, String, QQueryOperations> urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetScheduledDownloadEntityCollection on Isar {
  IsarCollection<ScheduledDownloadEntity> get scheduledDownloadEntitys =>
      this.collection();
}

const ScheduledDownloadEntitySchema = CollectionSchema(
  name: r'ScheduledDownloadEntity',
  id: -2084586038793168631,
  properties: {
    r'batteryThreshold': PropertySchema(
      id: 0,
      name: r'batteryThreshold',
      type: IsarType.long,
    ),
    r'chargingOnly': PropertySchema(
      id: 1,
      name: r'chargingOnly',
      type: IsarType.bool,
    ),
    r'executed': PropertySchema(
      id: 2,
      name: r'executed',
      type: IsarType.bool,
    ),
    r'fileName': PropertySchema(
      id: 3,
      name: r'fileName',
      type: IsarType.string,
    ),
    r'nightModeOnly': PropertySchema(
      id: 4,
      name: r'nightModeOnly',
      type: IsarType.bool,
    ),
    r'scheduledAt': PropertySchema(
      id: 5,
      name: r'scheduledAt',
      type: IsarType.dateTime,
    ),
    r'url': PropertySchema(
      id: 6,
      name: r'url',
      type: IsarType.string,
    ),
    r'wifiOnly': PropertySchema(
      id: 7,
      name: r'wifiOnly',
      type: IsarType.bool,
    )
  },
  estimateSize: _scheduledDownloadEntityEstimateSize,
  serialize: _scheduledDownloadEntitySerialize,
  deserialize: _scheduledDownloadEntityDeserialize,
  deserializeProp: _scheduledDownloadEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _scheduledDownloadEntityGetId,
  getLinks: _scheduledDownloadEntityGetLinks,
  attach: _scheduledDownloadEntityAttach,
  version: '3.1.0+1',
);

int _scheduledDownloadEntityEstimateSize(
  ScheduledDownloadEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fileName.length * 3;
  bytesCount += 3 + object.url.length * 3;
  return bytesCount;
}

void _scheduledDownloadEntitySerialize(
  ScheduledDownloadEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.batteryThreshold);
  writer.writeBool(offsets[1], object.chargingOnly);
  writer.writeBool(offsets[2], object.executed);
  writer.writeString(offsets[3], object.fileName);
  writer.writeBool(offsets[4], object.nightModeOnly);
  writer.writeDateTime(offsets[5], object.scheduledAt);
  writer.writeString(offsets[6], object.url);
  writer.writeBool(offsets[7], object.wifiOnly);
}

ScheduledDownloadEntity _scheduledDownloadEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ScheduledDownloadEntity();
  object.batteryThreshold = reader.readLong(offsets[0]);
  object.chargingOnly = reader.readBool(offsets[1]);
  object.executed = reader.readBool(offsets[2]);
  object.fileName = reader.readString(offsets[3]);
  object.id = id;
  object.nightModeOnly = reader.readBool(offsets[4]);
  object.scheduledAt = reader.readDateTime(offsets[5]);
  object.url = reader.readString(offsets[6]);
  object.wifiOnly = reader.readBool(offsets[7]);
  return object;
}

P _scheduledDownloadEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _scheduledDownloadEntityGetId(ScheduledDownloadEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _scheduledDownloadEntityGetLinks(
    ScheduledDownloadEntity object) {
  return [];
}

void _scheduledDownloadEntityAttach(
    IsarCollection<dynamic> col, Id id, ScheduledDownloadEntity object) {
  object.id = id;
}

extension ScheduledDownloadEntityQueryWhereSort
    on QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QWhere> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ScheduledDownloadEntityQueryWhere on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QWhereClause> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterWhereClause> idBetween(
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

extension ScheduledDownloadEntityQueryFilter on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QFilterCondition> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> batteryThresholdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batteryThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> batteryThresholdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batteryThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> batteryThresholdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batteryThreshold',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> batteryThresholdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batteryThreshold',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> chargingOnlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chargingOnly',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> executedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'executed',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
          QAfterFilterCondition>
      fileNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
          QAfterFilterCondition>
      fileNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> fileNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileName',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> nightModeOnlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nightModeOnly',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> scheduledAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> scheduledAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> scheduledAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> scheduledAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'url',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
          QAfterFilterCondition>
      urlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'url',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
          QAfterFilterCondition>
      urlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'url',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> urlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'url',
        value: '',
      ));
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity,
      QAfterFilterCondition> wifiOnlyEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wifiOnly',
        value: value,
      ));
    });
  }
}

extension ScheduledDownloadEntityQueryObject on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QFilterCondition> {}

extension ScheduledDownloadEntityQueryLinks on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QFilterCondition> {}

extension ScheduledDownloadEntityQuerySortBy
    on QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QSortBy> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByBatteryThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryThreshold', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByBatteryThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryThreshold', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByChargingOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargingOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByChargingOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargingOnly', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByExecuted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executed', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByExecutedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executed', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByNightModeOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightModeOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByNightModeOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightModeOnly', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      sortByWifiOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnly', Sort.desc);
    });
  }
}

extension ScheduledDownloadEntityQuerySortThenBy on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QSortThenBy> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByBatteryThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryThreshold', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByBatteryThresholdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryThreshold', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByChargingOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargingOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByChargingOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chargingOnly', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByExecuted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executed', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByExecutedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'executed', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByFileName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByFileNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileName', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByNightModeOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightModeOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByNightModeOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nightModeOnly', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'url', Sort.desc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnly', Sort.asc);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QAfterSortBy>
      thenByWifiOnlyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wifiOnly', Sort.desc);
    });
  }
}

extension ScheduledDownloadEntityQueryWhereDistinct on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct> {
  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByBatteryThreshold() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batteryThreshold');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByChargingOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chargingOnly');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByExecuted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'executed');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByFileName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByNightModeOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nightModeOnly');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAt');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByUrl({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'url', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ScheduledDownloadEntity, ScheduledDownloadEntity, QDistinct>
      distinctByWifiOnly() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wifiOnly');
    });
  }
}

extension ScheduledDownloadEntityQueryProperty on QueryBuilder<
    ScheduledDownloadEntity, ScheduledDownloadEntity, QQueryProperty> {
  QueryBuilder<ScheduledDownloadEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, int, QQueryOperations>
      batteryThresholdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batteryThreshold');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, bool, QQueryOperations>
      chargingOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chargingOnly');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, bool, QQueryOperations>
      executedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'executed');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, String, QQueryOperations>
      fileNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileName');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, bool, QQueryOperations>
      nightModeOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nightModeOnly');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, DateTime, QQueryOperations>
      scheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAt');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, String, QQueryOperations>
      urlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'url');
    });
  }

  QueryBuilder<ScheduledDownloadEntity, bool, QQueryOperations>
      wifiOnlyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wifiOnly');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAutomationRuleEntityCollection on Isar {
  IsarCollection<AutomationRuleEntity> get automationRuleEntitys =>
      this.collection();
}

const AutomationRuleEntitySchema = CollectionSchema(
  name: r'AutomationRuleEntity',
  id: -3392093147397608164,
  properties: {
    r'autoCategorize': PropertySchema(
      id: 0,
      name: r'autoCategorize',
      type: IsarType.bool,
    ),
    r'autoRename': PropertySchema(
      id: 1,
      name: r'autoRename',
      type: IsarType.bool,
    ),
    r'fileTypePattern': PropertySchema(
      id: 2,
      name: r'fileTypePattern',
      type: IsarType.string,
    ),
    r'isEnabled': PropertySchema(
      id: 3,
      name: r'isEnabled',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'targetFolder': PropertySchema(
      id: 5,
      name: r'targetFolder',
      type: IsarType.string,
    )
  },
  estimateSize: _automationRuleEntityEstimateSize,
  serialize: _automationRuleEntitySerialize,
  deserialize: _automationRuleEntityDeserialize,
  deserializeProp: _automationRuleEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _automationRuleEntityGetId,
  getLinks: _automationRuleEntityGetLinks,
  attach: _automationRuleEntityAttach,
  version: '3.1.0+1',
);

int _automationRuleEntityEstimateSize(
  AutomationRuleEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.fileTypePattern.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.targetFolder.length * 3;
  return bytesCount;
}

void _automationRuleEntitySerialize(
  AutomationRuleEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.autoCategorize);
  writer.writeBool(offsets[1], object.autoRename);
  writer.writeString(offsets[2], object.fileTypePattern);
  writer.writeBool(offsets[3], object.isEnabled);
  writer.writeString(offsets[4], object.name);
  writer.writeString(offsets[5], object.targetFolder);
}

AutomationRuleEntity _automationRuleEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AutomationRuleEntity();
  object.autoCategorize = reader.readBool(offsets[0]);
  object.autoRename = reader.readBool(offsets[1]);
  object.fileTypePattern = reader.readString(offsets[2]);
  object.id = id;
  object.isEnabled = reader.readBool(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.targetFolder = reader.readString(offsets[5]);
  return object;
}

P _automationRuleEntityDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _automationRuleEntityGetId(AutomationRuleEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _automationRuleEntityGetLinks(
    AutomationRuleEntity object) {
  return [];
}

void _automationRuleEntityAttach(
    IsarCollection<dynamic> col, Id id, AutomationRuleEntity object) {
  object.id = id;
}

extension AutomationRuleEntityQueryWhereSort
    on QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QWhere> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AutomationRuleEntityQueryWhere
    on QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QWhereClause> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhereClause>
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

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterWhereClause>
      idBetween(
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

extension AutomationRuleEntityQueryFilter on QueryBuilder<AutomationRuleEntity,
    AutomationRuleEntity, QFilterCondition> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> autoCategorizeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoCategorize',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> autoRenameEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoRename',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fileTypePattern',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      fileTypePatternContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fileTypePattern',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      fileTypePatternMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fileTypePattern',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fileTypePattern',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> fileTypePatternIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fileTypePattern',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> isEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetFolder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      targetFolderContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetFolder',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
          QAfterFilterCondition>
      targetFolderMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetFolder',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetFolder',
        value: '',
      ));
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity,
      QAfterFilterCondition> targetFolderIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetFolder',
        value: '',
      ));
    });
  }
}

extension AutomationRuleEntityQueryObject on QueryBuilder<AutomationRuleEntity,
    AutomationRuleEntity, QFilterCondition> {}

extension AutomationRuleEntityQueryLinks on QueryBuilder<AutomationRuleEntity,
    AutomationRuleEntity, QFilterCondition> {}

extension AutomationRuleEntityQuerySortBy
    on QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QSortBy> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByAutoCategorize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCategorize', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByAutoCategorizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCategorize', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByAutoRename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRename', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByAutoRenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRename', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByFileTypePattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileTypePattern', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByFileTypePatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileTypePattern', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByTargetFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFolder', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      sortByTargetFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFolder', Sort.desc);
    });
  }
}

extension AutomationRuleEntityQuerySortThenBy
    on QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QSortThenBy> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByAutoCategorize() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCategorize', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByAutoCategorizeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoCategorize', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByAutoRename() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRename', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByAutoRenameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoRename', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByFileTypePattern() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileTypePattern', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByFileTypePatternDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fileTypePattern', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByIsEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isEnabled', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByTargetFolder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFolder', Sort.asc);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QAfterSortBy>
      thenByTargetFolderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetFolder', Sort.desc);
    });
  }
}

extension AutomationRuleEntityQueryWhereDistinct
    on QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct> {
  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByAutoCategorize() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoCategorize');
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByAutoRename() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoRename');
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByFileTypePattern({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fileTypePattern',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByIsEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isEnabled');
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AutomationRuleEntity, AutomationRuleEntity, QDistinct>
      distinctByTargetFolder({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetFolder', caseSensitive: caseSensitive);
    });
  }
}

extension AutomationRuleEntityQueryProperty on QueryBuilder<
    AutomationRuleEntity, AutomationRuleEntity, QQueryProperty> {
  QueryBuilder<AutomationRuleEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AutomationRuleEntity, bool, QQueryOperations>
      autoCategorizeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoCategorize');
    });
  }

  QueryBuilder<AutomationRuleEntity, bool, QQueryOperations>
      autoRenameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoRename');
    });
  }

  QueryBuilder<AutomationRuleEntity, String, QQueryOperations>
      fileTypePatternProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fileTypePattern');
    });
  }

  QueryBuilder<AutomationRuleEntity, bool, QQueryOperations>
      isEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isEnabled');
    });
  }

  QueryBuilder<AutomationRuleEntity, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<AutomationRuleEntity, String, QQueryOperations>
      targetFolderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetFolder');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDownloadAnalyticsEntityCollection on Isar {
  IsarCollection<DownloadAnalyticsEntity> get downloadAnalyticsEntitys =>
      this.collection();
}

const DownloadAnalyticsEntitySchema = CollectionSchema(
  name: r'DownloadAnalyticsEntity',
  id: 7568449473809483323,
  properties: {
    r'averageSpeed': PropertySchema(
      id: 0,
      name: r'averageSpeed',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'failedDownloads': PropertySchema(
      id: 2,
      name: r'failedDownloads',
      type: IsarType.long,
    ),
    r'peakSpeed': PropertySchema(
      id: 3,
      name: r'peakSpeed',
      type: IsarType.double,
    ),
    r'successfulDownloads': PropertySchema(
      id: 4,
      name: r'successfulDownloads',
      type: IsarType.long,
    ),
    r'totalBytes': PropertySchema(
      id: 5,
      name: r'totalBytes',
      type: IsarType.long,
    ),
    r'totalDownloads': PropertySchema(
      id: 6,
      name: r'totalDownloads',
      type: IsarType.long,
    ),
    r'totalDurationMs': PropertySchema(
      id: 7,
      name: r'totalDurationMs',
      type: IsarType.long,
    )
  },
  estimateSize: _downloadAnalyticsEntityEstimateSize,
  serialize: _downloadAnalyticsEntitySerialize,
  deserialize: _downloadAnalyticsEntityDeserialize,
  deserializeProp: _downloadAnalyticsEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _downloadAnalyticsEntityGetId,
  getLinks: _downloadAnalyticsEntityGetLinks,
  attach: _downloadAnalyticsEntityAttach,
  version: '3.1.0+1',
);

int _downloadAnalyticsEntityEstimateSize(
  DownloadAnalyticsEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _downloadAnalyticsEntitySerialize(
  DownloadAnalyticsEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.averageSpeed);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.failedDownloads);
  writer.writeDouble(offsets[3], object.peakSpeed);
  writer.writeLong(offsets[4], object.successfulDownloads);
  writer.writeLong(offsets[5], object.totalBytes);
  writer.writeLong(offsets[6], object.totalDownloads);
  writer.writeLong(offsets[7], object.totalDurationMs);
}

DownloadAnalyticsEntity _downloadAnalyticsEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DownloadAnalyticsEntity();
  object.averageSpeed = reader.readDouble(offsets[0]);
  object.date = reader.readDateTime(offsets[1]);
  object.failedDownloads = reader.readLong(offsets[2]);
  object.id = id;
  object.peakSpeed = reader.readDouble(offsets[3]);
  object.successfulDownloads = reader.readLong(offsets[4]);
  object.totalBytes = reader.readLong(offsets[5]);
  object.totalDownloads = reader.readLong(offsets[6]);
  object.totalDurationMs = reader.readLong(offsets[7]);
  return object;
}

P _downloadAnalyticsEntityDeserializeProp<P>(
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
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _downloadAnalyticsEntityGetId(DownloadAnalyticsEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _downloadAnalyticsEntityGetLinks(
    DownloadAnalyticsEntity object) {
  return [];
}

void _downloadAnalyticsEntityAttach(
    IsarCollection<dynamic> col, Id id, DownloadAnalyticsEntity object) {
  object.id = id;
}

extension DownloadAnalyticsEntityQueryWhereSort
    on QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QWhere> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DownloadAnalyticsEntityQueryWhere on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QWhereClause> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterWhereClause> idBetween(
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

extension DownloadAnalyticsEntityQueryFilter on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QFilterCondition> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> averageSpeedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> averageSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> averageSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> averageSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> failedDownloadsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failedDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> failedDownloadsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failedDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> failedDownloadsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failedDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> failedDownloadsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failedDownloads',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> peakSpeedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peakSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> peakSpeedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peakSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> peakSpeedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peakSpeed',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> peakSpeedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peakSpeed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> successfulDownloadsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'successfulDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> successfulDownloadsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'successfulDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> successfulDownloadsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'successfulDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> successfulDownloadsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'successfulDownloads',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalBytesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalBytesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalBytesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalBytes',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalBytesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalBytes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDownloadsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDownloadsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDownloadsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDownloads',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDownloadsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDownloads',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDurationMsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDurationMsGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDurationMsLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDurationMs',
        value: value,
      ));
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity,
      QAfterFilterCondition> totalDurationMsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDurationMs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DownloadAnalyticsEntityQueryObject on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QFilterCondition> {}

extension DownloadAnalyticsEntityQueryLinks on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QFilterCondition> {}

extension DownloadAnalyticsEntityQuerySortBy
    on QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QSortBy> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByFailedDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByFailedDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByPeakSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakSpeed', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByPeakSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakSpeed', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortBySuccessfulDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'successfulDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortBySuccessfulDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'successfulDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationMs', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      sortByTotalDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationMs', Sort.desc);
    });
  }
}

extension DownloadAnalyticsEntityQuerySortThenBy on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QSortThenBy> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByAverageSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageSpeed', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByFailedDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByFailedDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failedDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByPeakSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakSpeed', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByPeakSpeedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakSpeed', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenBySuccessfulDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'successfulDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenBySuccessfulDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'successfulDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalBytesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalBytes', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloads', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalDownloadsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDownloads', Sort.desc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationMs', Sort.asc);
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QAfterSortBy>
      thenByTotalDurationMsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDurationMs', Sort.desc);
    });
  }
}

extension DownloadAnalyticsEntityQueryWhereDistinct on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct> {
  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByAverageSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageSpeed');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByFailedDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failedDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByPeakSpeed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peakSpeed');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctBySuccessfulDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'successfulDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByTotalBytes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalBytes');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByTotalDownloads() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DownloadAnalyticsEntity, QDistinct>
      distinctByTotalDurationMs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDurationMs');
    });
  }
}

extension DownloadAnalyticsEntityQueryProperty on QueryBuilder<
    DownloadAnalyticsEntity, DownloadAnalyticsEntity, QQueryProperty> {
  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, double, QQueryOperations>
      averageSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageSpeed');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, DateTime, QQueryOperations>
      dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations>
      failedDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failedDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, double, QQueryOperations>
      peakSpeedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peakSpeed');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations>
      successfulDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'successfulDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations>
      totalBytesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalBytes');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations>
      totalDownloadsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDownloads');
    });
  }

  QueryBuilder<DownloadAnalyticsEntity, int, QQueryOperations>
      totalDurationMsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDurationMs');
    });
  }
}
