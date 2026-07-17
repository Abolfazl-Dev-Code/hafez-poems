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
  List<GeneratedColumn> get $columns => [
    poemId,
    category,
    poemTitle,
    poemText,
    audioUrl,
  ];
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
  Set<GeneratedColumn> get $primaryKey => {poemId, category};
  @override
  LikedItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LikedItemsTableData(
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
  final String category;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  const LikedItemsTableData({
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    map['category'] = Variable<String>(category);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    return map;
  }

  LikedItemsTableCompanion toCompanion(bool nullToAbsent) {
    return LikedItemsTableCompanion(
      poemId: Value(poemId),
      category: Value(category),
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
      category: serializer.fromJson<String>(json['category']),
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
      'category': serializer.toJson<String>(category),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
    };
  }

  LikedItemsTableData copyWith({
    String? poemId,
    String? category,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
  }) => LikedItemsTableData(
    poemId: poemId ?? this.poemId,
    category: category ?? this.category,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
  );
  LikedItemsTableData copyWithCompanion(LikedItemsTableCompanion data) {
    return LikedItemsTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      category: data.category.present ? data.category.value : this.category,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LikedItemsTableData(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(poemId, category, poemTitle, poemText, audioUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LikedItemsTableData &&
          other.poemId == this.poemId &&
          other.category == this.category &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl);
}

class LikedItemsTableCompanion extends UpdateCompanion<LikedItemsTableData> {
  final Value<String> poemId;
  final Value<String> category;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<int> rowid;
  const LikedItemsTableCompanion({
    this.poemId = const Value.absent(),
    this.category = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LikedItemsTableCompanion.insert({
    required String poemId,
    required String category,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId),
       category = Value(category),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText);
  static Insertable<LikedItemsTableData> custom({
    Expression<String>? poemId,
    Expression<String>? category,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (category != null) 'category': category,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LikedItemsTableCompanion copyWith({
    Value<String>? poemId,
    Value<String>? category,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<int>? rowid,
  }) {
    return LikedItemsTableCompanion(
      poemId: poemId ?? this.poemId,
      category: category ?? this.category,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LikedItemsTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
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
  List<GeneratedColumn> get $columns => [
    poemId,
    category,
    poemTitle,
    poemText,
    audioUrl,
  ];
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
  Set<GeneratedColumn> get $primaryKey => {poemId, category};
  @override
  SavedItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedItemsTableData(
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
  final String category;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  const SavedItemsTableData({
    required this.poemId,
    required this.category,
    required this.poemTitle,
    required this.poemText,
    required this.audioUrl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['poem_id'] = Variable<String>(poemId);
    map['category'] = Variable<String>(category);
    map['poem_title'] = Variable<String>(poemTitle);
    map['poem_text'] = Variable<String>(poemText);
    map['audio_url'] = Variable<String>(audioUrl);
    return map;
  }

  SavedItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SavedItemsTableCompanion(
      poemId: Value(poemId),
      category: Value(category),
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
      category: serializer.fromJson<String>(json['category']),
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
      'category': serializer.toJson<String>(category),
      'poemTitle': serializer.toJson<String>(poemTitle),
      'poemText': serializer.toJson<String>(poemText),
      'audioUrl': serializer.toJson<String>(audioUrl),
    };
  }

  SavedItemsTableData copyWith({
    String? poemId,
    String? category,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
  }) => SavedItemsTableData(
    poemId: poemId ?? this.poemId,
    category: category ?? this.category,
    poemTitle: poemTitle ?? this.poemTitle,
    poemText: poemText ?? this.poemText,
    audioUrl: audioUrl ?? this.audioUrl,
  );
  SavedItemsTableData copyWithCompanion(SavedItemsTableCompanion data) {
    return SavedItemsTableData(
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      category: data.category.present ? data.category.value : this.category,
      poemTitle: data.poemTitle.present ? data.poemTitle.value : this.poemTitle,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsTableData(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
          ..write('poemTitle: $poemTitle, ')
          ..write('poemText: $poemText, ')
          ..write('audioUrl: $audioUrl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(poemId, category, poemTitle, poemText, audioUrl);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedItemsTableData &&
          other.poemId == this.poemId &&
          other.category == this.category &&
          other.poemTitle == this.poemTitle &&
          other.poemText == this.poemText &&
          other.audioUrl == this.audioUrl);
}

class SavedItemsTableCompanion extends UpdateCompanion<SavedItemsTableData> {
  final Value<String> poemId;
  final Value<String> category;
  final Value<String> poemTitle;
  final Value<String> poemText;
  final Value<String> audioUrl;
  final Value<int> rowid;
  const SavedItemsTableCompanion({
    this.poemId = const Value.absent(),
    this.category = const Value.absent(),
    this.poemTitle = const Value.absent(),
    this.poemText = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedItemsTableCompanion.insert({
    required String poemId,
    required String category,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : poemId = Value(poemId),
       category = Value(category),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText);
  static Insertable<SavedItemsTableData> custom({
    Expression<String>? poemId,
    Expression<String>? category,
    Expression<String>? poemTitle,
    Expression<String>? poemText,
    Expression<String>? audioUrl,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (poemId != null) 'poem_id': poemId,
      if (category != null) 'category': category,
      if (poemTitle != null) 'poem_title': poemTitle,
      if (poemText != null) 'poem_text': poemText,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedItemsTableCompanion copyWith({
    Value<String>? poemId,
    Value<String>? category,
    Value<String>? poemTitle,
    Value<String>? poemText,
    Value<String>? audioUrl,
    Value<int>? rowid,
  }) {
    return SavedItemsTableCompanion(
      poemId: poemId ?? this.poemId,
      category: category ?? this.category,
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedItemsTableCompanion(')
          ..write('poemId: $poemId, ')
          ..write('category: $category, ')
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
    category,
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
  final String category;
  final String poemTitle;
  final String poemText;
  final String audioUrl;
  final String highlightedLine;
  final int lineIndex;
  final int colorValue;
  const HighlightItemsTableData({
    required this.itemKey,
    required this.poemId,
    required this.category,
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
    map['category'] = Variable<String>(category);
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
      category: Value(category),
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
      category: serializer.fromJson<String>(json['category']),
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
      'category': serializer.toJson<String>(category),
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
    String? category,
    String? poemTitle,
    String? poemText,
    String? audioUrl,
    String? highlightedLine,
    int? lineIndex,
    int? colorValue,
  }) => HighlightItemsTableData(
    itemKey: itemKey ?? this.itemKey,
    poemId: poemId ?? this.poemId,
    category: category ?? this.category,
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
      category: data.category.present ? data.category.value : this.category,
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
          ..write('category: $category, ')
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
    category,
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
          other.category == this.category &&
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
  final Value<String> category;
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
    this.category = const Value.absent(),
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
    required String category,
    required String poemTitle,
    required String poemText,
    this.audioUrl = const Value.absent(),
    required String highlightedLine,
    required int lineIndex,
    required int colorValue,
    this.rowid = const Value.absent(),
  }) : itemKey = Value(itemKey),
       poemId = Value(poemId),
       category = Value(category),
       poemTitle = Value(poemTitle),
       poemText = Value(poemText),
       highlightedLine = Value(highlightedLine),
       lineIndex = Value(lineIndex),
       colorValue = Value(colorValue);
  static Insertable<HighlightItemsTableData> custom({
    Expression<String>? itemKey,
    Expression<String>? poemId,
    Expression<String>? category,
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
      if (category != null) 'category': category,
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
    Value<String>? category,
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
      category: category ?? this.category,
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
          ..write('category: $category, ')
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

class $DownloadedAudioTableTable extends DownloadedAudioTable
    with TableInfo<$DownloadedAudioTableTable, DownloadedAudioRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadedAudioTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _poemCategoryMeta = const VerificationMeta(
    'poemCategory',
  );
  @override
  late final GeneratedColumn<String> poemCategory = GeneratedColumn<String>(
    'poem_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reciterKeyMeta = const VerificationMeta(
    'reciterKey',
  );
  @override
  late final GeneratedColumn<String> reciterKey = GeneratedColumn<String>(
    'reciter_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reciterDisplayNameMeta =
      const VerificationMeta('reciterDisplayName');
  @override
  late final GeneratedColumn<String> reciterDisplayName =
      GeneratedColumn<String>(
        'reciter_display_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _sourceRecitationIdMeta =
      const VerificationMeta('sourceRecitationId');
  @override
  late final GeneratedColumn<int> sourceRecitationId = GeneratedColumn<int>(
    'source_recitation_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localFilePathMeta = const VerificationMeta(
    'localFilePath',
  );
  @override
  late final GeneratedColumn<String> localFilePath = GeneratedColumn<String>(
    'local_file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceUrlMeta = const VerificationMeta(
    'sourceUrl',
  );
  @override
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncXmlMeta = const VerificationMeta(
    'syncXml',
  );
  @override
  late final GeneratedColumn<String> syncXml = GeneratedColumn<String>(
    'sync_xml',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fileSizeBytesMeta = const VerificationMeta(
    'fileSizeBytes',
  );
  @override
  late final GeneratedColumn<int> fileSizeBytes = GeneratedColumn<int>(
    'file_size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checksumMeta = const VerificationMeta(
    'checksum',
  );
  @override
  late final GeneratedColumn<String> checksum = GeneratedColumn<String>(
    'checksum',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadedAtMeta = const VerificationMeta(
    'downloadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
    'downloaded_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastPlayedAtMeta = const VerificationMeta(
    'lastPlayedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedAt = GeneratedColumn<DateTime>(
    'last_played_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _playCountMeta = const VerificationMeta(
    'playCount',
  );
  @override
  late final GeneratedColumn<int> playCount = GeneratedColumn<int>(
    'play_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DownloadStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('notDownloaded'),
      ).withConverter<DownloadStatus>(
        $DownloadedAudioTableTable.$converterstatus,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    poemId,
    poemCategory,
    reciterKey,
    reciterDisplayName,
    sourceRecitationId,
    localFilePath,
    sourceUrl,
    fileName,
    syncXml,
    fileSizeBytes,
    durationMs,
    checksum,
    downloadedAt,
    lastPlayedAt,
    playCount,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'downloaded_audio_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadedAudioRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('poem_id')) {
      context.handle(
        _poemIdMeta,
        poemId.isAcceptableOrUnknown(data['poem_id']!, _poemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poemIdMeta);
    }
    if (data.containsKey('poem_category')) {
      context.handle(
        _poemCategoryMeta,
        poemCategory.isAcceptableOrUnknown(
          data['poem_category']!,
          _poemCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_poemCategoryMeta);
    }
    if (data.containsKey('reciter_key')) {
      context.handle(
        _reciterKeyMeta,
        reciterKey.isAcceptableOrUnknown(data['reciter_key']!, _reciterKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_reciterKeyMeta);
    }
    if (data.containsKey('reciter_display_name')) {
      context.handle(
        _reciterDisplayNameMeta,
        reciterDisplayName.isAcceptableOrUnknown(
          data['reciter_display_name']!,
          _reciterDisplayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reciterDisplayNameMeta);
    }
    if (data.containsKey('source_recitation_id')) {
      context.handle(
        _sourceRecitationIdMeta,
        sourceRecitationId.isAcceptableOrUnknown(
          data['source_recitation_id']!,
          _sourceRecitationIdMeta,
        ),
      );
    }
    if (data.containsKey('local_file_path')) {
      context.handle(
        _localFilePathMeta,
        localFilePath.isAcceptableOrUnknown(
          data['local_file_path']!,
          _localFilePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localFilePathMeta);
    }
    if (data.containsKey('source_url')) {
      context.handle(
        _sourceUrlMeta,
        sourceUrl.isAcceptableOrUnknown(data['source_url']!, _sourceUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUrlMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('sync_xml')) {
      context.handle(
        _syncXmlMeta,
        syncXml.isAcceptableOrUnknown(data['sync_xml']!, _syncXmlMeta),
      );
    }
    if (data.containsKey('file_size_bytes')) {
      context.handle(
        _fileSizeBytesMeta,
        fileSizeBytes.isAcceptableOrUnknown(
          data['file_size_bytes']!,
          _fileSizeBytesMeta,
        ),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('checksum')) {
      context.handle(
        _checksumMeta,
        checksum.isAcceptableOrUnknown(data['checksum']!, _checksumMeta),
      );
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
        _downloadedAtMeta,
        downloadedAt.isAcceptableOrUnknown(
          data['downloaded_at']!,
          _downloadedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_played_at')) {
      context.handle(
        _lastPlayedAtMeta,
        lastPlayedAt.isAcceptableOrUnknown(
          data['last_played_at']!,
          _lastPlayedAtMeta,
        ),
      );
    }
    if (data.containsKey('play_count')) {
      context.handle(
        _playCountMeta,
        playCount.isAcceptableOrUnknown(data['play_count']!, _playCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {poemId, poemCategory, reciterKey},
  ];
  @override
  DownloadedAudioRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadedAudioRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      poemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_id'],
      )!,
      poemCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poem_category'],
      )!,
      reciterKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reciter_key'],
      )!,
      reciterDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reciter_display_name'],
      )!,
      sourceRecitationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}source_recitation_id'],
      ),
      localFilePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_file_path'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      syncXml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_xml'],
      ),
      fileSizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}file_size_bytes'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      checksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checksum'],
      ),
      downloadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}downloaded_at'],
      ),
      lastPlayedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_at'],
      ),
      playCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}play_count'],
      )!,
      status: $DownloadedAudioTableTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
    );
  }

  @override
  $DownloadedAudioTableTable createAlias(String alias) {
    return $DownloadedAudioTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<DownloadStatus, String, String> $converterstatus =
      const EnumNameConverter<DownloadStatus>(DownloadStatus.values);
}

class DownloadedAudioRow extends DataClass
    implements Insertable<DownloadedAudioRow> {
  final int id;
  final String poemId;
  final String poemCategory;
  final String reciterKey;
  final String reciterDisplayName;
  final int? sourceRecitationId;
  final String localFilePath;
  final String sourceUrl;
  final String fileName;
  final String? syncXml;
  final int fileSizeBytes;
  final int? durationMs;
  final String? checksum;
  final DateTime? downloadedAt;
  final DateTime? lastPlayedAt;
  final int playCount;
  final DownloadStatus status;
  const DownloadedAudioRow({
    required this.id,
    required this.poemId,
    required this.poemCategory,
    required this.reciterKey,
    required this.reciterDisplayName,
    this.sourceRecitationId,
    required this.localFilePath,
    required this.sourceUrl,
    required this.fileName,
    this.syncXml,
    required this.fileSizeBytes,
    this.durationMs,
    this.checksum,
    this.downloadedAt,
    this.lastPlayedAt,
    required this.playCount,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['poem_id'] = Variable<String>(poemId);
    map['poem_category'] = Variable<String>(poemCategory);
    map['reciter_key'] = Variable<String>(reciterKey);
    map['reciter_display_name'] = Variable<String>(reciterDisplayName);
    if (!nullToAbsent || sourceRecitationId != null) {
      map['source_recitation_id'] = Variable<int>(sourceRecitationId);
    }
    map['local_file_path'] = Variable<String>(localFilePath);
    map['source_url'] = Variable<String>(sourceUrl);
    map['file_name'] = Variable<String>(fileName);
    if (!nullToAbsent || syncXml != null) {
      map['sync_xml'] = Variable<String>(syncXml);
    }
    map['file_size_bytes'] = Variable<int>(fileSizeBytes);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    if (!nullToAbsent || checksum != null) {
      map['checksum'] = Variable<String>(checksum);
    }
    if (!nullToAbsent || downloadedAt != null) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    }
    if (!nullToAbsent || lastPlayedAt != null) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt);
    }
    map['play_count'] = Variable<int>(playCount);
    {
      map['status'] = Variable<String>(
        $DownloadedAudioTableTable.$converterstatus.toSql(status),
      );
    }
    return map;
  }

  DownloadedAudioTableCompanion toCompanion(bool nullToAbsent) {
    return DownloadedAudioTableCompanion(
      id: Value(id),
      poemId: Value(poemId),
      poemCategory: Value(poemCategory),
      reciterKey: Value(reciterKey),
      reciterDisplayName: Value(reciterDisplayName),
      sourceRecitationId: sourceRecitationId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecitationId),
      localFilePath: Value(localFilePath),
      sourceUrl: Value(sourceUrl),
      fileName: Value(fileName),
      syncXml: syncXml == null && nullToAbsent
          ? const Value.absent()
          : Value(syncXml),
      fileSizeBytes: Value(fileSizeBytes),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      checksum: checksum == null && nullToAbsent
          ? const Value.absent()
          : Value(checksum),
      downloadedAt: downloadedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(downloadedAt),
      lastPlayedAt: lastPlayedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedAt),
      playCount: Value(playCount),
      status: Value(status),
    );
  }

  factory DownloadedAudioRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadedAudioRow(
      id: serializer.fromJson<int>(json['id']),
      poemId: serializer.fromJson<String>(json['poemId']),
      poemCategory: serializer.fromJson<String>(json['poemCategory']),
      reciterKey: serializer.fromJson<String>(json['reciterKey']),
      reciterDisplayName: serializer.fromJson<String>(
        json['reciterDisplayName'],
      ),
      sourceRecitationId: serializer.fromJson<int?>(json['sourceRecitationId']),
      localFilePath: serializer.fromJson<String>(json['localFilePath']),
      sourceUrl: serializer.fromJson<String>(json['sourceUrl']),
      fileName: serializer.fromJson<String>(json['fileName']),
      syncXml: serializer.fromJson<String?>(json['syncXml']),
      fileSizeBytes: serializer.fromJson<int>(json['fileSizeBytes']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      checksum: serializer.fromJson<String?>(json['checksum']),
      downloadedAt: serializer.fromJson<DateTime?>(json['downloadedAt']),
      lastPlayedAt: serializer.fromJson<DateTime?>(json['lastPlayedAt']),
      playCount: serializer.fromJson<int>(json['playCount']),
      status: $DownloadedAudioTableTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'poemId': serializer.toJson<String>(poemId),
      'poemCategory': serializer.toJson<String>(poemCategory),
      'reciterKey': serializer.toJson<String>(reciterKey),
      'reciterDisplayName': serializer.toJson<String>(reciterDisplayName),
      'sourceRecitationId': serializer.toJson<int?>(sourceRecitationId),
      'localFilePath': serializer.toJson<String>(localFilePath),
      'sourceUrl': serializer.toJson<String>(sourceUrl),
      'fileName': serializer.toJson<String>(fileName),
      'syncXml': serializer.toJson<String?>(syncXml),
      'fileSizeBytes': serializer.toJson<int>(fileSizeBytes),
      'durationMs': serializer.toJson<int?>(durationMs),
      'checksum': serializer.toJson<String?>(checksum),
      'downloadedAt': serializer.toJson<DateTime?>(downloadedAt),
      'lastPlayedAt': serializer.toJson<DateTime?>(lastPlayedAt),
      'playCount': serializer.toJson<int>(playCount),
      'status': serializer.toJson<String>(
        $DownloadedAudioTableTable.$converterstatus.toJson(status),
      ),
    };
  }

  DownloadedAudioRow copyWith({
    int? id,
    String? poemId,
    String? poemCategory,
    String? reciterKey,
    String? reciterDisplayName,
    Value<int?> sourceRecitationId = const Value.absent(),
    String? localFilePath,
    String? sourceUrl,
    String? fileName,
    Value<String?> syncXml = const Value.absent(),
    int? fileSizeBytes,
    Value<int?> durationMs = const Value.absent(),
    Value<String?> checksum = const Value.absent(),
    Value<DateTime?> downloadedAt = const Value.absent(),
    Value<DateTime?> lastPlayedAt = const Value.absent(),
    int? playCount,
    DownloadStatus? status,
  }) => DownloadedAudioRow(
    id: id ?? this.id,
    poemId: poemId ?? this.poemId,
    poemCategory: poemCategory ?? this.poemCategory,
    reciterKey: reciterKey ?? this.reciterKey,
    reciterDisplayName: reciterDisplayName ?? this.reciterDisplayName,
    sourceRecitationId: sourceRecitationId.present
        ? sourceRecitationId.value
        : this.sourceRecitationId,
    localFilePath: localFilePath ?? this.localFilePath,
    sourceUrl: sourceUrl ?? this.sourceUrl,
    fileName: fileName ?? this.fileName,
    syncXml: syncXml.present ? syncXml.value : this.syncXml,
    fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    checksum: checksum.present ? checksum.value : this.checksum,
    downloadedAt: downloadedAt.present ? downloadedAt.value : this.downloadedAt,
    lastPlayedAt: lastPlayedAt.present ? lastPlayedAt.value : this.lastPlayedAt,
    playCount: playCount ?? this.playCount,
    status: status ?? this.status,
  );
  DownloadedAudioRow copyWithCompanion(DownloadedAudioTableCompanion data) {
    return DownloadedAudioRow(
      id: data.id.present ? data.id.value : this.id,
      poemId: data.poemId.present ? data.poemId.value : this.poemId,
      poemCategory: data.poemCategory.present
          ? data.poemCategory.value
          : this.poemCategory,
      reciterKey: data.reciterKey.present
          ? data.reciterKey.value
          : this.reciterKey,
      reciterDisplayName: data.reciterDisplayName.present
          ? data.reciterDisplayName.value
          : this.reciterDisplayName,
      sourceRecitationId: data.sourceRecitationId.present
          ? data.sourceRecitationId.value
          : this.sourceRecitationId,
      localFilePath: data.localFilePath.present
          ? data.localFilePath.value
          : this.localFilePath,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      syncXml: data.syncXml.present ? data.syncXml.value : this.syncXml,
      fileSizeBytes: data.fileSizeBytes.present
          ? data.fileSizeBytes.value
          : this.fileSizeBytes,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      checksum: data.checksum.present ? data.checksum.value : this.checksum,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
      lastPlayedAt: data.lastPlayedAt.present
          ? data.lastPlayedAt.value
          : this.lastPlayedAt,
      playCount: data.playCount.present ? data.playCount.value : this.playCount,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedAudioRow(')
          ..write('id: $id, ')
          ..write('poemId: $poemId, ')
          ..write('poemCategory: $poemCategory, ')
          ..write('reciterKey: $reciterKey, ')
          ..write('reciterDisplayName: $reciterDisplayName, ')
          ..write('sourceRecitationId: $sourceRecitationId, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fileName: $fileName, ')
          ..write('syncXml: $syncXml, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('checksum: $checksum, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    poemId,
    poemCategory,
    reciterKey,
    reciterDisplayName,
    sourceRecitationId,
    localFilePath,
    sourceUrl,
    fileName,
    syncXml,
    fileSizeBytes,
    durationMs,
    checksum,
    downloadedAt,
    lastPlayedAt,
    playCount,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadedAudioRow &&
          other.id == this.id &&
          other.poemId == this.poemId &&
          other.poemCategory == this.poemCategory &&
          other.reciterKey == this.reciterKey &&
          other.reciterDisplayName == this.reciterDisplayName &&
          other.sourceRecitationId == this.sourceRecitationId &&
          other.localFilePath == this.localFilePath &&
          other.sourceUrl == this.sourceUrl &&
          other.fileName == this.fileName &&
          other.syncXml == this.syncXml &&
          other.fileSizeBytes == this.fileSizeBytes &&
          other.durationMs == this.durationMs &&
          other.checksum == this.checksum &&
          other.downloadedAt == this.downloadedAt &&
          other.lastPlayedAt == this.lastPlayedAt &&
          other.playCount == this.playCount &&
          other.status == this.status);
}

class DownloadedAudioTableCompanion
    extends UpdateCompanion<DownloadedAudioRow> {
  final Value<int> id;
  final Value<String> poemId;
  final Value<String> poemCategory;
  final Value<String> reciterKey;
  final Value<String> reciterDisplayName;
  final Value<int?> sourceRecitationId;
  final Value<String> localFilePath;
  final Value<String> sourceUrl;
  final Value<String> fileName;
  final Value<String?> syncXml;
  final Value<int> fileSizeBytes;
  final Value<int?> durationMs;
  final Value<String?> checksum;
  final Value<DateTime?> downloadedAt;
  final Value<DateTime?> lastPlayedAt;
  final Value<int> playCount;
  final Value<DownloadStatus> status;
  const DownloadedAudioTableCompanion({
    this.id = const Value.absent(),
    this.poemId = const Value.absent(),
    this.poemCategory = const Value.absent(),
    this.reciterKey = const Value.absent(),
    this.reciterDisplayName = const Value.absent(),
    this.sourceRecitationId = const Value.absent(),
    this.localFilePath = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.fileName = const Value.absent(),
    this.syncXml = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.checksum = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.status = const Value.absent(),
  });
  DownloadedAudioTableCompanion.insert({
    this.id = const Value.absent(),
    required String poemId,
    required String poemCategory,
    required String reciterKey,
    required String reciterDisplayName,
    this.sourceRecitationId = const Value.absent(),
    required String localFilePath,
    required String sourceUrl,
    required String fileName,
    this.syncXml = const Value.absent(),
    this.fileSizeBytes = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.checksum = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.lastPlayedAt = const Value.absent(),
    this.playCount = const Value.absent(),
    this.status = const Value.absent(),
  }) : poemId = Value(poemId),
       poemCategory = Value(poemCategory),
       reciterKey = Value(reciterKey),
       reciterDisplayName = Value(reciterDisplayName),
       localFilePath = Value(localFilePath),
       sourceUrl = Value(sourceUrl),
       fileName = Value(fileName);
  static Insertable<DownloadedAudioRow> custom({
    Expression<int>? id,
    Expression<String>? poemId,
    Expression<String>? poemCategory,
    Expression<String>? reciterKey,
    Expression<String>? reciterDisplayName,
    Expression<int>? sourceRecitationId,
    Expression<String>? localFilePath,
    Expression<String>? sourceUrl,
    Expression<String>? fileName,
    Expression<String>? syncXml,
    Expression<int>? fileSizeBytes,
    Expression<int>? durationMs,
    Expression<String>? checksum,
    Expression<DateTime>? downloadedAt,
    Expression<DateTime>? lastPlayedAt,
    Expression<int>? playCount,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poemId != null) 'poem_id': poemId,
      if (poemCategory != null) 'poem_category': poemCategory,
      if (reciterKey != null) 'reciter_key': reciterKey,
      if (reciterDisplayName != null)
        'reciter_display_name': reciterDisplayName,
      if (sourceRecitationId != null)
        'source_recitation_id': sourceRecitationId,
      if (localFilePath != null) 'local_file_path': localFilePath,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (fileName != null) 'file_name': fileName,
      if (syncXml != null) 'sync_xml': syncXml,
      if (fileSizeBytes != null) 'file_size_bytes': fileSizeBytes,
      if (durationMs != null) 'duration_ms': durationMs,
      if (checksum != null) 'checksum': checksum,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (lastPlayedAt != null) 'last_played_at': lastPlayedAt,
      if (playCount != null) 'play_count': playCount,
      if (status != null) 'status': status,
    });
  }

  DownloadedAudioTableCompanion copyWith({
    Value<int>? id,
    Value<String>? poemId,
    Value<String>? poemCategory,
    Value<String>? reciterKey,
    Value<String>? reciterDisplayName,
    Value<int?>? sourceRecitationId,
    Value<String>? localFilePath,
    Value<String>? sourceUrl,
    Value<String>? fileName,
    Value<String?>? syncXml,
    Value<int>? fileSizeBytes,
    Value<int?>? durationMs,
    Value<String?>? checksum,
    Value<DateTime?>? downloadedAt,
    Value<DateTime?>? lastPlayedAt,
    Value<int>? playCount,
    Value<DownloadStatus>? status,
  }) {
    return DownloadedAudioTableCompanion(
      id: id ?? this.id,
      poemId: poemId ?? this.poemId,
      poemCategory: poemCategory ?? this.poemCategory,
      reciterKey: reciterKey ?? this.reciterKey,
      reciterDisplayName: reciterDisplayName ?? this.reciterDisplayName,
      sourceRecitationId: sourceRecitationId ?? this.sourceRecitationId,
      localFilePath: localFilePath ?? this.localFilePath,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      fileName: fileName ?? this.fileName,
      syncXml: syncXml ?? this.syncXml,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      durationMs: durationMs ?? this.durationMs,
      checksum: checksum ?? this.checksum,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      playCount: playCount ?? this.playCount,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (poemId.present) {
      map['poem_id'] = Variable<String>(poemId.value);
    }
    if (poemCategory.present) {
      map['poem_category'] = Variable<String>(poemCategory.value);
    }
    if (reciterKey.present) {
      map['reciter_key'] = Variable<String>(reciterKey.value);
    }
    if (reciterDisplayName.present) {
      map['reciter_display_name'] = Variable<String>(reciterDisplayName.value);
    }
    if (sourceRecitationId.present) {
      map['source_recitation_id'] = Variable<int>(sourceRecitationId.value);
    }
    if (localFilePath.present) {
      map['local_file_path'] = Variable<String>(localFilePath.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (syncXml.present) {
      map['sync_xml'] = Variable<String>(syncXml.value);
    }
    if (fileSizeBytes.present) {
      map['file_size_bytes'] = Variable<int>(fileSizeBytes.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (checksum.present) {
      map['checksum'] = Variable<String>(checksum.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (lastPlayedAt.present) {
      map['last_played_at'] = Variable<DateTime>(lastPlayedAt.value);
    }
    if (playCount.present) {
      map['play_count'] = Variable<int>(playCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $DownloadedAudioTableTable.$converterstatus.toSql(status.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadedAudioTableCompanion(')
          ..write('id: $id, ')
          ..write('poemId: $poemId, ')
          ..write('poemCategory: $poemCategory, ')
          ..write('reciterKey: $reciterKey, ')
          ..write('reciterDisplayName: $reciterDisplayName, ')
          ..write('sourceRecitationId: $sourceRecitationId, ')
          ..write('localFilePath: $localFilePath, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('fileName: $fileName, ')
          ..write('syncXml: $syncXml, ')
          ..write('fileSizeBytes: $fileSizeBytes, ')
          ..write('durationMs: $durationMs, ')
          ..write('checksum: $checksum, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('lastPlayedAt: $lastPlayedAt, ')
          ..write('playCount: $playCount, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $DefaultReciterTableTable extends DefaultReciterTable
    with TableInfo<$DefaultReciterTableTable, DefaultReciterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DefaultReciterTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reciterKeyMeta = const VerificationMeta(
    'reciterKey',
  );
  @override
  late final GeneratedColumn<String> reciterKey = GeneratedColumn<String>(
    'reciter_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reciterDisplayNameMeta =
      const VerificationMeta('reciterDisplayName');
  @override
  late final GeneratedColumn<String> reciterDisplayName =
      GeneratedColumn<String>(
        'reciter_display_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [scope, reciterKey, reciterDisplayName];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'default_reciter_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DefaultReciterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('reciter_key')) {
      context.handle(
        _reciterKeyMeta,
        reciterKey.isAcceptableOrUnknown(data['reciter_key']!, _reciterKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_reciterKeyMeta);
    }
    if (data.containsKey('reciter_display_name')) {
      context.handle(
        _reciterDisplayNameMeta,
        reciterDisplayName.isAcceptableOrUnknown(
          data['reciter_display_name']!,
          _reciterDisplayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reciterDisplayNameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {scope};
  @override
  DefaultReciterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DefaultReciterRow(
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      reciterKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reciter_key'],
      )!,
      reciterDisplayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reciter_display_name'],
      )!,
    );
  }

  @override
  $DefaultReciterTableTable createAlias(String alias) {
    return $DefaultReciterTableTable(attachedDatabase, alias);
  }
}

class DefaultReciterRow extends DataClass
    implements Insertable<DefaultReciterRow> {
  final String scope;
  final String reciterKey;
  final String reciterDisplayName;
  const DefaultReciterRow({
    required this.scope,
    required this.reciterKey,
    required this.reciterDisplayName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['scope'] = Variable<String>(scope);
    map['reciter_key'] = Variable<String>(reciterKey);
    map['reciter_display_name'] = Variable<String>(reciterDisplayName);
    return map;
  }

  DefaultReciterTableCompanion toCompanion(bool nullToAbsent) {
    return DefaultReciterTableCompanion(
      scope: Value(scope),
      reciterKey: Value(reciterKey),
      reciterDisplayName: Value(reciterDisplayName),
    );
  }

  factory DefaultReciterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DefaultReciterRow(
      scope: serializer.fromJson<String>(json['scope']),
      reciterKey: serializer.fromJson<String>(json['reciterKey']),
      reciterDisplayName: serializer.fromJson<String>(
        json['reciterDisplayName'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'scope': serializer.toJson<String>(scope),
      'reciterKey': serializer.toJson<String>(reciterKey),
      'reciterDisplayName': serializer.toJson<String>(reciterDisplayName),
    };
  }

  DefaultReciterRow copyWith({
    String? scope,
    String? reciterKey,
    String? reciterDisplayName,
  }) => DefaultReciterRow(
    scope: scope ?? this.scope,
    reciterKey: reciterKey ?? this.reciterKey,
    reciterDisplayName: reciterDisplayName ?? this.reciterDisplayName,
  );
  DefaultReciterRow copyWithCompanion(DefaultReciterTableCompanion data) {
    return DefaultReciterRow(
      scope: data.scope.present ? data.scope.value : this.scope,
      reciterKey: data.reciterKey.present
          ? data.reciterKey.value
          : this.reciterKey,
      reciterDisplayName: data.reciterDisplayName.present
          ? data.reciterDisplayName.value
          : this.reciterDisplayName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DefaultReciterRow(')
          ..write('scope: $scope, ')
          ..write('reciterKey: $reciterKey, ')
          ..write('reciterDisplayName: $reciterDisplayName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(scope, reciterKey, reciterDisplayName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DefaultReciterRow &&
          other.scope == this.scope &&
          other.reciterKey == this.reciterKey &&
          other.reciterDisplayName == this.reciterDisplayName);
}

class DefaultReciterTableCompanion extends UpdateCompanion<DefaultReciterRow> {
  final Value<String> scope;
  final Value<String> reciterKey;
  final Value<String> reciterDisplayName;
  final Value<int> rowid;
  const DefaultReciterTableCompanion({
    this.scope = const Value.absent(),
    this.reciterKey = const Value.absent(),
    this.reciterDisplayName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DefaultReciterTableCompanion.insert({
    required String scope,
    required String reciterKey,
    required String reciterDisplayName,
    this.rowid = const Value.absent(),
  }) : scope = Value(scope),
       reciterKey = Value(reciterKey),
       reciterDisplayName = Value(reciterDisplayName);
  static Insertable<DefaultReciterRow> custom({
    Expression<String>? scope,
    Expression<String>? reciterKey,
    Expression<String>? reciterDisplayName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (scope != null) 'scope': scope,
      if (reciterKey != null) 'reciter_key': reciterKey,
      if (reciterDisplayName != null)
        'reciter_display_name': reciterDisplayName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DefaultReciterTableCompanion copyWith({
    Value<String>? scope,
    Value<String>? reciterKey,
    Value<String>? reciterDisplayName,
    Value<int>? rowid,
  }) {
    return DefaultReciterTableCompanion(
      scope: scope ?? this.scope,
      reciterKey: reciterKey ?? this.reciterKey,
      reciterDisplayName: reciterDisplayName ?? this.reciterDisplayName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (reciterKey.present) {
      map['reciter_key'] = Variable<String>(reciterKey.value);
    }
    if (reciterDisplayName.present) {
      map['reciter_display_name'] = Variable<String>(reciterDisplayName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DefaultReciterTableCompanion(')
          ..write('scope: $scope, ')
          ..write('reciterKey: $reciterKey, ')
          ..write('reciterDisplayName: $reciterDisplayName, ')
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
  late final $DownloadedAudioTableTable downloadedAudioTable =
      $DownloadedAudioTableTable(this);
  late final $DefaultReciterTableTable defaultReciterTable =
      $DefaultReciterTableTable(this);
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
    downloadedAudioTable,
    defaultReciterTable,
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
      required String category,
      required String poemTitle,
      required String poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });
typedef $$LikedItemsTableTableUpdateCompanionBuilder =
    LikedItemsTableCompanion Function({
      Value<String> poemId,
      Value<String> category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

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
                Value<String> category = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LikedItemsTableCompanion(
                poemId: poemId,
                category: category,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                required String category,
                required String poemTitle,
                required String poemText,
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LikedItemsTableCompanion.insert(
                poemId: poemId,
                category: category,
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
      required String category,
      required String poemTitle,
      required String poemText,
      Value<String> audioUrl,
      Value<int> rowid,
    });
typedef $$SavedItemsTableTableUpdateCompanionBuilder =
    SavedItemsTableCompanion Function({
      Value<String> poemId,
      Value<String> category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

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
                Value<String> category = const Value.absent(),
                Value<String> poemTitle = const Value.absent(),
                Value<String> poemText = const Value.absent(),
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsTableCompanion(
                poemId: poemId,
                category: category,
                poemTitle: poemTitle,
                poemText: poemText,
                audioUrl: audioUrl,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String poemId,
                required String category,
                required String poemTitle,
                required String poemText,
                Value<String> audioUrl = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedItemsTableCompanion.insert(
                poemId: poemId,
                category: category,
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
      required String category,
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
      Value<String> category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

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
                Value<String> category = const Value.absent(),
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
                category: category,
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
                required String category,
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
                category: category,
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
typedef $$DownloadedAudioTableTableCreateCompanionBuilder =
    DownloadedAudioTableCompanion Function({
      Value<int> id,
      required String poemId,
      required String poemCategory,
      required String reciterKey,
      required String reciterDisplayName,
      Value<int?> sourceRecitationId,
      required String localFilePath,
      required String sourceUrl,
      required String fileName,
      Value<String?> syncXml,
      Value<int> fileSizeBytes,
      Value<int?> durationMs,
      Value<String?> checksum,
      Value<DateTime?> downloadedAt,
      Value<DateTime?> lastPlayedAt,
      Value<int> playCount,
      Value<DownloadStatus> status,
    });
typedef $$DownloadedAudioTableTableUpdateCompanionBuilder =
    DownloadedAudioTableCompanion Function({
      Value<int> id,
      Value<String> poemId,
      Value<String> poemCategory,
      Value<String> reciterKey,
      Value<String> reciterDisplayName,
      Value<int?> sourceRecitationId,
      Value<String> localFilePath,
      Value<String> sourceUrl,
      Value<String> fileName,
      Value<String?> syncXml,
      Value<int> fileSizeBytes,
      Value<int?> durationMs,
      Value<String?> checksum,
      Value<DateTime?> downloadedAt,
      Value<DateTime?> lastPlayedAt,
      Value<int> playCount,
      Value<DownloadStatus> status,
    });

class $$DownloadedAudioTableTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadedAudioTableTable> {
  $$DownloadedAudioTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get poemCategory => $composableBuilder(
    column: $table.poemCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sourceRecitationId => $composableBuilder(
    column: $table.sourceRecitationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncXml => $composableBuilder(
    column: $table.syncXml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DownloadStatus, DownloadStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$DownloadedAudioTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadedAudioTableTable> {
  $$DownloadedAudioTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemId => $composableBuilder(
    column: $table.poemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get poemCategory => $composableBuilder(
    column: $table.poemCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sourceRecitationId => $composableBuilder(
    column: $table.sourceRecitationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrl => $composableBuilder(
    column: $table.sourceUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncXml => $composableBuilder(
    column: $table.syncXml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checksum => $composableBuilder(
    column: $table.checksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get playCount => $composableBuilder(
    column: $table.playCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadedAudioTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadedAudioTableTable> {
  $$DownloadedAudioTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poemId =>
      $composableBuilder(column: $table.poemId, builder: (column) => column);

  GeneratedColumn<String> get poemCategory => $composableBuilder(
    column: $table.poemCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sourceRecitationId => $composableBuilder(
    column: $table.sourceRecitationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localFilePath => $composableBuilder(
    column: $table.localFilePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceUrl =>
      $composableBuilder(column: $table.sourceUrl, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get syncXml =>
      $composableBuilder(column: $table.syncXml, builder: (column) => column);

  GeneratedColumn<int> get fileSizeBytes => $composableBuilder(
    column: $table.fileSizeBytes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get checksum =>
      $composableBuilder(column: $table.checksum, builder: (column) => column);

  GeneratedColumn<DateTime> get downloadedAt => $composableBuilder(
    column: $table.downloadedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedAt => $composableBuilder(
    column: $table.lastPlayedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get playCount =>
      $composableBuilder(column: $table.playCount, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DownloadStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$DownloadedAudioTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadedAudioTableTable,
          DownloadedAudioRow,
          $$DownloadedAudioTableTableFilterComposer,
          $$DownloadedAudioTableTableOrderingComposer,
          $$DownloadedAudioTableTableAnnotationComposer,
          $$DownloadedAudioTableTableCreateCompanionBuilder,
          $$DownloadedAudioTableTableUpdateCompanionBuilder,
          (
            DownloadedAudioRow,
            BaseReferences<
              _$AppDatabase,
              $DownloadedAudioTableTable,
              DownloadedAudioRow
            >,
          ),
          DownloadedAudioRow,
          PrefetchHooks Function()
        > {
  $$DownloadedAudioTableTableTableManager(
    _$AppDatabase db,
    $DownloadedAudioTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadedAudioTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadedAudioTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DownloadedAudioTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> poemId = const Value.absent(),
                Value<String> poemCategory = const Value.absent(),
                Value<String> reciterKey = const Value.absent(),
                Value<String> reciterDisplayName = const Value.absent(),
                Value<int?> sourceRecitationId = const Value.absent(),
                Value<String> localFilePath = const Value.absent(),
                Value<String> sourceUrl = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String?> syncXml = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<DateTime?> downloadedAt = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<DownloadStatus> status = const Value.absent(),
              }) => DownloadedAudioTableCompanion(
                id: id,
                poemId: poemId,
                poemCategory: poemCategory,
                reciterKey: reciterKey,
                reciterDisplayName: reciterDisplayName,
                sourceRecitationId: sourceRecitationId,
                localFilePath: localFilePath,
                sourceUrl: sourceUrl,
                fileName: fileName,
                syncXml: syncXml,
                fileSizeBytes: fileSizeBytes,
                durationMs: durationMs,
                checksum: checksum,
                downloadedAt: downloadedAt,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String poemId,
                required String poemCategory,
                required String reciterKey,
                required String reciterDisplayName,
                Value<int?> sourceRecitationId = const Value.absent(),
                required String localFilePath,
                required String sourceUrl,
                required String fileName,
                Value<String?> syncXml = const Value.absent(),
                Value<int> fileSizeBytes = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<String?> checksum = const Value.absent(),
                Value<DateTime?> downloadedAt = const Value.absent(),
                Value<DateTime?> lastPlayedAt = const Value.absent(),
                Value<int> playCount = const Value.absent(),
                Value<DownloadStatus> status = const Value.absent(),
              }) => DownloadedAudioTableCompanion.insert(
                id: id,
                poemId: poemId,
                poemCategory: poemCategory,
                reciterKey: reciterKey,
                reciterDisplayName: reciterDisplayName,
                sourceRecitationId: sourceRecitationId,
                localFilePath: localFilePath,
                sourceUrl: sourceUrl,
                fileName: fileName,
                syncXml: syncXml,
                fileSizeBytes: fileSizeBytes,
                durationMs: durationMs,
                checksum: checksum,
                downloadedAt: downloadedAt,
                lastPlayedAt: lastPlayedAt,
                playCount: playCount,
                status: status,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadedAudioTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadedAudioTableTable,
      DownloadedAudioRow,
      $$DownloadedAudioTableTableFilterComposer,
      $$DownloadedAudioTableTableOrderingComposer,
      $$DownloadedAudioTableTableAnnotationComposer,
      $$DownloadedAudioTableTableCreateCompanionBuilder,
      $$DownloadedAudioTableTableUpdateCompanionBuilder,
      (
        DownloadedAudioRow,
        BaseReferences<
          _$AppDatabase,
          $DownloadedAudioTableTable,
          DownloadedAudioRow
        >,
      ),
      DownloadedAudioRow,
      PrefetchHooks Function()
    >;
typedef $$DefaultReciterTableTableCreateCompanionBuilder =
    DefaultReciterTableCompanion Function({
      required String scope,
      required String reciterKey,
      required String reciterDisplayName,
      Value<int> rowid,
    });
typedef $$DefaultReciterTableTableUpdateCompanionBuilder =
    DefaultReciterTableCompanion Function({
      Value<String> scope,
      Value<String> reciterKey,
      Value<String> reciterDisplayName,
      Value<int> rowid,
    });

class $$DefaultReciterTableTableFilterComposer
    extends Composer<_$AppDatabase, $DefaultReciterTableTable> {
  $$DefaultReciterTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DefaultReciterTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DefaultReciterTableTable> {
  $$DefaultReciterTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DefaultReciterTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DefaultReciterTableTable> {
  $$DefaultReciterTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get reciterKey => $composableBuilder(
    column: $table.reciterKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reciterDisplayName => $composableBuilder(
    column: $table.reciterDisplayName,
    builder: (column) => column,
  );
}

class $$DefaultReciterTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DefaultReciterTableTable,
          DefaultReciterRow,
          $$DefaultReciterTableTableFilterComposer,
          $$DefaultReciterTableTableOrderingComposer,
          $$DefaultReciterTableTableAnnotationComposer,
          $$DefaultReciterTableTableCreateCompanionBuilder,
          $$DefaultReciterTableTableUpdateCompanionBuilder,
          (
            DefaultReciterRow,
            BaseReferences<
              _$AppDatabase,
              $DefaultReciterTableTable,
              DefaultReciterRow
            >,
          ),
          DefaultReciterRow,
          PrefetchHooks Function()
        > {
  $$DefaultReciterTableTableTableManager(
    _$AppDatabase db,
    $DefaultReciterTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DefaultReciterTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DefaultReciterTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$DefaultReciterTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> scope = const Value.absent(),
                Value<String> reciterKey = const Value.absent(),
                Value<String> reciterDisplayName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DefaultReciterTableCompanion(
                scope: scope,
                reciterKey: reciterKey,
                reciterDisplayName: reciterDisplayName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String scope,
                required String reciterKey,
                required String reciterDisplayName,
                Value<int> rowid = const Value.absent(),
              }) => DefaultReciterTableCompanion.insert(
                scope: scope,
                reciterKey: reciterKey,
                reciterDisplayName: reciterDisplayName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DefaultReciterTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DefaultReciterTableTable,
      DefaultReciterRow,
      $$DefaultReciterTableTableFilterComposer,
      $$DefaultReciterTableTableOrderingComposer,
      $$DefaultReciterTableTableAnnotationComposer,
      $$DefaultReciterTableTableCreateCompanionBuilder,
      $$DefaultReciterTableTableUpdateCompanionBuilder,
      (
        DefaultReciterRow,
        BaseReferences<
          _$AppDatabase,
          $DefaultReciterTableTable,
          DefaultReciterRow
        >,
      ),
      DefaultReciterRow,
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
  $$DownloadedAudioTableTableTableManager get downloadedAudioTable =>
      $$DownloadedAudioTableTableTableManager(_db, _db.downloadedAudioTable);
  $$DefaultReciterTableTableTableManager get defaultReciterTable =>
      $$DefaultReciterTableTableTableManager(_db, _db.defaultReciterTable);
}
