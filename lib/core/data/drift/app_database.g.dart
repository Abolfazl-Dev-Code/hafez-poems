// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $PoemCacheTableTable extends PoemCacheTable
    with TableInfo<$PoemCacheTableTable, PoemCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoemCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _poemIdMeta = const VerificationMeta('poemId');
  @override
  late final GeneratedColumn<String> poemId = GeneratedColumn<String>(
    'poem_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTitleMeta = const VerificationMeta(
    'poemTitle',
  );
  @override
  late final GeneratedColumn<String> poemTitle = GeneratedColumn<String>(
    'poem_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTextMeta = const VerificationMeta(
    'poemText',
  );
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
    'poem_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _hasFullTextMeta = const VerificationMeta(
    'hasFullText',
  );
  @override
  late final GeneratedColumn<bool> hasFullText = GeneratedColumn<bool>(
    'has_full_text',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_full_text" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    poemId,
    category,
    poemTitle,
    poemText,
    audioUrl,
    hasFullText,
    kind,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'poem_cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PoemCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('poem_title')) {
      context.handle(
        _poemTitleMeta,
        poemTitle.isAcceptableOrUnknown(data['poem_title']!, _poemTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTitleMeta);
    }
    if (data.containsKey('poem_text')) {
      context.handle(
        _poemTextMeta,
        poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta),
      );
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('has_full_text')) {
      context.handle(
        _hasFullTextMeta,
        hasFullText.isAcceptableOrUnknown(
          data['has_full_text']!,
          _hasFullTextMeta,
        ),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {poemId, category};
  @override
  PoemCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PoemCacheTableData(
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      poemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_title'],
      )!,
      poemText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_text'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
      hasFullText: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_full_text'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      ),
    );
  }

  @override
  $PoemCacheTableTable createAlias(String alias) {
    return $PoemCacheTableTable(attachedDatabase, alias);
  }
}

class PoemCacheTableData extends DataClass
    implements Insertable<PoemCacheTableData> {
  final String poemId;
  final String category;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  final bool hasFullText;
  final String? kind;
  const PoemCacheTableData({
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
    required this.hasFullText,
    this.kind,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    map['category'] = Variable<String>(category);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    map['has_full_text'] = Variable<bool>(hasFullText);
    if (!nullToAbsent || kind != null) {
      map['kind'] = Variable<String>(kind);
    }
    return map;
  }

  PoemCacheTableCompanion toCompanion(bool nullToAbsent) {
    return PoemCacheTableCompanion(
      poemId: Value(poemId),
      category: Value(category),
      poemTitle: Value(poemTitle),
      poemText: Value(poemText),
      audioUrl: Value(audioUrl),
      hasFullText: Value(hasFullText),
      kind: kind == null && nullToAbsent ? const Value.absent() : Value(kind),
    );
  }

  factory PoemCacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PoemCacheTableData(
      poemId: serializer.fromJson<String>(json['poemId']),
      category: serializer.fromJson<String>(json['category']),
      poemTitle: serializer.fromJson<String>(json['poemTitle']),
      poemText: serializer.fromJson<String>(json['poemText']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      hasFullText: serializer.fromJson<bool>(json['hasFullText']),
      kind: serializer.fromJson<String?>(json['kind']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'poemId': serializer.toJson<String>(poemId),
      'category': serializer.toJson<String>(category),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'hasFullText': serializer.toJson<bool>(hasFullText),
      'kind': serializer.toJson<String?>(kind),
    };
  }

  PoemCacheTableData copyWith({
    String? poemId,
    String? category,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
    bool? hasFullText,
    Value<String?> kind = const Value.absent(),
  }) => PoemCacheTableData(
    poemId: poemId ?? this.poemId,
    category: category ?? this.category,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
    hasFullText: hasFullText ?? this.hasFullText,
    kind: kind.present ? kind.value : this.kind,
  );
  PoemCacheTableData copyWithCompanion(PoemCacheTableCompanion data) {
    return PoemCacheTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      category: data.category.present ? data.category.value : this.category,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      hasFullText: data.hasFullText.present
          ? data.hasFullText.value
          : this.hasFullText,
      kind: data.kind.present ? data.kind.value : this.kind,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PoemCacheTableData(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('hasFullText: $hasFullText, ')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    poemId,
    category,
    poemTitle,
    poemText,
    audioUrl,
    hasFullText,
    kind,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PoemCacheTableData &&
          other.poemId == this.poemId &&
          other.category == this.category &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl &&
          other.hasFullText == this.hasFullText &&
          other.kind == this.kind);
}

class PoemCacheTableCompanion extends UpdateCompanion<PoemCacheTableData> {
  final Value<String> poemId;
  final Value<String> category;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<bool> hasFullText;
  final Value<String?> kind;
  final Value<int> rowid;
  const PoemCacheTableCompanion({
    this.poemId = const Value.absent(),
    this.category = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.hasFullText = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PoemCacheTableCompanion.insert({
    required String poemId,
    required String category,
    required String poemTitle,
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.hasFullText = const Value.absent(),
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId),
       category = Value(category),
       poemTitle = Value(poemTitle);
  static Insertable<PoemCacheTableData> custom({
    Expression<String>? poemId,
    Expression<String>? category,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<bool>? hasFullText,
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (category != null) 'category': category,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (hasFullText != null) 'has_full_text': hasFullText,
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PoemCacheTableCompanion copyWith({
    Value<String>? poemId,
    Value<String>? category,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<bool>? hasFullText,
    Value<String?>? kind,
    Value<int>? rowid,
  }) {
    return PoemCacheTableCompanion(
      poemId: poemId ?? this.poemId,
      category: category ?? this.category,
      poemTitle: poemTitle ?? this.poemTitle,
      poemText: poemText ?? this.poemText,
      audioUrl: audioUrl ?? this.audioUrl,
      hasFullText: hasFullText ?? this.hasFullText,
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (poemTitle.present) {
      map['poem_title'] = Variable<String>(poemTitle.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (hasFullText.present) {
      map['has_full_text'] = Variable<bool>(hasFullText.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoemCacheTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('hasFullText: $hasFullText, ')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LikedItemsTableTable extends LikedItemsTable
    with TableInfo<$LikedItemsTableTable, LikedItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LikedItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _poemIdMeta = const VerificationMeta('poemId');
  @override
  late final GeneratedColumn<String> poemId = GeneratedColumn<String>(
    'poem_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTitleMeta = const VerificationMeta(
    'poemTitle',
  );
  @override
  late final GeneratedColumn<String> poemTitle = GeneratedColumn<String>(
    'poem_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTextMeta = const VerificationMeta(
    'poemText',
  );
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
    'poem_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [poemId, poemTitle, poemText, audioUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'liked_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LikedItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('poem_title')) {
      context.handle(
        _poemTitleMeta,
        poemTitle.isAcceptableOrUnknown(data['poem_title']!, _poemTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTitleMeta);
    }
    if (data.containsKey('poem_text')) {
      context.handle(
        _poemTextMeta,
        poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTextMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {poemId};
  @override
  LikedItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LikedItemsTableData(
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      poemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_title'],
      )!,
      poemText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_text'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
    );
  }

  @override
  $LikedItemsTableTable createAlias(String alias) {
    return $LikedItemsTableTable(attachedDatabase, alias);
  }
}

class LikedItemsTableData extends DataClass
    implements Insertable<LikedItemsTableData> {
  final String poemId;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  const LikedItemsTableData({
    required this.poemId,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    return map;
  }

  LikedItemsTableCompanion toCompanion(bool nullToAbsent) {
    return LikedItemsTableCompanion(
      poemId: Value(poemId),
      poemTitle: Value(poemTitle),
      poemText: Value(poemText),
      audioUrl: Value(audioUrl),
    );
  }

  factory LikedItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LikedItemsTableData(
      poemId: serializer.fromJson<String>(json['poemId']),
      poemTitle: serializer.fromJson<String>(json['poemTitle']),
      poemText: serializer.fromJson<String>(json['poemText']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'poemId': serializer.toJson<String>(poemId),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
    };
  }

  LikedItemsTableData copyWith({
    String? poemId,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
  }) => LikedItemsTableData(
    poemId: poemId ?? this.poemId,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
  );
  LikedItemsTableData copyWithCompanion(LikedItemsTableCompanion data) {
    return LikedItemsTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LikedItemsTableData(')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(poemId, poemTitle, poemText, audioUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikedItemsTableData &&
          other.poemId == this.poemId &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl);
}

class LikedItemsTableCompanion extends UpdateCompanion<LikedItemsTableData> {
  final Value<String> poemId;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<int> rowid;
  const LikedItemsTableCompanion({
    this.poemId = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LikedItemsTableCompanion.insert({
    required String poemId,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText);
  static Insertable<LikedItemsTableData> custom({
    Expression<String>? poemId,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LikedItemsTableCompanion copyWith({
    Value<String>? poemId,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<int>? rowid,
  }) {
    return LikedItemsTableCompanion(
      poemId: poemId ?? this.poemId,
      poemTitle: poemTitle ?? this.poemTitle,
      poemText: poemText ?? this.poemText,
      audioUrl: audioUrl ?? this.audioUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (poemTitle.present) {
      map['poem_title'] = Variable<String>(poemTitle.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LikedItemsTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedItemsTableTable extends SavedItemsTable
    with TableInfo<$SavedItemsTableTable, SavedItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _poemIdMeta = const VerificationMeta('poemId');
  @override
  late final GeneratedColumn<String> poemId = GeneratedColumn<String>(
    'poem_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTitleMeta = const VerificationMeta(
    'poemTitle',
  );
  @override
  late final GeneratedColumn<String> poemTitle = GeneratedColumn<String>(
    'poem_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTextMeta = const VerificationMeta(
    'poemText',
  );
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
    'poem_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [poemId, poemTitle, poemText, audioUrl];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('poem_title')) {
      context.handle(
        _poemTitleMeta,
        poemTitle.isAcceptableOrUnknown(data['poem_title']!, _poemTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTitleMeta);
    }
    if (data.containsKey('poem_text')) {
      context.handle(
        _poemTextMeta,
        poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTextMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {poemId};
  @override
  SavedItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItemsTableData(
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      poemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_title'],
      )!,
      poemText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_text'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
    );
  }

  @override
  $SavedItemsTableTable createAlias(String alias) {
    return $SavedItemsTableTable(attachedDatabase, alias);
  }
}

class SavedItemsTableData extends DataClass
    implements Insertable<SavedItemsTableData> {
  final String poemId;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  const SavedItemsTableData({
    required this.poemId,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    return map;
  }

  SavedItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsTableCompanion(
      poemId: Value(poemId),
      poemTitle: Value(poemTitle),
      poemText: Value(poemText),
      audioUrl: Value(audioUrl),
    );
  }

  factory SavedItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedItemsTableData(
      poemId: serializer.fromJson<String>(json['poemId']),
      poemTitle: serializer.fromJson<String>(json['poemTitle']),
      poemText: serializer.fromJson<String>(json['poemText']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'poemId': serializer.toJson<String>(poemId),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
    };
  }

  SavedItemsTableData copyWith({
    String? poemId,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
  }) => SavedItemsTableData(
    poemId: poemId ?? this.poemId,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
  );
  SavedItemsTableData copyWithCompanion(SavedItemsTableCompanion data) {
    return SavedItemsTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsTableData(')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(poemId, poemTitle, poemText, audioUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItemsTableData &&
          other.poemId == this.poemId &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl);
}

class SavedItemsTableCompanion extends UpdateCompanion<SavedItemsTableData> {
  final Value<String> poemId;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<int> rowid;
  const SavedItemsTableCompanion({
    this.poemId = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedItemsTableCompanion.insert({
    required String poemId,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText);
  static Insertable<SavedItemsTableData> custom({
    Expression<String>? poemId,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedItemsTableCompanion copyWith({
    Value<String>? poemId,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<int>? rowid,
  }) {
    return SavedItemsTableCompanion(
      poemId: poemId ?? this.poemId,
      poemTitle: poemTitle ?? this.poemTitle,
      poemText: poemText ?? this.poemText,
      audioUrl: audioUrl ?? this.audioUrl,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (poemTitle.present) {
      map['poem_title'] = Variable<String>(poemTitle.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HighlightItemsTableTable extends HighlightItemsTable
    with TableInfo<$HighlightItemsTableTable, HighlightItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HighlightItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemKeyMeta = const VerificationMeta(
    'itemKey',
  );
  @override
  late final GeneratedColumn<String> itemKey = GeneratedColumn<String>(
    'item_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemIdMeta = const VerificationMeta('poemId');
  @override
  late final GeneratedColumn<String> poemId = GeneratedColumn<String>(
    'poem_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTitleMeta = const VerificationMeta(
    'poemTitle',
  );
  @override
  late final GeneratedColumn<String> poemTitle = GeneratedColumn<String>(
    'poem_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poemTextMeta = const VerificationMeta(
    'poemText',
  );
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
    'poem_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _audioUrlMeta = const VerificationMeta(
    'audioUrl',
  );
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
    'audio_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _highlightedLineMeta = const VerificationMeta(
    'highlightedLine',
  );
  @override
  late final GeneratedColumn<String> highlightedLine = GeneratedColumn<String>(
    'highlighted_line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIndexMeta = const VerificationMeta(
    'lineIndex',
  );
  @override
  late final GeneratedColumn<int> lineIndex = GeneratedColumn<int>(
    'line_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorValueMeta = const VerificationMeta(
    'colorValue',
  );
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
    'color_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemKey,
    poemId,
    poemTitle,
    poemText,
    audioUrl,
    highlightedLine,
    lineIndex,
    colorValue,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'highlight_items_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HighlightItemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_key')) {
      context.handle(
        _itemKeyMeta,
        itemKey.isAcceptableOrUnknown(data['item_key']!, _itemKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_itemKeyMeta);
    }
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('poem_title')) {
      context.handle(
        _poemTitleMeta,
        poemTitle.isAcceptableOrUnknown(data['poem_title']!, _poemTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTitleMeta);
    }
    if (data.containsKey('poem_text')) {
      context.handle(
        _poemTextMeta,
        poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta),
      );
    } else if (isInserting) {
      context.missing(_poemTextMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(
        _audioUrlMeta,
        audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta),
      );
    }
    if (data.containsKey('highlighted_line')) {
      context.handle(
        _highlightedLineMeta,
        highlightedLine.isAcceptableOrUnknown(
          data['highlighted_line']!,
          _highlightedLineMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_highlightedLineMeta);
    }
    if (data.containsKey('line_index')) {
      context.handle(
        _lineIndexMeta,
        lineIndex.isAcceptableOrUnknown(data['line_index']!, _lineIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIndexMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
        _colorValueMeta,
        colorValue.isAcceptableOrUnknown(data['color_value']!, _colorValueMeta),
      );
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemKey};
  @override
  HighlightItemsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HighlightItemsTableData(
      itemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_key'],
      )!,
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      poemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_title'],
      )!,
      poemText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_text'],
      )!,
      audioUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_url'],
      )!,
      highlightedLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}highlighted_line'],
      )!,
      lineIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_index'],
      )!,
      colorValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color_value'],
      )!,
    );
  }

  @override
  $HighlightItemsTableTable createAlias(String alias) {
    return $HighlightItemsTableTable(attachedDatabase, alias);
  }
}

class HighlightItemsTableData extends DataClass
    implements Insertable<HighlightItemsTableData> {
  final String itemKey;
  final String poemId;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  final String highlightedLine;
  final int lineIndex;
  final int colorValue;
  const HighlightItemsTableData({
    required this.itemKey,
    required this.poemId,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
    required this.highlightedLine,
    required this.lineIndex,
    required this.colorValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_key'] = Variable<String>(itemKey);
    map['poem_id'] = Variable<String>(poemId);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    map['highlighted_line'] = Variable<String>(highlightedLine);
    map['line_index'] = Variable<int>(lineIndex);
    map['color_value'] = Variable<int>(colorValue);
    return map;
  }

  HighlightItemsTableCompanion toCompanion(bool nullToAbsent) {
    return HighlightItemsTableCompanion(
      itemKey: Value(itemKey),
      poemId: Value(poemId),
      poemTitle: Value(poemTitle),
      poemText: Value(poemText),
      audioUrl: Value(audioUrl),
      highlightedLine: Value(highlightedLine),
      lineIndex: Value(lineIndex),
      colorValue: Value(colorValue),
    );
  }

  factory HighlightItemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HighlightItemsTableData(
      itemKey: serializer.fromJson<String>(json['itemKey']),
      poemId: serializer.fromJson<String>(json['poemId']),
      poemTitle: serializer.fromJson<String>(json['poemTitle']),
      poemText: serializer.fromJson<String>(json['poemText']),
      audioUrl: serializer.fromJson<String>(json['audioUrl']),
      highlightedLine: serializer.fromJson<String>(json['highlightedLine']),
      lineIndex: serializer.fromJson<int>(json['lineIndex']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemKey': serializer.toJson<String>(itemKey),
      'poemId': serializer.toJson<String>(poemId),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
      'highlightedLine': serializer.toJson<String>(highlightedLine),
      'lineIndex': serializer.toJson<int>(lineIndex),
      'colorValue': serializer.toJson<int>(colorValue),
    };
  }

  HighlightItemsTableData copyWith({
    String? itemKey,
    String? poemId,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
    String? highlightedLine,
    int? lineIndex,
    int? colorValue,
  }) => HighlightItemsTableData(
    itemKey: itemKey ?? this.itemKey,
    poemId: poemId ?? this.poemId,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
    highlightedLine: highlightedLine ?? this.highlightedLine,
    lineIndex: lineIndex ?? this.lineIndex,
    colorValue: colorValue ?? this.colorValue,
  );
  HighlightItemsTableData copyWithCompanion(HighlightItemsTableCompanion data) {
    return HighlightItemsTableData(
      itemKey: data.itemKey.present ? data.itemKey.value : this.itemKey,
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      highlightedLine: data.highlightedLine.present
          ? data.highlightedLine.value
          : this.highlightedLine,
      lineIndex: data.lineIndex.present ? data.lineIndex.value : this.lineIndex,
      colorValue: data.colorValue.present
          ? data.colorValue.value
          : this.colorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HighlightItemsTableData(')
          ..write('itemKey: $itemKey, ')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('highlightedLine: $highlightedLine, ')
          ..write('lineIndex: $lineIndex, ')
          ..write('colorValue: $colorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    itemKey,
    poemId,
    poemTitle,
    poemText,
    audioUrl,
    highlightedLine,
    lineIndex,
    colorValue,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HighlightItemsTableData &&
          other.itemKey == this.itemKey &&
          other.poemId == this.poemId &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl &&
          other.highlightedLine == this.highlightedLine &&
          other.lineIndex == this.lineIndex &&
          other.colorValue == this.colorValue);
}

class HighlightItemsTableCompanion
    extends UpdateCompanion<HighlightItemsTableData> {
  final Value<String> itemKey;
  final Value<String> poemId;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<String> highlightedLine;
  final Value<int> lineIndex;
  final Value<int> colorValue;
  final Value<int> rowid;
  const HighlightItemsTableCompanion({
    this.itemKey = const Value.absent(),
    this.poemId = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.highlightedLine = const Value.absent(),
    this.lineIndex = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HighlightItemsTableCompanion.insert({
    required String itemKey,
    required String poemId,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    required String highlightedLine,
    required int lineIndex,
    required int colorValue,
    this.rowid = const Value.absent(),
  }) : itemKey = Value(itemKey),
       poemId = Value(poemId),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText),
       highlightedLine = Value(highlightedLine),
       lineIndex = Value(lineIndex),
       colorValue = Value(colorValue);
  static Insertable<HighlightItemsTableData> custom({
    Expression<String>? itemKey,
    Expression<String>? poemId,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<String>? highlightedLine,
    Expression<int>? lineIndex,
    Expression<int>? colorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemKey != null) 'item_key': itemKey,
      if (poemId != null) 'poem_id': poemId,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (highlightedLine != null) 'highlighted_line': highlightedLine,
      if (lineIndex != null) 'line_index': lineIndex,
      if (colorValue != null) 'color_value': colorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HighlightItemsTableCompanion copyWith({
    Value<String>? itemKey,
    Value<String>? poemId,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<String>? highlightedLine,
    Value<int>? lineIndex,
    Value<int>? colorValue,
    Value<int>? rowid,
  }) {
    return HighlightItemsTableCompanion(
      itemKey: itemKey ?? this.itemKey,
      poemId: poemId ?? this.poemId,
      poemTitle: poemTitle ?? this.poemTitle,
      poemText: poemText ?? this.poemText,
      audioUrl: audioUrl ?? this.audioUrl,
      highlightedLine: highlightedLine ?? this.highlightedLine,
      lineIndex: lineIndex ?? this.lineIndex,
      colorValue: colorValue ?? this.colorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemKey.present) {
      map['item_key'] = Variable<String>(itemKey.value);
    }
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (poemTitle.present) {
      map['poem_title'] = Variable<String>(poemTitle.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (highlightedLine.present) {
      map['highlighted_line'] = Variable<String>(highlightedLine.value);
    }
    if (lineIndex.present) {
      map['line_index'] = Variable<int>(lineIndex.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HighlightItemsTableCompanion(')
          ..write('itemKey: $itemKey, ')
          ..write('poemId: $poemId, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('highlightedLine: $highlightedLine, ')
          ..write('lineIndex: $lineIndex, ')
          ..write('colorValue: $colorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReadPoemsTableTable extends ReadPoemsTable
    with TableInfo<$ReadPoemsTableTable, ReadPoemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadPoemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _poemIdMeta = const VerificationMeta('poemId');
  @override
  late final GeneratedColumn<String> poemId = GeneratedColumn<String>(
    'poem_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [poemId, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'read_poems_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadPoemsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {poemId};
  @override
  ReadPoemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadPoemsTableData(
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $ReadPoemsTableTable createAlias(String alias) {
    return $ReadPoemsTableTable(attachedDatabase, alias);
  }
}

class ReadPoemsTableData extends DataClass
    implements Insertable<ReadPoemsTableData> {
  final String poemId;
  final DateTime? readAt;
  const ReadPoemsTableData({required this.poemId, this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  ReadPoemsTableCompanion toCompanion(bool nullToAbsent) {
    return ReadPoemsTableCompanion(
      poemId: Value(poemId),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory ReadPoemsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadPoemsTableData(
      poemId: serializer.fromJson<String>(json['poemId']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'poemId': serializer.toJson<String>(poemId),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  ReadPoemsTableData copyWith({
    String? poemId,
    Value<DateTime?> readAt = const Value.absent(),
  }) => ReadPoemsTableData(
    poemId: poemId ?? this.poemId,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  ReadPoemsTableData copyWithCompanion(ReadPoemsTableCompanion data) {
    return ReadPoemsTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadPoemsTableData(')
          ..write('poemId: $poemId, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(poemId, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadPoemsTableData &&
          other.poemId == this.poemId &&
          other.readAt == this.readAt);
}

class ReadPoemsTableCompanion extends UpdateCompanion<ReadPoemsTableData> {
  final Value<String> poemId;
  final Value<DateTime?> readAt;
  final Value<int> rowid;
  const ReadPoemsTableCompanion({
    this.poemId = const Value.absent(),
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReadPoemsTableCompanion.insert({
    required String poemId,
    this.readAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId);
  static Insertable<ReadPoemsTableData> custom({
    Expression<String>? poemId,
    Expression<DateTime>? readAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (readAt != null) 'read_at': readAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReadPoemsTableCompanion copyWith({
    Value<String>? poemId,
    Value<DateTime?>? readAt,
    Value<int>? rowid,
  }) {
    return ReadPoemsTableCompanion(
      poemId: poemId ?? this.poemId,
      readAt: readAt ?? this.readAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadPoemsTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('readAt: $readAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _settingKeyMeta = const VerificationMeta(
    'settingKey',
  );
  @override
  late final GeneratedColumn<String> settingKey = GeneratedColumn<String>(
    'setting_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _settingValueMeta = const VerificationMeta(
    'settingValue',
  );
  @override
  late final GeneratedColumn<String> settingValue = GeneratedColumn<String>(
    'setting_value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [settingKey, settingValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('setting_key')) {
      context.handle(
        _settingKeyMeta,
        settingKey.isAcceptableOrUnknown(data['setting_key']!, _settingKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_settingKeyMeta);
    }
    if (data.containsKey('setting_value')) {
      context.handle(
        _settingValueMeta,
        settingValue.isAcceptableOrUnknown(
          data['setting_value']!,
          _settingValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_settingValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {settingKey};
  @override
  SettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsTableData(
      settingKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_key'],
      )!,
      settingValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}setting_value'],
      )!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsTableData extends DataClass
    implements Insertable<SettingsTableData> {
  final String settingKey;
  final String settingValue;
  const SettingsTableData({
    required this.settingKey,
    required this.settingValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['setting_key'] = Variable<String>(settingKey);
    map['setting_value'] = Variable<String>(settingValue);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      settingKey: Value(settingKey),
      settingValue: Value(settingValue),
    );
  }

  factory SettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsTableData(
      settingKey: serializer.fromJson<String>(json['settingKey']),
      settingValue: serializer.fromJson<String>(json['settingValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'settingKey': serializer.toJson<String>(settingKey),
      'settingValue': serializer.toJson<String>(settingValue),
    };
  }

  SettingsTableData copyWith({String? settingKey, String? settingValue}) =>
      SettingsTableData(
        settingKey: settingKey ?? this.settingKey,
        settingValue: settingValue ?? this.settingValue,
      );
  SettingsTableData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsTableData(
      settingKey: data.settingKey.present
          ? data.settingKey.value
          : this.settingKey,
      settingValue: data.settingValue.present
          ? data.settingValue.value
          : this.settingValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableData(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(settingKey, settingValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsTableData &&
          other.settingKey == this.settingKey &&
          other.settingValue == this.settingValue);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsTableData> {
  final Value<String> settingKey;
  final Value<String> settingValue;
  final Value<int> rowid;
  const SettingsTableCompanion({
    this.settingKey = const Value.absent(),
    this.settingValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    required String settingKey,
    required String settingValue,
    this.rowid = const Value.absent(),
  }) : settingKey = Value(settingKey),
       settingValue = Value(settingValue);
  static Insertable<SettingsTableData> custom({
    Expression<String>? settingKey,
    Expression<String>? settingValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (settingKey != null) 'setting_key': settingKey,
      if (settingValue != null) 'setting_value': settingValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsTableCompanion copyWith({
    Value<String>? settingKey,
    Value<String>? settingValue,
    Value<int>? rowid,
  }) {
    return SettingsTableCompanion(
      settingKey: settingKey ?? this.settingKey,
      settingValue: settingValue ?? this.settingValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (settingKey.present) {
      map['setting_key'] = Variable<String>(settingKey.value);
    }
    if (settingValue.present) {
      map['setting_value'] = Variable<String>(settingValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('settingKey: $settingKey, ')
          ..write('settingValue: $settingValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PoemCacheTableTable poemCacheTable = $PoemCacheTableTable(this);
  late final $LikedItemsTableTable likedItemsTable = $LikedItemsTableTable(
    this,
  );
  late final $SavedItemsTableTable savedItemsTable = $SavedItemsTableTable(
    this,
  );
  late final $HighlightItemsTableTable highlightItemsTable =
      $HighlightItemsTableTable(this);
  late final $ReadPoemsTableTable readPoemsTable = $ReadPoemsTableTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    poemCacheTable,
    likedItemsTable,
    savedItemsTable,
    highlightItemsTable,
    readPoemsTable,
    settingsTable,
  ];
}

typedef $$PoemCacheTableTableCreateCompanionBuilder =
    PoemCacheTableCompanion Function({
      required String poemId,
      required String category,
      required String poemTitle,
      Value<String> poemText,
      Value<String> audioUrl,
      Value<bool> hasFullText,
      Value<String?> kind,
      Value<int> rowid,
    });
typedef $$PoemCacheTableTableUpdateCompanionBuilder =
    PoemCacheTableCompanion Function({
      Value<String> poemId,
      Value<String> category,
      Value<String> poemTitle,
      Value<String> poemText,
      Value<String> audioUrl,
      Value<bool> hasFullText,
      Value<String?> kind,
      Value<int> rowid,
    });

class $$PoemCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $PoemCacheTableTable> {
  $$PoemCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasFullText => $composableBuilder(
    column: $table.hasFullText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PoemCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PoemCacheTableTable> {
  $$PoemCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasFullText => $composableBuilder(
    column: $table.hasFullText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PoemCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PoemCacheTableTable> {
  $$PoemCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get poemTitle =>
      $composableBuilder(column: $table.poemTitle, builder: (column) => column);

  GeneratedColumn<String> get poemText =>
      $composableBuilder(column: $table.poemText, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<bool> get hasFullText => $composableBuilder(
    column: $table.hasFullText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);
}

class $$PoemCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PoemCacheTableTable,
          PoemCacheTableData,
          $$PoemCacheTableTableFilterComposer,
          $$PoemCacheTableTableOrderingComposer,
          $$PoemCacheTableTableAnnotationComposer,
          $$PoemCacheTableTableCreateCompanionBuilder,
          $$PoemCacheTableTableUpdateCompanionBuilder,
          (
            PoemCacheTableData,
            BaseReferences<
              _$AppDatabase,
              $PoemCacheTableTable,
              PoemCacheTableData
            >,
          ),
          PoemCacheTableData,
          PrefetchHooks Function()
        > {
  $$PoemCacheTableTableTableManager(
    _$AppDatabase db,
    $PoemCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PoemCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PoemCacheTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PoemCacheTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> poemId = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<bool> hasFullText = const Value.absent(),
                Value<String?> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PoemCacheTableCompanion(
                poemId: poemId,
                category: category,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                hasFullText: hasFullText,
                kind: kind,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                required String category,
                required String poemTitle,
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<bool> hasFullText = const Value.absent(),
                Value<String?> kind = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PoemCacheTableCompanion.insert(
                poemId: poemId,
                category: category,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                hasFullText: hasFullText,
                kind: kind,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PoemCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PoemCacheTableTable,
      PoemCacheTableData,
      $$PoemCacheTableTableFilterComposer,
      $$PoemCacheTableTableOrderingComposer,
      $$PoemCacheTableTableAnnotationComposer,
      $$PoemCacheTableTableCreateCompanionBuilder,
      $$PoemCacheTableTableUpdateCompanionBuilder,
      (
        PoemCacheTableData,
        BaseReferences<_$AppDatabase, $PoemCacheTableTable, PoemCacheTableData>,
      ),
      PoemCacheTableData,
      PrefetchHooks Function()
    >;
typedef $$LikedItemsTableTableCreateCompanionBuilder =
    LikedItemsTableCompanion Function({
      required String poemId,
      required String poemTitle,
      required String poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });
typedef $$LikedItemsTableTableUpdateCompanionBuilder =
    LikedItemsTableCompanion Function({
      Value<String> poemId,
      Value<String> poemTitle,
      Value<String> poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });

class $$LikedItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LikedItemsTableTable> {
  $$LikedItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LikedItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LikedItemsTableTable> {
  $$LikedItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LikedItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LikedItemsTableTable> {
  $$LikedItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<String> get poemTitle =>
      $composableBuilder(column: $table.poemTitle, builder: (column) => column);

  GeneratedColumn<String> get poemText =>
      $composableBuilder(column: $table.poemText, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);
}

class $$LikedItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LikedItemsTableTable,
          LikedItemsTableData,
          $$LikedItemsTableTableFilterComposer,
          $$LikedItemsTableTableOrderingComposer,
          $$LikedItemsTableTableAnnotationComposer,
          $$LikedItemsTableTableCreateCompanionBuilder,
          $$LikedItemsTableTableUpdateCompanionBuilder,
          (
            LikedItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $LikedItemsTableTable,
              LikedItemsTableData
            >,
          ),
          LikedItemsTableData,
          PrefetchHooks Function()
        > {
  $$LikedItemsTableTableTableManager(
    _$AppDatabase db,
    $LikedItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LikedItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LikedItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LikedItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> poemId = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LikedItemsTableCompanion(
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                required String poemTitle,
                required String poemText,
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LikedItemsTableCompanion.insert(
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LikedItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LikedItemsTableTable,
      LikedItemsTableData,
      $$LikedItemsTableTableFilterComposer,
      $$LikedItemsTableTableOrderingComposer,
      $$LikedItemsTableTableAnnotationComposer,
      $$LikedItemsTableTableCreateCompanionBuilder,
      $$LikedItemsTableTableUpdateCompanionBuilder,
      (
        LikedItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $LikedItemsTableTable,
          LikedItemsTableData
        >,
      ),
      LikedItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$SavedItemsTableTableCreateCompanionBuilder =
    SavedItemsTableCompanion Function({
      required String poemId,
      required String poemTitle,
      required String poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });
typedef $$SavedItemsTableTableUpdateCompanionBuilder =
    SavedItemsTableCompanion Function({
      Value<String> poemId,
      Value<String> poemTitle,
      Value<String> poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });

class $$SavedItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavedItemsTableTable> {
  $$SavedItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedItemsTableTable> {
  $$SavedItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedItemsTableTable> {
  $$SavedItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<String> get poemTitle =>
      $composableBuilder(column: $table.poemTitle, builder: (column) => column);

  GeneratedColumn<String> get poemText =>
      $composableBuilder(column: $table.poemText, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);
}

class $$SavedItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedItemsTableTable,
          SavedItemsTableData,
          $$SavedItemsTableTableFilterComposer,
          $$SavedItemsTableTableOrderingComposer,
          $$SavedItemsTableTableAnnotationComposer,
          $$SavedItemsTableTableCreateCompanionBuilder,
          $$SavedItemsTableTableUpdateCompanionBuilder,
          (
            SavedItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $SavedItemsTableTable,
              SavedItemsTableData
            >,
          ),
          SavedItemsTableData,
          PrefetchHooks Function()
        > {
  $$SavedItemsTableTableTableManager(
    _$AppDatabase db,
    $SavedItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> poemId = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsTableCompanion(
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                required String poemTitle,
                required String poemText,
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsTableCompanion.insert(
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedItemsTableTable,
      SavedItemsTableData,
      $$SavedItemsTableTableFilterComposer,
      $$SavedItemsTableTableOrderingComposer,
      $$SavedItemsTableTableAnnotationComposer,
      $$SavedItemsTableTableCreateCompanionBuilder,
      $$SavedItemsTableTableUpdateCompanionBuilder,
      (
        SavedItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $SavedItemsTableTable,
          SavedItemsTableData
        >,
      ),
      SavedItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$HighlightItemsTableTableCreateCompanionBuilder =
    HighlightItemsTableCompanion Function({
      required String itemKey,
      required String poemId,
      required String poemTitle,
      required String poemText,
      Value<String> audioUrl,
      required String highlightedLine,
      required int lineIndex,
      required int colorValue,
      Value<int> rowid,
    });
typedef $$HighlightItemsTableTableUpdateCompanionBuilder =
    HighlightItemsTableCompanion Function({
      Value<String> itemKey,
      Value<String> poemId,
      Value<String> poemTitle,
      Value<String> poemText,
      Value<String> audioUrl,
      Value<String> highlightedLine,
      Value<int> lineIndex,
      Value<int> colorValue,
      Value<int> rowid,
    });

class $$HighlightItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $HighlightItemsTableTable> {
  $$HighlightItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get highlightedLine => $composableBuilder(
    column: $table.highlightedLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lineIndex => $composableBuilder(
    column: $table.lineIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HighlightItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HighlightItemsTableTable> {
  $$HighlightItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemKey => $composableBuilder(
    column: $table.itemKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemTitle => $composableBuilder(
    column: $table.poemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemText => $composableBuilder(
    column: $table.poemText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioUrl => $composableBuilder(
    column: $table.audioUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get highlightedLine => $composableBuilder(
    column: $table.highlightedLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lineIndex => $composableBuilder(
    column: $table.lineIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HighlightItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HighlightItemsTableTable> {
  $$HighlightItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemKey =>
      $composableBuilder(column: $table.itemKey, builder: (column) => column);

  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<String> get poemTitle =>
      $composableBuilder(column: $table.poemTitle, builder: (column) => column);

  GeneratedColumn<String> get poemText =>
      $composableBuilder(column: $table.poemText, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get highlightedLine => $composableBuilder(
    column: $table.highlightedLine,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lineIndex =>
      $composableBuilder(column: $table.lineIndex, builder: (column) => column);

  GeneratedColumn<int> get colorValue => $composableBuilder(
    column: $table.colorValue,
    builder: (column) => column,
  );
}

class $$HighlightItemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HighlightItemsTableTable,
          HighlightItemsTableData,
          $$HighlightItemsTableTableFilterComposer,
          $$HighlightItemsTableTableOrderingComposer,
          $$HighlightItemsTableTableAnnotationComposer,
          $$HighlightItemsTableTableCreateCompanionBuilder,
          $$HighlightItemsTableTableUpdateCompanionBuilder,
          (
            HighlightItemsTableData,
            BaseReferences<
              _$AppDatabase,
              $HighlightItemsTableTable,
              HighlightItemsTableData
            >,
          ),
          HighlightItemsTableData,
          PrefetchHooks Function()
        > {
  $$HighlightItemsTableTableTableManager(
    _$AppDatabase db,
    $HighlightItemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HighlightItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HighlightItemsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$HighlightItemsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> itemKey = const Value.absent(),
                Value<String> poemId = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<String> highlightedLine = const Value.absent(),
                Value<int> lineIndex = const Value.absent(),
                Value<int> colorValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HighlightItemsTableCompanion(
                itemKey: itemKey,
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                highlightedLine: highlightedLine,
                lineIndex: lineIndex,
                colorValue: colorValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemKey,
                required String poemId,
                required String poemTitle,
                required String poemText,
                Value<String> audioUrl = const Value.absent(),
                required String highlightedLine,
                required int lineIndex,
                required int colorValue,
                Value<int> rowid = const Value.absent(),
              }) => HighlightItemsTableCompanion.insert(
                itemKey: itemKey,
                poemId: poemId,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                highlightedLine: highlightedLine,
                lineIndex: lineIndex,
                colorValue: colorValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HighlightItemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HighlightItemsTableTable,
      HighlightItemsTableData,
      $$HighlightItemsTableTableFilterComposer,
      $$HighlightItemsTableTableOrderingComposer,
      $$HighlightItemsTableTableAnnotationComposer,
      $$HighlightItemsTableTableCreateCompanionBuilder,
      $$HighlightItemsTableTableUpdateCompanionBuilder,
      (
        HighlightItemsTableData,
        BaseReferences<
          _$AppDatabase,
          $HighlightItemsTableTable,
          HighlightItemsTableData
        >,
      ),
      HighlightItemsTableData,
      PrefetchHooks Function()
    >;
typedef $$ReadPoemsTableTableCreateCompanionBuilder =
    ReadPoemsTableCompanion Function({
      required String poemId,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });
typedef $$ReadPoemsTableTableUpdateCompanionBuilder =
    ReadPoemsTableCompanion Function({
      Value<String> poemId,
      Value<DateTime?> readAt,
      Value<int> rowid,
    });

class $$ReadPoemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReadPoemsTableTable> {
  $$ReadPoemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReadPoemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadPoemsTableTable> {
  $$ReadPoemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReadPoemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadPoemsTableTable> {
  $$ReadPoemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$ReadPoemsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadPoemsTableTable,
          ReadPoemsTableData,
          $$ReadPoemsTableTableFilterComposer,
          $$ReadPoemsTableTableOrderingComposer,
          $$ReadPoemsTableTableAnnotationComposer,
          $$ReadPoemsTableTableCreateCompanionBuilder,
          $$ReadPoemsTableTableUpdateCompanionBuilder,
          (
            ReadPoemsTableData,
            BaseReferences<
              _$AppDatabase,
              $ReadPoemsTableTable,
              ReadPoemsTableData
            >,
          ),
          ReadPoemsTableData,
          PrefetchHooks Function()
        > {
  $$ReadPoemsTableTableTableManager(
    _$AppDatabase db,
    $ReadPoemsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadPoemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadPoemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadPoemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> poemId = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadPoemsTableCompanion(
                poemId: poemId,
                readAt: readAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                Value<DateTime?> readAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReadPoemsTableCompanion.insert(
                poemId: poemId,
                readAt: readAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReadPoemsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadPoemsTableTable,
      ReadPoemsTableData,
      $$ReadPoemsTableTableFilterComposer,
      $$ReadPoemsTableTableOrderingComposer,
      $$ReadPoemsTableTableAnnotationComposer,
      $$ReadPoemsTableTableCreateCompanionBuilder,
      $$ReadPoemsTableTableUpdateCompanionBuilder,
      (
        ReadPoemsTableData,
        BaseReferences<_$AppDatabase, $ReadPoemsTableTable, ReadPoemsTableData>,
      ),
      ReadPoemsTableData,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      required String settingKey,
      required String settingValue,
      Value<int> rowid,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<String> settingKey,
      Value<String> settingValue,
      Value<int> rowid,
    });

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get settingKey => $composableBuilder(
    column: $table.settingKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get settingValue => $composableBuilder(
    column: $table.settingValue,
    builder: (column) => column,
  );
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsTableData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (
            SettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $SettingsTableTable,
              SettingsTableData
            >,
          ),
          SettingsTableData,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> settingKey = const Value.absent(),
                Value<String> settingValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String settingKey,
                required String settingValue,
                Value<int> rowid = const Value.absent(),
              }) => SettingsTableCompanion.insert(
                settingKey: settingKey,
                settingValue: settingValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsTableData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (
        SettingsTableData,
        BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsTableData>,
      ),
      SettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PoemCacheTableTableTableManager get poemCacheTable =>
      $$PoemCacheTableTableTableManager(_db, _db.poemCacheTable);
  $$LikedItemsTableTableTableManager get likedItemsTable =>
      $$LikedItemsTableTableTableManager(_db, _db.likedItemsTable);
  $$SavedItemsTableTableTableManager get savedItemsTable =>
      $$SavedItemsTableTableTableManager(_db, _db.savedItemsTable);
  $$HighlightItemsTableTableTableManager get highlightItemsTable =>
      $$HighlightItemsTableTableTableManager(_db, _db.highlightItemsTable);
  $$ReadPoemsTableTableTableManager get readPoemsTable =>
      $$ReadPoemsTableTableTableManager(_db, _db.readPoemsTable);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
}
