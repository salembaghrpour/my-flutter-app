// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products
    with TableInfo<$ProductsTable, LocalProduct> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _baseUnitIdMeta =
      const VerificationMeta('baseUnitId');
  @override
  late final GeneratedColumn<int> baseUnitId = GeneratedColumn<int>(
      'base_unit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _baseUnitNameMeta =
      const VerificationMeta('baseUnitName');
  @override
  late final GeneratedColumn<String> baseUnitName = GeneratedColumn<String>(
      'base_unit_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _hasMultiUnitsMeta =
      const VerificationMeta('hasMultiUnits');
  @override
  late final GeneratedColumn<bool> hasMultiUnits = GeneratedColumn<bool>(
      'has_multi_units', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_multi_units" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _hasBatchesMeta =
      const VerificationMeta('hasBatches');
  @override
  late final GeneratedColumn<bool> hasBatches = GeneratedColumn<bool>(
      'has_batches', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("has_batches" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        code,
        barcode,
        sellingPrice,
        description,
        imagePath,
        baseUnitId,
        baseUnitName,
        hasMultiUnits,
        hasBatches,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProduct> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('base_unit_id')) {
      context.handle(
          _baseUnitIdMeta,
          baseUnitId.isAcceptableOrUnknown(
              data['base_unit_id']!, _baseUnitIdMeta));
    }
    if (data.containsKey('base_unit_name')) {
      context.handle(
          _baseUnitNameMeta,
          baseUnitName.isAcceptableOrUnknown(
              data['base_unit_name']!, _baseUnitNameMeta));
    }
    if (data.containsKey('has_multi_units')) {
      context.handle(
          _hasMultiUnitsMeta,
          hasMultiUnits.isAcceptableOrUnknown(
              data['has_multi_units']!, _hasMultiUnitsMeta));
    }
    if (data.containsKey('has_batches')) {
      context.handle(
          _hasBatchesMeta,
          hasBatches.isAcceptableOrUnknown(
              data['has_batches']!, _hasBatchesMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProduct map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProduct(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code']),
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      baseUnitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}base_unit_id']),
      baseUnitName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_unit_name']),
      hasMultiUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_multi_units'])!,
      hasBatches: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_batches'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class LocalProduct extends DataClass implements Insertable<LocalProduct> {
  final int id;
  final String name;
  final String? code;
  final String? barcode;
  final double sellingPrice;
  final String? description;
  final String? imagePath;
  final int? baseUnitId;
  final String? baseUnitName;
  final bool hasMultiUnits;
  final bool hasBatches;
  final bool isActive;
  const LocalProduct(
      {required this.id,
      required this.name,
      this.code,
      this.barcode,
      required this.sellingPrice,
      this.description,
      this.imagePath,
      this.baseUnitId,
      this.baseUnitName,
      required this.hasMultiUnits,
      required this.hasBatches,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || code != null) {
      map['code'] = Variable<String>(code);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['selling_price'] = Variable<double>(sellingPrice);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || baseUnitId != null) {
      map['base_unit_id'] = Variable<int>(baseUnitId);
    }
    if (!nullToAbsent || baseUnitName != null) {
      map['base_unit_name'] = Variable<String>(baseUnitName);
    }
    map['has_multi_units'] = Variable<bool>(hasMultiUnits);
    map['has_batches'] = Variable<bool>(hasBatches);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      code: code == null && nullToAbsent ? const Value.absent() : Value(code),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      sellingPrice: Value(sellingPrice),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      baseUnitId: baseUnitId == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUnitId),
      baseUnitName: baseUnitName == null && nullToAbsent
          ? const Value.absent()
          : Value(baseUnitName),
      hasMultiUnits: Value(hasMultiUnits),
      hasBatches: Value(hasBatches),
      isActive: Value(isActive),
    );
  }

  factory LocalProduct.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProduct(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String?>(json['code']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      description: serializer.fromJson<String?>(json['description']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      baseUnitId: serializer.fromJson<int?>(json['baseUnitId']),
      baseUnitName: serializer.fromJson<String?>(json['baseUnitName']),
      hasMultiUnits: serializer.fromJson<bool>(json['hasMultiUnits']),
      hasBatches: serializer.fromJson<bool>(json['hasBatches']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String?>(code),
      'barcode': serializer.toJson<String?>(barcode),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'description': serializer.toJson<String?>(description),
      'imagePath': serializer.toJson<String?>(imagePath),
      'baseUnitId': serializer.toJson<int?>(baseUnitId),
      'baseUnitName': serializer.toJson<String?>(baseUnitName),
      'hasMultiUnits': serializer.toJson<bool>(hasMultiUnits),
      'hasBatches': serializer.toJson<bool>(hasBatches),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  LocalProduct copyWith(
          {int? id,
          String? name,
          Value<String?> code = const Value.absent(),
          Value<String?> barcode = const Value.absent(),
          double? sellingPrice,
          Value<String?> description = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          Value<int?> baseUnitId = const Value.absent(),
          Value<String?> baseUnitName = const Value.absent(),
          bool? hasMultiUnits,
          bool? hasBatches,
          bool? isActive}) =>
      LocalProduct(
        id: id ?? this.id,
        name: name ?? this.name,
        code: code.present ? code.value : this.code,
        barcode: barcode.present ? barcode.value : this.barcode,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        description: description.present ? description.value : this.description,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        baseUnitId: baseUnitId.present ? baseUnitId.value : this.baseUnitId,
        baseUnitName:
            baseUnitName.present ? baseUnitName.value : this.baseUnitName,
        hasMultiUnits: hasMultiUnits ?? this.hasMultiUnits,
        hasBatches: hasBatches ?? this.hasBatches,
        isActive: isActive ?? this.isActive,
      );
  LocalProduct copyWithCompanion(ProductsCompanion data) {
    return LocalProduct(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      description:
          data.description.present ? data.description.value : this.description,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      baseUnitId:
          data.baseUnitId.present ? data.baseUnitId.value : this.baseUnitId,
      baseUnitName: data.baseUnitName.present
          ? data.baseUnitName.value
          : this.baseUnitName,
      hasMultiUnits: data.hasMultiUnits.present
          ? data.hasMultiUnits.value
          : this.hasMultiUnits,
      hasBatches:
          data.hasBatches.present ? data.hasBatches.value : this.hasBatches,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProduct(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('baseUnitId: $baseUnitId, ')
          ..write('baseUnitName: $baseUnitName, ')
          ..write('hasMultiUnits: $hasMultiUnits, ')
          ..write('hasBatches: $hasBatches, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      name,
      code,
      barcode,
      sellingPrice,
      description,
      imagePath,
      baseUnitId,
      baseUnitName,
      hasMultiUnits,
      hasBatches,
      isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProduct &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.barcode == this.barcode &&
          other.sellingPrice == this.sellingPrice &&
          other.description == this.description &&
          other.imagePath == this.imagePath &&
          other.baseUnitId == this.baseUnitId &&
          other.baseUnitName == this.baseUnitName &&
          other.hasMultiUnits == this.hasMultiUnits &&
          other.hasBatches == this.hasBatches &&
          other.isActive == this.isActive);
}

class ProductsCompanion extends UpdateCompanion<LocalProduct> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> code;
  final Value<String?> barcode;
  final Value<double> sellingPrice;
  final Value<String?> description;
  final Value<String?> imagePath;
  final Value<int?> baseUnitId;
  final Value<String?> baseUnitName;
  final Value<bool> hasMultiUnits;
  final Value<bool> hasBatches;
  final Value<bool> isActive;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.baseUnitId = const Value.absent(),
    this.baseUnitName = const Value.absent(),
    this.hasMultiUnits = const Value.absent(),
    this.hasBatches = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.code = const Value.absent(),
    this.barcode = const Value.absent(),
    required double sellingPrice,
    this.description = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.baseUnitId = const Value.absent(),
    this.baseUnitName = const Value.absent(),
    this.hasMultiUnits = const Value.absent(),
    this.hasBatches = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : name = Value(name),
        sellingPrice = Value(sellingPrice);
  static Insertable<LocalProduct> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? barcode,
    Expression<double>? sellingPrice,
    Expression<String>? description,
    Expression<String>? imagePath,
    Expression<int>? baseUnitId,
    Expression<String>? baseUnitName,
    Expression<bool>? hasMultiUnits,
    Expression<bool>? hasBatches,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (barcode != null) 'barcode': barcode,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (description != null) 'description': description,
      if (imagePath != null) 'image_path': imagePath,
      if (baseUnitId != null) 'base_unit_id': baseUnitId,
      if (baseUnitName != null) 'base_unit_name': baseUnitName,
      if (hasMultiUnits != null) 'has_multi_units': hasMultiUnits,
      if (hasBatches != null) 'has_batches': hasBatches,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ProductsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? code,
      Value<String?>? barcode,
      Value<double>? sellingPrice,
      Value<String?>? description,
      Value<String?>? imagePath,
      Value<int?>? baseUnitId,
      Value<String?>? baseUnitName,
      Value<bool>? hasMultiUnits,
      Value<bool>? hasBatches,
      Value<bool>? isActive}) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      baseUnitId: baseUnitId ?? this.baseUnitId,
      baseUnitName: baseUnitName ?? this.baseUnitName,
      hasMultiUnits: hasMultiUnits ?? this.hasMultiUnits,
      hasBatches: hasBatches ?? this.hasBatches,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (baseUnitId.present) {
      map['base_unit_id'] = Variable<int>(baseUnitId.value);
    }
    if (baseUnitName.present) {
      map['base_unit_name'] = Variable<String>(baseUnitName.value);
    }
    if (hasMultiUnits.present) {
      map['has_multi_units'] = Variable<bool>(hasMultiUnits.value);
    }
    if (hasBatches.present) {
      map['has_batches'] = Variable<bool>(hasBatches.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('barcode: $barcode, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('description: $description, ')
          ..write('imagePath: $imagePath, ')
          ..write('baseUnitId: $baseUnitId, ')
          ..write('baseUnitName: $baseUnitName, ')
          ..write('hasMultiUnits: $hasMultiUnits, ')
          ..write('hasBatches: $hasBatches, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ProductCategoriesTable extends ProductCategories
    with TableInfo<$ProductCategoriesTable, LocalProductCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _accountingIdMeta =
      const VerificationMeta('accountingId');
  @override
  late final GeneratedColumn<int> accountingId = GeneratedColumn<int>(
      'accounting_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _parentAccountingIdMeta =
      const VerificationMeta('parentAccountingId');
  @override
  late final GeneratedColumn<int> parentAccountingId = GeneratedColumn<int>(
      'parent_accounting_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _childrenJsonMeta =
      const VerificationMeta('childrenJson');
  @override
  late final GeneratedColumn<String> childrenJson = GeneratedColumn<String>(
      'children_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountingId,
        name,
        description,
        parentId,
        parentAccountingId,
        sortOrder,
        imagePath,
        isActive,
        childrenJson
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_categories';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalProductCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accounting_id')) {
      context.handle(
          _accountingIdMeta,
          accountingId.isAcceptableOrUnknown(
              data['accounting_id']!, _accountingIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('parent_accounting_id')) {
      context.handle(
          _parentAccountingIdMeta,
          parentAccountingId.isAcceptableOrUnknown(
              data['parent_accounting_id']!, _parentAccountingIdMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('children_json')) {
      context.handle(
          _childrenJsonMeta,
          childrenJson.isAcceptableOrUnknown(
              data['children_json']!, _childrenJsonMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountingId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accounting_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      parentAccountingId: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}parent_accounting_id']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      childrenJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}children_json']),
    );
  }

  @override
  $ProductCategoriesTable createAlias(String alias) {
    return $ProductCategoriesTable(attachedDatabase, alias);
  }
}

class LocalProductCategory extends DataClass
    implements Insertable<LocalProductCategory> {
  final int id;
  final int? accountingId;
  final String name;
  final String? description;
  final int? parentId;
  final int? parentAccountingId;
  final int sortOrder;
  final String? imagePath;
  final bool isActive;
  final String? childrenJson;
  const LocalProductCategory(
      {required this.id,
      this.accountingId,
      required this.name,
      this.description,
      this.parentId,
      this.parentAccountingId,
      required this.sortOrder,
      this.imagePath,
      required this.isActive,
      this.childrenJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || accountingId != null) {
      map['accounting_id'] = Variable<int>(accountingId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || parentAccountingId != null) {
      map['parent_accounting_id'] = Variable<int>(parentAccountingId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || childrenJson != null) {
      map['children_json'] = Variable<String>(childrenJson);
    }
    return map;
  }

  ProductCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ProductCategoriesCompanion(
      id: Value(id),
      accountingId: accountingId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountingId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      parentAccountingId: parentAccountingId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentAccountingId),
      sortOrder: Value(sortOrder),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isActive: Value(isActive),
      childrenJson: childrenJson == null && nullToAbsent
          ? const Value.absent()
          : Value(childrenJson),
    );
  }

  factory LocalProductCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductCategory(
      id: serializer.fromJson<int>(json['id']),
      accountingId: serializer.fromJson<int?>(json['accountingId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      parentAccountingId: serializer.fromJson<int?>(json['parentAccountingId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      childrenJson: serializer.fromJson<String?>(json['childrenJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountingId': serializer.toJson<int?>(accountingId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'parentId': serializer.toJson<int?>(parentId),
      'parentAccountingId': serializer.toJson<int?>(parentAccountingId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isActive': serializer.toJson<bool>(isActive),
      'childrenJson': serializer.toJson<String?>(childrenJson),
    };
  }

  LocalProductCategory copyWith(
          {int? id,
          Value<int?> accountingId = const Value.absent(),
          String? name,
          Value<String?> description = const Value.absent(),
          Value<int?> parentId = const Value.absent(),
          Value<int?> parentAccountingId = const Value.absent(),
          int? sortOrder,
          Value<String?> imagePath = const Value.absent(),
          bool? isActive,
          Value<String?> childrenJson = const Value.absent()}) =>
      LocalProductCategory(
        id: id ?? this.id,
        accountingId:
            accountingId.present ? accountingId.value : this.accountingId,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        parentId: parentId.present ? parentId.value : this.parentId,
        parentAccountingId: parentAccountingId.present
            ? parentAccountingId.value
            : this.parentAccountingId,
        sortOrder: sortOrder ?? this.sortOrder,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isActive: isActive ?? this.isActive,
        childrenJson:
            childrenJson.present ? childrenJson.value : this.childrenJson,
      );
  LocalProductCategory copyWithCompanion(ProductCategoriesCompanion data) {
    return LocalProductCategory(
      id: data.id.present ? data.id.value : this.id,
      accountingId: data.accountingId.present
          ? data.accountingId.value
          : this.accountingId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      parentAccountingId: data.parentAccountingId.present
          ? data.parentAccountingId.value
          : this.parentAccountingId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      childrenJson: data.childrenJson.present
          ? data.childrenJson.value
          : this.childrenJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductCategory(')
          ..write('id: $id, ')
          ..write('accountingId: $accountingId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('parentId: $parentId, ')
          ..write('parentAccountingId: $parentAccountingId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('imagePath: $imagePath, ')
          ..write('isActive: $isActive, ')
          ..write('childrenJson: $childrenJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, accountingId, name, description, parentId,
      parentAccountingId, sortOrder, imagePath, isActive, childrenJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductCategory &&
          other.id == this.id &&
          other.accountingId == this.accountingId &&
          other.name == this.name &&
          other.description == this.description &&
          other.parentId == this.parentId &&
          other.parentAccountingId == this.parentAccountingId &&
          other.sortOrder == this.sortOrder &&
          other.imagePath == this.imagePath &&
          other.isActive == this.isActive &&
          other.childrenJson == this.childrenJson);
}

class ProductCategoriesCompanion extends UpdateCompanion<LocalProductCategory> {
  final Value<int> id;
  final Value<int?> accountingId;
  final Value<String> name;
  final Value<String?> description;
  final Value<int?> parentId;
  final Value<int?> parentAccountingId;
  final Value<int> sortOrder;
  final Value<String?> imagePath;
  final Value<bool> isActive;
  final Value<String?> childrenJson;
  const ProductCategoriesCompanion({
    this.id = const Value.absent(),
    this.accountingId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.parentId = const Value.absent(),
    this.parentAccountingId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.childrenJson = const Value.absent(),
  });
  ProductCategoriesCompanion.insert({
    this.id = const Value.absent(),
    this.accountingId = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.parentId = const Value.absent(),
    this.parentAccountingId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.childrenJson = const Value.absent(),
  }) : name = Value(name);
  static Insertable<LocalProductCategory> custom({
    Expression<int>? id,
    Expression<int>? accountingId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? parentId,
    Expression<int>? parentAccountingId,
    Expression<int>? sortOrder,
    Expression<String>? imagePath,
    Expression<bool>? isActive,
    Expression<String>? childrenJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountingId != null) 'accounting_id': accountingId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parent_id': parentId,
      if (parentAccountingId != null)
        'parent_accounting_id': parentAccountingId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (imagePath != null) 'image_path': imagePath,
      if (isActive != null) 'is_active': isActive,
      if (childrenJson != null) 'children_json': childrenJson,
    });
  }

  ProductCategoriesCompanion copyWith(
      {Value<int>? id,
      Value<int?>? accountingId,
      Value<String>? name,
      Value<String?>? description,
      Value<int?>? parentId,
      Value<int?>? parentAccountingId,
      Value<int>? sortOrder,
      Value<String?>? imagePath,
      Value<bool>? isActive,
      Value<String?>? childrenJson}) {
    return ProductCategoriesCompanion(
      id: id ?? this.id,
      accountingId: accountingId ?? this.accountingId,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId ?? this.parentId,
      parentAccountingId: parentAccountingId ?? this.parentAccountingId,
      sortOrder: sortOrder ?? this.sortOrder,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      childrenJson: childrenJson ?? this.childrenJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountingId.present) {
      map['accounting_id'] = Variable<int>(accountingId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (parentAccountingId.present) {
      map['parent_accounting_id'] = Variable<int>(parentAccountingId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (childrenJson.present) {
      map['children_json'] = Variable<String>(childrenJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('accountingId: $accountingId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('parentId: $parentId, ')
          ..write('parentAccountingId: $parentAccountingId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('imagePath: $imagePath, ')
          ..write('isActive: $isActive, ')
          ..write('childrenJson: $childrenJson')
          ..write(')'))
        .toString();
  }
}

class $OfflineOrdersTable extends OfflineOrders
    with TableInfo<$OfflineOrdersTable, OfflineOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _profileIdMeta =
      const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
      'profile_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalPriceMeta =
      const VerificationMeta('totalPrice');
  @override
  late final GeneratedColumn<double> totalPrice = GeneratedColumn<double>(
      'total_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, profileId, totalPrice, paymentMethod, createdAt, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_orders';
  @override
  VerificationContext validateIntegrity(Insertable<OfflineOrder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta,
          profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('total_price')) {
      context.handle(
          _totalPriceMeta,
          totalPrice.isAcceptableOrUnknown(
              data['total_price']!, _totalPriceMeta));
    } else if (isInserting) {
      context.missing(_totalPriceMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineOrder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      profileId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      totalPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_price'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $OfflineOrdersTable createAlias(String alias) {
    return $OfflineOrdersTable(attachedDatabase, alias);
  }
}

class OfflineOrder extends DataClass implements Insertable<OfflineOrder> {
  final int id;
  final String profileId;
  final double totalPrice;
  final String paymentMethod;
  final DateTime createdAt;
  final bool isSynced;
  const OfflineOrder(
      {required this.id,
      required this.profileId,
      required this.totalPrice,
      required this.paymentMethod,
      required this.createdAt,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['profile_id'] = Variable<String>(profileId);
    map['total_price'] = Variable<double>(totalPrice);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  OfflineOrdersCompanion toCompanion(bool nullToAbsent) {
    return OfflineOrdersCompanion(
      id: Value(id),
      profileId: Value(profileId),
      totalPrice: Value(totalPrice),
      paymentMethod: Value(paymentMethod),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory OfflineOrder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineOrder(
      id: serializer.fromJson<int>(json['id']),
      profileId: serializer.fromJson<String>(json['profileId']),
      totalPrice: serializer.fromJson<double>(json['totalPrice']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'profileId': serializer.toJson<String>(profileId),
      'totalPrice': serializer.toJson<double>(totalPrice),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  OfflineOrder copyWith(
          {int? id,
          String? profileId,
          double? totalPrice,
          String? paymentMethod,
          DateTime? createdAt,
          bool? isSynced}) =>
      OfflineOrder(
        id: id ?? this.id,
        profileId: profileId ?? this.profileId,
        totalPrice: totalPrice ?? this.totalPrice,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
      );
  OfflineOrder copyWithCompanion(OfflineOrdersCompanion data) {
    return OfflineOrder(
      id: data.id.present ? data.id.value : this.id,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      totalPrice:
          data.totalPrice.present ? data.totalPrice.value : this.totalPrice,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOrder(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, profileId, totalPrice, paymentMethod, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineOrder &&
          other.id == this.id &&
          other.profileId == this.profileId &&
          other.totalPrice == this.totalPrice &&
          other.paymentMethod == this.paymentMethod &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class OfflineOrdersCompanion extends UpdateCompanion<OfflineOrder> {
  final Value<int> id;
  final Value<String> profileId;
  final Value<double> totalPrice;
  final Value<String> paymentMethod;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  const OfflineOrdersCompanion({
    this.id = const Value.absent(),
    this.profileId = const Value.absent(),
    this.totalPrice = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  });
  OfflineOrdersCompanion.insert({
    this.id = const Value.absent(),
    required String profileId,
    required double totalPrice,
    required String paymentMethod,
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
  })  : profileId = Value(profileId),
        totalPrice = Value(totalPrice),
        paymentMethod = Value(paymentMethod);
  static Insertable<OfflineOrder> custom({
    Expression<int>? id,
    Expression<String>? profileId,
    Expression<double>? totalPrice,
    Expression<String>? paymentMethod,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (profileId != null) 'profile_id': profileId,
      if (totalPrice != null) 'total_price': totalPrice,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
    });
  }

  OfflineOrdersCompanion copyWith(
      {Value<int>? id,
      Value<String>? profileId,
      Value<double>? totalPrice,
      Value<String>? paymentMethod,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced}) {
    return OfflineOrdersCompanion(
      id: id ?? this.id,
      profileId: profileId ?? this.profileId,
      totalPrice: totalPrice ?? this.totalPrice,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (totalPrice.present) {
      map['total_price'] = Variable<double>(totalPrice.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOrdersCompanion(')
          ..write('id: $id, ')
          ..write('profileId: $profileId, ')
          ..write('totalPrice: $totalPrice, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }
}

class $OfflineOrderItemsTable extends OfflineOrderItems
    with TableInfo<$OfflineOrderItemsTable, OfflineOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineOrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES offline_orders (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, orderId, productId, quantity, unitPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OfflineOrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineOrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
    );
  }

  @override
  $OfflineOrderItemsTable createAlias(String alias) {
    return $OfflineOrderItemsTable(attachedDatabase, alias);
  }
}

class OfflineOrderItem extends DataClass
    implements Insertable<OfflineOrderItem> {
  final int id;
  final int orderId;
  final int productId;
  final int quantity;
  final double unitPrice;
  const OfflineOrderItem(
      {required this.id,
      required this.orderId,
      required this.productId,
      required this.quantity,
      required this.unitPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['product_id'] = Variable<int>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    return map;
  }

  OfflineOrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OfflineOrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
    );
  }

  factory OfflineOrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineOrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      productId: serializer.fromJson<int>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'productId': serializer.toJson<int>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
    };
  }

  OfflineOrderItem copyWith(
          {int? id,
          int? orderId,
          int? productId,
          int? quantity,
          double? unitPrice}) =>
      OfflineOrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
      );
  OfflineOrderItem copyWithCompanion(OfflineOrderItemsCompanion data) {
    return OfflineOrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, productId, quantity, unitPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineOrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice);
}

class OfflineOrderItemsCompanion extends UpdateCompanion<OfflineOrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> productId;
  final Value<int> quantity;
  final Value<double> unitPrice;
  const OfflineOrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
  });
  OfflineOrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int productId,
    required int quantity,
    required double unitPrice,
  })  : orderId = Value(orderId),
        productId = Value(productId),
        quantity = Value(quantity),
        unitPrice = Value(unitPrice);
  static Insertable<OfflineOrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? productId,
    Expression<int>? quantity,
    Expression<double>? unitPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
    });
  }

  OfflineOrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? productId,
      Value<int>? quantity,
      Value<double>? unitPrice}) {
    return OfflineOrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineOrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice')
          ..write(')'))
        .toString();
  }
}

class $CurrenciesConfigTable extends CurrenciesConfig
    with TableInfo<$CurrenciesConfigTable, LocalCurrencyConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesConfigTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _accountingIdMeta =
      const VerificationMeta('accountingId');
  @override
  late final GeneratedColumn<int> accountingId = GeneratedColumn<int>(
      'accounting_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _baseCurrencyNameMeta =
      const VerificationMeta('baseCurrencyName');
  @override
  late final GeneratedColumn<String> baseCurrencyName = GeneratedColumn<String>(
      'base_currency_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseCurrencySymbolMeta =
      const VerificationMeta('baseCurrencySymbol');
  @override
  late final GeneratedColumn<String> baseCurrencySymbol =
      GeneratedColumn<String>('base_currency_symbol', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _varCurrencyNameMeta =
      const VerificationMeta('varCurrencyName');
  @override
  late final GeneratedColumn<String> varCurrencyName = GeneratedColumn<String>(
      'var_currency_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _varCurrencySymbolMeta =
      const VerificationMeta('varCurrencySymbol');
  @override
  late final GeneratedColumn<String> varCurrencySymbol =
      GeneratedColumn<String>('var_currency_symbol', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exchangeRateMeta =
      const VerificationMeta('exchangeRate');
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
      'exchange_rate', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountingId,
        baseCurrencyName,
        baseCurrencySymbol,
        varCurrencyName,
        varCurrencySymbol,
        exchangeRate,
        isActive,
        lastUpdated,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies_config';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalCurrencyConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('accounting_id')) {
      context.handle(
          _accountingIdMeta,
          accountingId.isAcceptableOrUnknown(
              data['accounting_id']!, _accountingIdMeta));
    }
    if (data.containsKey('base_currency_name')) {
      context.handle(
          _baseCurrencyNameMeta,
          baseCurrencyName.isAcceptableOrUnknown(
              data['base_currency_name']!, _baseCurrencyNameMeta));
    } else if (isInserting) {
      context.missing(_baseCurrencyNameMeta);
    }
    if (data.containsKey('base_currency_symbol')) {
      context.handle(
          _baseCurrencySymbolMeta,
          baseCurrencySymbol.isAcceptableOrUnknown(
              data['base_currency_symbol']!, _baseCurrencySymbolMeta));
    } else if (isInserting) {
      context.missing(_baseCurrencySymbolMeta);
    }
    if (data.containsKey('var_currency_name')) {
      context.handle(
          _varCurrencyNameMeta,
          varCurrencyName.isAcceptableOrUnknown(
              data['var_currency_name']!, _varCurrencyNameMeta));
    }
    if (data.containsKey('var_currency_symbol')) {
      context.handle(
          _varCurrencySymbolMeta,
          varCurrencySymbol.isAcceptableOrUnknown(
              data['var_currency_symbol']!, _varCurrencySymbolMeta));
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
          _exchangeRateMeta,
          exchangeRate.isAcceptableOrUnknown(
              data['exchange_rate']!, _exchangeRateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalCurrencyConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalCurrencyConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      accountingId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}accounting_id']),
      baseCurrencyName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}base_currency_name'])!,
      baseCurrencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}base_currency_symbol'])!,
      varCurrencyName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}var_currency_name']),
      varCurrencySymbol: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}var_currency_symbol']),
      exchangeRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}exchange_rate']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $CurrenciesConfigTable createAlias(String alias) {
    return $CurrenciesConfigTable(attachedDatabase, alias);
  }
}

class LocalCurrencyConfig extends DataClass
    implements Insertable<LocalCurrencyConfig> {
  final int id;
  final int? accountingId;
  final String baseCurrencyName;
  final String baseCurrencySymbol;
  final String? varCurrencyName;
  final String? varCurrencySymbol;
  final double? exchangeRate;
  final bool isActive;
  final DateTime? lastUpdated;
  final DateTime? syncedAt;
  const LocalCurrencyConfig(
      {required this.id,
      this.accountingId,
      required this.baseCurrencyName,
      required this.baseCurrencySymbol,
      this.varCurrencyName,
      this.varCurrencySymbol,
      this.exchangeRate,
      required this.isActive,
      this.lastUpdated,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || accountingId != null) {
      map['accounting_id'] = Variable<int>(accountingId);
    }
    map['base_currency_name'] = Variable<String>(baseCurrencyName);
    map['base_currency_symbol'] = Variable<String>(baseCurrencySymbol);
    if (!nullToAbsent || varCurrencyName != null) {
      map['var_currency_name'] = Variable<String>(varCurrencyName);
    }
    if (!nullToAbsent || varCurrencySymbol != null) {
      map['var_currency_symbol'] = Variable<String>(varCurrencySymbol);
    }
    if (!nullToAbsent || exchangeRate != null) {
      map['exchange_rate'] = Variable<double>(exchangeRate);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CurrenciesConfigCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesConfigCompanion(
      id: Value(id),
      accountingId: accountingId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountingId),
      baseCurrencyName: Value(baseCurrencyName),
      baseCurrencySymbol: Value(baseCurrencySymbol),
      varCurrencyName: varCurrencyName == null && nullToAbsent
          ? const Value.absent()
          : Value(varCurrencyName),
      varCurrencySymbol: varCurrencySymbol == null && nullToAbsent
          ? const Value.absent()
          : Value(varCurrencySymbol),
      exchangeRate: exchangeRate == null && nullToAbsent
          ? const Value.absent()
          : Value(exchangeRate),
      isActive: Value(isActive),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory LocalCurrencyConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalCurrencyConfig(
      id: serializer.fromJson<int>(json['id']),
      accountingId: serializer.fromJson<int?>(json['accountingId']),
      baseCurrencyName: serializer.fromJson<String>(json['baseCurrencyName']),
      baseCurrencySymbol:
          serializer.fromJson<String>(json['baseCurrencySymbol']),
      varCurrencyName: serializer.fromJson<String?>(json['varCurrencyName']),
      varCurrencySymbol:
          serializer.fromJson<String?>(json['varCurrencySymbol']),
      exchangeRate: serializer.fromJson<double?>(json['exchangeRate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountingId': serializer.toJson<int?>(accountingId),
      'baseCurrencyName': serializer.toJson<String>(baseCurrencyName),
      'baseCurrencySymbol': serializer.toJson<String>(baseCurrencySymbol),
      'varCurrencyName': serializer.toJson<String?>(varCurrencyName),
      'varCurrencySymbol': serializer.toJson<String?>(varCurrencySymbol),
      'exchangeRate': serializer.toJson<double?>(exchangeRate),
      'isActive': serializer.toJson<bool>(isActive),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  LocalCurrencyConfig copyWith(
          {int? id,
          Value<int?> accountingId = const Value.absent(),
          String? baseCurrencyName,
          String? baseCurrencySymbol,
          Value<String?> varCurrencyName = const Value.absent(),
          Value<String?> varCurrencySymbol = const Value.absent(),
          Value<double?> exchangeRate = const Value.absent(),
          bool? isActive,
          Value<DateTime?> lastUpdated = const Value.absent(),
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      LocalCurrencyConfig(
        id: id ?? this.id,
        accountingId:
            accountingId.present ? accountingId.value : this.accountingId,
        baseCurrencyName: baseCurrencyName ?? this.baseCurrencyName,
        baseCurrencySymbol: baseCurrencySymbol ?? this.baseCurrencySymbol,
        varCurrencyName: varCurrencyName.present
            ? varCurrencyName.value
            : this.varCurrencyName,
        varCurrencySymbol: varCurrencySymbol.present
            ? varCurrencySymbol.value
            : this.varCurrencySymbol,
        exchangeRate:
            exchangeRate.present ? exchangeRate.value : this.exchangeRate,
        isActive: isActive ?? this.isActive,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  LocalCurrencyConfig copyWithCompanion(CurrenciesConfigCompanion data) {
    return LocalCurrencyConfig(
      id: data.id.present ? data.id.value : this.id,
      accountingId: data.accountingId.present
          ? data.accountingId.value
          : this.accountingId,
      baseCurrencyName: data.baseCurrencyName.present
          ? data.baseCurrencyName.value
          : this.baseCurrencyName,
      baseCurrencySymbol: data.baseCurrencySymbol.present
          ? data.baseCurrencySymbol.value
          : this.baseCurrencySymbol,
      varCurrencyName: data.varCurrencyName.present
          ? data.varCurrencyName.value
          : this.varCurrencyName,
      varCurrencySymbol: data.varCurrencySymbol.present
          ? data.varCurrencySymbol.value
          : this.varCurrencySymbol,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalCurrencyConfig(')
          ..write('id: $id, ')
          ..write('accountingId: $accountingId, ')
          ..write('baseCurrencyName: $baseCurrencyName, ')
          ..write('baseCurrencySymbol: $baseCurrencySymbol, ')
          ..write('varCurrencyName: $varCurrencyName, ')
          ..write('varCurrencySymbol: $varCurrencySymbol, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isActive: $isActive, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountingId,
      baseCurrencyName,
      baseCurrencySymbol,
      varCurrencyName,
      varCurrencySymbol,
      exchangeRate,
      isActive,
      lastUpdated,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalCurrencyConfig &&
          other.id == this.id &&
          other.accountingId == this.accountingId &&
          other.baseCurrencyName == this.baseCurrencyName &&
          other.baseCurrencySymbol == this.baseCurrencySymbol &&
          other.varCurrencyName == this.varCurrencyName &&
          other.varCurrencySymbol == this.varCurrencySymbol &&
          other.exchangeRate == this.exchangeRate &&
          other.isActive == this.isActive &&
          other.lastUpdated == this.lastUpdated &&
          other.syncedAt == this.syncedAt);
}

class CurrenciesConfigCompanion extends UpdateCompanion<LocalCurrencyConfig> {
  final Value<int> id;
  final Value<int?> accountingId;
  final Value<String> baseCurrencyName;
  final Value<String> baseCurrencySymbol;
  final Value<String?> varCurrencyName;
  final Value<String?> varCurrencySymbol;
  final Value<double?> exchangeRate;
  final Value<bool> isActive;
  final Value<DateTime?> lastUpdated;
  final Value<DateTime?> syncedAt;
  const CurrenciesConfigCompanion({
    this.id = const Value.absent(),
    this.accountingId = const Value.absent(),
    this.baseCurrencyName = const Value.absent(),
    this.baseCurrencySymbol = const Value.absent(),
    this.varCurrencyName = const Value.absent(),
    this.varCurrencySymbol = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CurrenciesConfigCompanion.insert({
    this.id = const Value.absent(),
    this.accountingId = const Value.absent(),
    required String baseCurrencyName,
    required String baseCurrencySymbol,
    this.varCurrencyName = const Value.absent(),
    this.varCurrencySymbol = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.syncedAt = const Value.absent(),
  })  : baseCurrencyName = Value(baseCurrencyName),
        baseCurrencySymbol = Value(baseCurrencySymbol);
  static Insertable<LocalCurrencyConfig> custom({
    Expression<int>? id,
    Expression<int>? accountingId,
    Expression<String>? baseCurrencyName,
    Expression<String>? baseCurrencySymbol,
    Expression<String>? varCurrencyName,
    Expression<String>? varCurrencySymbol,
    Expression<double>? exchangeRate,
    Expression<bool>? isActive,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountingId != null) 'accounting_id': accountingId,
      if (baseCurrencyName != null) 'base_currency_name': baseCurrencyName,
      if (baseCurrencySymbol != null)
        'base_currency_symbol': baseCurrencySymbol,
      if (varCurrencyName != null) 'var_currency_name': varCurrencyName,
      if (varCurrencySymbol != null) 'var_currency_symbol': varCurrencySymbol,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (isActive != null) 'is_active': isActive,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CurrenciesConfigCompanion copyWith(
      {Value<int>? id,
      Value<int?>? accountingId,
      Value<String>? baseCurrencyName,
      Value<String>? baseCurrencySymbol,
      Value<String?>? varCurrencyName,
      Value<String?>? varCurrencySymbol,
      Value<double?>? exchangeRate,
      Value<bool>? isActive,
      Value<DateTime?>? lastUpdated,
      Value<DateTime?>? syncedAt}) {
    return CurrenciesConfigCompanion(
      id: id ?? this.id,
      accountingId: accountingId ?? this.accountingId,
      baseCurrencyName: baseCurrencyName ?? this.baseCurrencyName,
      baseCurrencySymbol: baseCurrencySymbol ?? this.baseCurrencySymbol,
      varCurrencyName: varCurrencyName ?? this.varCurrencyName,
      varCurrencySymbol: varCurrencySymbol ?? this.varCurrencySymbol,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      isActive: isActive ?? this.isActive,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountingId.present) {
      map['accounting_id'] = Variable<int>(accountingId.value);
    }
    if (baseCurrencyName.present) {
      map['base_currency_name'] = Variable<String>(baseCurrencyName.value);
    }
    if (baseCurrencySymbol.present) {
      map['base_currency_symbol'] = Variable<String>(baseCurrencySymbol.value);
    }
    if (varCurrencyName.present) {
      map['var_currency_name'] = Variable<String>(varCurrencyName.value);
    }
    if (varCurrencySymbol.present) {
      map['var_currency_symbol'] = Variable<String>(varCurrencySymbol.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesConfigCompanion(')
          ..write('id: $id, ')
          ..write('accountingId: $accountingId, ')
          ..write('baseCurrencyName: $baseCurrencyName, ')
          ..write('baseCurrencySymbol: $baseCurrencySymbol, ')
          ..write('varCurrencyName: $varCurrencyName, ')
          ..write('varCurrencySymbol: $varCurrencySymbol, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('isActive: $isActive, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class $BatchUnitPricesTable extends BatchUnitPrices
    with TableInfo<$BatchUnitPricesTable, LocalBatchUnitPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchUnitPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _batchIdMeta =
      const VerificationMeta('batchId');
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
      'batch_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, batchId, unitId, sellingPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batch_unit_prices';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalBatchUnitPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('batch_id')) {
      context.handle(_batchIdMeta,
          batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta));
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalBatchUnitPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalBatchUnitPrice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      batchId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}batch_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
    );
  }

  @override
  $BatchUnitPricesTable createAlias(String alias) {
    return $BatchUnitPricesTable(attachedDatabase, alias);
  }
}

class LocalBatchUnitPrice extends DataClass
    implements Insertable<LocalBatchUnitPrice> {
  final int id;
  final int batchId;
  final int unitId;
  final double sellingPrice;
  const LocalBatchUnitPrice(
      {required this.id,
      required this.batchId,
      required this.unitId,
      required this.sellingPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['batch_id'] = Variable<int>(batchId);
    map['unit_id'] = Variable<int>(unitId);
    map['selling_price'] = Variable<double>(sellingPrice);
    return map;
  }

  BatchUnitPricesCompanion toCompanion(bool nullToAbsent) {
    return BatchUnitPricesCompanion(
      id: Value(id),
      batchId: Value(batchId),
      unitId: Value(unitId),
      sellingPrice: Value(sellingPrice),
    );
  }

  factory LocalBatchUnitPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalBatchUnitPrice(
      id: serializer.fromJson<int>(json['id']),
      batchId: serializer.fromJson<int>(json['batchId']),
      unitId: serializer.fromJson<int>(json['unitId']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'batchId': serializer.toJson<int>(batchId),
      'unitId': serializer.toJson<int>(unitId),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
    };
  }

  LocalBatchUnitPrice copyWith(
          {int? id, int? batchId, int? unitId, double? sellingPrice}) =>
      LocalBatchUnitPrice(
        id: id ?? this.id,
        batchId: batchId ?? this.batchId,
        unitId: unitId ?? this.unitId,
        sellingPrice: sellingPrice ?? this.sellingPrice,
      );
  LocalBatchUnitPrice copyWithCompanion(BatchUnitPricesCompanion data) {
    return LocalBatchUnitPrice(
      id: data.id.present ? data.id.value : this.id,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalBatchUnitPrice(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, batchId, unitId, sellingPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalBatchUnitPrice &&
          other.id == this.id &&
          other.batchId == this.batchId &&
          other.unitId == this.unitId &&
          other.sellingPrice == this.sellingPrice);
}

class BatchUnitPricesCompanion extends UpdateCompanion<LocalBatchUnitPrice> {
  final Value<int> id;
  final Value<int> batchId;
  final Value<int> unitId;
  final Value<double> sellingPrice;
  const BatchUnitPricesCompanion({
    this.id = const Value.absent(),
    this.batchId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.sellingPrice = const Value.absent(),
  });
  BatchUnitPricesCompanion.insert({
    this.id = const Value.absent(),
    required int batchId,
    required int unitId,
    required double sellingPrice,
  })  : batchId = Value(batchId),
        unitId = Value(unitId),
        sellingPrice = Value(sellingPrice);
  static Insertable<LocalBatchUnitPrice> custom({
    Expression<int>? id,
    Expression<int>? batchId,
    Expression<int>? unitId,
    Expression<double>? sellingPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (batchId != null) 'batch_id': batchId,
      if (unitId != null) 'unit_id': unitId,
      if (sellingPrice != null) 'selling_price': sellingPrice,
    });
  }

  BatchUnitPricesCompanion copyWith(
      {Value<int>? id,
      Value<int>? batchId,
      Value<int>? unitId,
      Value<double>? sellingPrice}) {
    return BatchUnitPricesCompanion(
      id: id ?? this.id,
      batchId: batchId ?? this.batchId,
      unitId: unitId ?? this.unitId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchUnitPricesCompanion(')
          ..write('id: $id, ')
          ..write('batchId: $batchId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }
}

class $ProductUnitPricesTable extends ProductUnitPrices
    with TableInfo<$ProductUnitPricesTable, LocalProductUnitPrice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUnitPricesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitIdMeta = const VerificationMeta('unitId');
  @override
  late final GeneratedColumn<int> unitId = GeneratedColumn<int>(
      'unit_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _conversionToBaseMeta =
      const VerificationMeta('conversionToBase');
  @override
  late final GeneratedColumn<double> conversionToBase = GeneratedColumn<double>(
      'conversion_to_base', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, unitId, sellingPrice, conversionToBase];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_unit_prices';
  @override
  VerificationContext validateIntegrity(
      Insertable<LocalProductUnitPrice> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('unit_id')) {
      context.handle(_unitIdMeta,
          unitId.isAcceptableOrUnknown(data['unit_id']!, _unitIdMeta));
    } else if (isInserting) {
      context.missing(_unitIdMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    if (data.containsKey('conversion_to_base')) {
      context.handle(
          _conversionToBaseMeta,
          conversionToBase.isAcceptableOrUnknown(
              data['conversion_to_base']!, _conversionToBaseMeta));
    } else if (isInserting) {
      context.missing(_conversionToBaseMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductUnitPrice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductUnitPrice(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      unitId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_id'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
      conversionToBase: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}conversion_to_base'])!,
    );
  }

  @override
  $ProductUnitPricesTable createAlias(String alias) {
    return $ProductUnitPricesTable(attachedDatabase, alias);
  }
}

class LocalProductUnitPrice extends DataClass
    implements Insertable<LocalProductUnitPrice> {
  final int id;
  final int productId;
  final int unitId;
  final double sellingPrice;
  final double conversionToBase;
  const LocalProductUnitPrice(
      {required this.id,
      required this.productId,
      required this.unitId,
      required this.sellingPrice,
      required this.conversionToBase});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['unit_id'] = Variable<int>(unitId);
    map['selling_price'] = Variable<double>(sellingPrice);
    map['conversion_to_base'] = Variable<double>(conversionToBase);
    return map;
  }

  ProductUnitPricesCompanion toCompanion(bool nullToAbsent) {
    return ProductUnitPricesCompanion(
      id: Value(id),
      productId: Value(productId),
      unitId: Value(unitId),
      sellingPrice: Value(sellingPrice),
      conversionToBase: Value(conversionToBase),
    );
  }

  factory LocalProductUnitPrice.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductUnitPrice(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      unitId: serializer.fromJson<int>(json['unitId']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
      conversionToBase: serializer.fromJson<double>(json['conversionToBase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'unitId': serializer.toJson<int>(unitId),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
      'conversionToBase': serializer.toJson<double>(conversionToBase),
    };
  }

  LocalProductUnitPrice copyWith(
          {int? id,
          int? productId,
          int? unitId,
          double? sellingPrice,
          double? conversionToBase}) =>
      LocalProductUnitPrice(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        unitId: unitId ?? this.unitId,
        sellingPrice: sellingPrice ?? this.sellingPrice,
        conversionToBase: conversionToBase ?? this.conversionToBase,
      );
  LocalProductUnitPrice copyWithCompanion(ProductUnitPricesCompanion data) {
    return LocalProductUnitPrice(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      unitId: data.unitId.present ? data.unitId.value : this.unitId,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
      conversionToBase: data.conversionToBase.present
          ? data.conversionToBase.value
          : this.conversionToBase,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductUnitPrice(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('conversionToBase: $conversionToBase')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, unitId, sellingPrice, conversionToBase);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductUnitPrice &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.unitId == this.unitId &&
          other.sellingPrice == this.sellingPrice &&
          other.conversionToBase == this.conversionToBase);
}

class ProductUnitPricesCompanion
    extends UpdateCompanion<LocalProductUnitPrice> {
  final Value<int> id;
  final Value<int> productId;
  final Value<int> unitId;
  final Value<double> sellingPrice;
  final Value<double> conversionToBase;
  const ProductUnitPricesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.unitId = const Value.absent(),
    this.sellingPrice = const Value.absent(),
    this.conversionToBase = const Value.absent(),
  });
  ProductUnitPricesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required int unitId,
    required double sellingPrice,
    required double conversionToBase,
  })  : productId = Value(productId),
        unitId = Value(unitId),
        sellingPrice = Value(sellingPrice),
        conversionToBase = Value(conversionToBase);
  static Insertable<LocalProductUnitPrice> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<int>? unitId,
    Expression<double>? sellingPrice,
    Expression<double>? conversionToBase,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (unitId != null) 'unit_id': unitId,
      if (sellingPrice != null) 'selling_price': sellingPrice,
      if (conversionToBase != null) 'conversion_to_base': conversionToBase,
    });
  }

  ProductUnitPricesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<int>? unitId,
      Value<double>? sellingPrice,
      Value<double>? conversionToBase}) {
    return ProductUnitPricesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      unitId: unitId ?? this.unitId,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      conversionToBase: conversionToBase ?? this.conversionToBase,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (unitId.present) {
      map['unit_id'] = Variable<int>(unitId.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    if (conversionToBase.present) {
      map['conversion_to_base'] = Variable<double>(conversionToBase.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnitPricesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('unitId: $unitId, ')
          ..write('sellingPrice: $sellingPrice, ')
          ..write('conversionToBase: $conversionToBase')
          ..write(')'))
        .toString();
  }
}

class $ProductBatchesTable extends ProductBatches
    with TableInfo<$ProductBatchesTable, LocalProductBatch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductBatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
      'product_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _batchNumberMeta =
      const VerificationMeta('batchNumber');
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
      'batch_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sellingPriceMeta =
      const VerificationMeta('sellingPrice');
  @override
  late final GeneratedColumn<double> sellingPrice = GeneratedColumn<double>(
      'selling_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, batchNumber, sellingPrice];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_batches';
  @override
  VerificationContext validateIntegrity(Insertable<LocalProductBatch> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('batch_number')) {
      context.handle(
          _batchNumberMeta,
          batchNumber.isAcceptableOrUnknown(
              data['batch_number']!, _batchNumberMeta));
    } else if (isInserting) {
      context.missing(_batchNumberMeta);
    }
    if (data.containsKey('selling_price')) {
      context.handle(
          _sellingPriceMeta,
          sellingPrice.isAcceptableOrUnknown(
              data['selling_price']!, _sellingPriceMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProductBatch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProductBatch(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}product_id'])!,
      batchNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}batch_number'])!,
      sellingPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}selling_price'])!,
    );
  }

  @override
  $ProductBatchesTable createAlias(String alias) {
    return $ProductBatchesTable(attachedDatabase, alias);
  }
}

class LocalProductBatch extends DataClass
    implements Insertable<LocalProductBatch> {
  final int id;
  final int productId;
  final String batchNumber;
  final double sellingPrice;
  const LocalProductBatch(
      {required this.id,
      required this.productId,
      required this.batchNumber,
      required this.sellingPrice});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['batch_number'] = Variable<String>(batchNumber);
    map['selling_price'] = Variable<double>(sellingPrice);
    return map;
  }

  ProductBatchesCompanion toCompanion(bool nullToAbsent) {
    return ProductBatchesCompanion(
      id: Value(id),
      productId: Value(productId),
      batchNumber: Value(batchNumber),
      sellingPrice: Value(sellingPrice),
    );
  }

  factory LocalProductBatch.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProductBatch(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      batchNumber: serializer.fromJson<String>(json['batchNumber']),
      sellingPrice: serializer.fromJson<double>(json['sellingPrice']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'batchNumber': serializer.toJson<String>(batchNumber),
      'sellingPrice': serializer.toJson<double>(sellingPrice),
    };
  }

  LocalProductBatch copyWith(
          {int? id,
          int? productId,
          String? batchNumber,
          double? sellingPrice}) =>
      LocalProductBatch(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        batchNumber: batchNumber ?? this.batchNumber,
        sellingPrice: sellingPrice ?? this.sellingPrice,
      );
  LocalProductBatch copyWithCompanion(ProductBatchesCompanion data) {
    return LocalProductBatch(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      batchNumber:
          data.batchNumber.present ? data.batchNumber.value : this.batchNumber,
      sellingPrice: data.sellingPrice.present
          ? data.sellingPrice.value
          : this.sellingPrice,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProductBatch(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, batchNumber, sellingPrice);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProductBatch &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.batchNumber == this.batchNumber &&
          other.sellingPrice == this.sellingPrice);
}

class ProductBatchesCompanion extends UpdateCompanion<LocalProductBatch> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> batchNumber;
  final Value<double> sellingPrice;
  const ProductBatchesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.sellingPrice = const Value.absent(),
  });
  ProductBatchesCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String batchNumber,
    required double sellingPrice,
  })  : productId = Value(productId),
        batchNumber = Value(batchNumber),
        sellingPrice = Value(sellingPrice);
  static Insertable<LocalProductBatch> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? batchNumber,
    Expression<double>? sellingPrice,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (sellingPrice != null) 'selling_price': sellingPrice,
    });
  }

  ProductBatchesCompanion copyWith(
      {Value<int>? id,
      Value<int>? productId,
      Value<String>? batchNumber,
      Value<double>? sellingPrice}) {
    return ProductBatchesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      batchNumber: batchNumber ?? this.batchNumber,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (sellingPrice.present) {
      map['selling_price'] = Variable<double>(sellingPrice.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductBatchesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('sellingPrice: $sellingPrice')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LocalLedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<double> debit = GeneratedColumn<double>(
      'debit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<double> credit = GeneratedColumn<double>(
      'credit', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _balanceAfterMeta =
      const VerificationMeta('balanceAfter');
  @override
  late final GeneratedColumn<double> balanceAfter = GeneratedColumn<double>(
      'balance_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _documentNumberMeta =
      const VerificationMeta('documentNumber');
  @override
  late final GeneratedColumn<String> documentNumber = GeneratedColumn<String>(
      'document_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _sortIndexMeta =
      const VerificationMeta('sortIndex');
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
      'sort_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operationType,
        description,
        debit,
        credit,
        balanceAfter,
        documentNumber,
        createdAt,
        sortIndex,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LocalLedgerEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('debit')) {
      context.handle(
          _debitMeta, debit.isAcceptableOrUnknown(data['debit']!, _debitMeta));
    } else if (isInserting) {
      context.missing(_debitMeta);
    }
    if (data.containsKey('credit')) {
      context.handle(_creditMeta,
          credit.isAcceptableOrUnknown(data['credit']!, _creditMeta));
    } else if (isInserting) {
      context.missing(_creditMeta);
    }
    if (data.containsKey('balance_after')) {
      context.handle(
          _balanceAfterMeta,
          balanceAfter.isAcceptableOrUnknown(
              data['balance_after']!, _balanceAfterMeta));
    } else if (isInserting) {
      context.missing(_balanceAfterMeta);
    }
    if (data.containsKey('document_number')) {
      context.handle(
          _documentNumberMeta,
          documentNumber.isAcceptableOrUnknown(
              data['document_number']!, _documentNumberMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(_sortIndexMeta,
          sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalLedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalLedgerEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      debit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}debit'])!,
      credit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit'])!,
      balanceAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}balance_after'])!,
      documentNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_number']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      sortIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_index'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LocalLedgerEntry extends DataClass
    implements Insertable<LocalLedgerEntry> {
  final int id;
  final String operationType;
  final String? description;
  final double debit;
  final double credit;
  final double balanceAfter;
  final String? documentNumber;
  final DateTime createdAt;
  final int sortIndex;
  final DateTime? syncedAt;
  const LocalLedgerEntry(
      {required this.id,
      required this.operationType,
      this.description,
      required this.debit,
      required this.credit,
      required this.balanceAfter,
      this.documentNumber,
      required this.createdAt,
      required this.sortIndex,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['operation_type'] = Variable<String>(operationType);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['debit'] = Variable<double>(debit);
    map['credit'] = Variable<double>(credit);
    map['balance_after'] = Variable<double>(balanceAfter);
    if (!nullToAbsent || documentNumber != null) {
      map['document_number'] = Variable<String>(documentNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sort_index'] = Variable<int>(sortIndex);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      id: Value(id),
      operationType: Value(operationType),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      debit: Value(debit),
      credit: Value(credit),
      balanceAfter: Value(balanceAfter),
      documentNumber: documentNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(documentNumber),
      createdAt: Value(createdAt),
      sortIndex: Value(sortIndex),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory LocalLedgerEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalLedgerEntry(
      id: serializer.fromJson<int>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      description: serializer.fromJson<String?>(json['description']),
      debit: serializer.fromJson<double>(json['debit']),
      credit: serializer.fromJson<double>(json['credit']),
      balanceAfter: serializer.fromJson<double>(json['balanceAfter']),
      documentNumber: serializer.fromJson<String?>(json['documentNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'operationType': serializer.toJson<String>(operationType),
      'description': serializer.toJson<String?>(description),
      'debit': serializer.toJson<double>(debit),
      'credit': serializer.toJson<double>(credit),
      'balanceAfter': serializer.toJson<double>(balanceAfter),
      'documentNumber': serializer.toJson<String?>(documentNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  LocalLedgerEntry copyWith(
          {int? id,
          String? operationType,
          Value<String?> description = const Value.absent(),
          double? debit,
          double? credit,
          double? balanceAfter,
          Value<String?> documentNumber = const Value.absent(),
          DateTime? createdAt,
          int? sortIndex,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      LocalLedgerEntry(
        id: id ?? this.id,
        operationType: operationType ?? this.operationType,
        description: description.present ? description.value : this.description,
        debit: debit ?? this.debit,
        credit: credit ?? this.credit,
        balanceAfter: balanceAfter ?? this.balanceAfter,
        documentNumber:
            documentNumber.present ? documentNumber.value : this.documentNumber,
        createdAt: createdAt ?? this.createdAt,
        sortIndex: sortIndex ?? this.sortIndex,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  LocalLedgerEntry copyWithCompanion(LedgerEntriesCompanion data) {
    return LocalLedgerEntry(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      description:
          data.description.present ? data.description.value : this.description,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      balanceAfter: data.balanceAfter.present
          ? data.balanceAfter.value
          : this.balanceAfter,
      documentNumber: data.documentNumber.present
          ? data.documentNumber.value
          : this.documentNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalLedgerEntry(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('description: $description, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, operationType, description, debit, credit,
      balanceAfter, documentNumber, createdAt, sortIndex, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalLedgerEntry &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.description == this.description &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.balanceAfter == this.balanceAfter &&
          other.documentNumber == this.documentNumber &&
          other.createdAt == this.createdAt &&
          other.sortIndex == this.sortIndex &&
          other.syncedAt == this.syncedAt);
}

class LedgerEntriesCompanion extends UpdateCompanion<LocalLedgerEntry> {
  final Value<int> id;
  final Value<String> operationType;
  final Value<String?> description;
  final Value<double> debit;
  final Value<double> credit;
  final Value<double> balanceAfter;
  final Value<String?> documentNumber;
  final Value<DateTime> createdAt;
  final Value<int> sortIndex;
  final Value<DateTime?> syncedAt;
  const LedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.description = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.balanceAfter = const Value.absent(),
    this.documentNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String operationType,
    this.description = const Value.absent(),
    required double debit,
    required double credit,
    required double balanceAfter,
    this.documentNumber = const Value.absent(),
    required DateTime createdAt,
    this.sortIndex = const Value.absent(),
    this.syncedAt = const Value.absent(),
  })  : operationType = Value(operationType),
        debit = Value(debit),
        credit = Value(credit),
        balanceAfter = Value(balanceAfter),
        createdAt = Value(createdAt);
  static Insertable<LocalLedgerEntry> custom({
    Expression<int>? id,
    Expression<String>? operationType,
    Expression<String>? description,
    Expression<double>? debit,
    Expression<double>? credit,
    Expression<double>? balanceAfter,
    Expression<String>? documentNumber,
    Expression<DateTime>? createdAt,
    Expression<int>? sortIndex,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (description != null) 'description': description,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (balanceAfter != null) 'balance_after': balanceAfter,
      if (documentNumber != null) 'document_number': documentNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  LedgerEntriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? operationType,
      Value<String?>? description,
      Value<double>? debit,
      Value<double>? credit,
      Value<double>? balanceAfter,
      Value<String?>? documentNumber,
      Value<DateTime>? createdAt,
      Value<int>? sortIndex,
      Value<DateTime?>? syncedAt}) {
    return LedgerEntriesCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      description: description ?? this.description,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      documentNumber: documentNumber ?? this.documentNumber,
      createdAt: createdAt ?? this.createdAt,
      sortIndex: sortIndex ?? this.sortIndex,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (debit.present) {
      map['debit'] = Variable<double>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<double>(credit.value);
    }
    if (balanceAfter.present) {
      map['balance_after'] = Variable<double>(balanceAfter.value);
    }
    if (documentNumber.present) {
      map['document_number'] = Variable<String>(documentNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('description: $description, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('balanceAfter: $balanceAfter, ')
          ..write('documentNumber: $documentNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductCategoriesTable productCategories =
      $ProductCategoriesTable(this);
  late final $OfflineOrdersTable offlineOrders = $OfflineOrdersTable(this);
  late final $OfflineOrderItemsTable offlineOrderItems =
      $OfflineOrderItemsTable(this);
  late final $CurrenciesConfigTable currenciesConfig =
      $CurrenciesConfigTable(this);
  late final $BatchUnitPricesTable batchUnitPrices =
      $BatchUnitPricesTable(this);
  late final $ProductUnitPricesTable productUnitPrices =
      $ProductUnitPricesTable(this);
  late final $ProductBatchesTable productBatches = $ProductBatchesTable(this);
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        products,
        productCategories,
        offlineOrders,
        offlineOrderItems,
        currenciesConfig,
        batchUnitPrices,
        productUnitPrices,
        productBatches,
        ledgerEntries
      ];
}

typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  required String name,
  Value<String?> code,
  Value<String?> barcode,
  required double sellingPrice,
  Value<String?> description,
  Value<String?> imagePath,
  Value<int?> baseUnitId,
  Value<String?> baseUnitName,
  Value<bool> hasMultiUnits,
  Value<bool> hasBatches,
  Value<bool> isActive,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String?> code,
  Value<String?> barcode,
  Value<double> sellingPrice,
  Value<String?> description,
  Value<String?> imagePath,
  Value<int?> baseUnitId,
  Value<String?> baseUnitName,
  Value<bool> hasMultiUnits,
  Value<bool> hasBatches,
  Value<bool> isActive,
});

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get baseUnitId => $composableBuilder(
      column: $table.baseUnitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUnitName => $composableBuilder(
      column: $table.baseUnitName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasMultiUnits => $composableBuilder(
      column: $table.hasMultiUnits, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasBatches => $composableBuilder(
      column: $table.hasBatches, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get baseUnitId => $composableBuilder(
      column: $table.baseUnitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUnitName => $composableBuilder(
      column: $table.baseUnitName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasMultiUnits => $composableBuilder(
      column: $table.hasMultiUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasBatches => $composableBuilder(
      column: $table.hasBatches, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<int> get baseUnitId => $composableBuilder(
      column: $table.baseUnitId, builder: (column) => column);

  GeneratedColumn<String> get baseUnitName => $composableBuilder(
      column: $table.baseUnitName, builder: (column) => column);

  GeneratedColumn<bool> get hasMultiUnits => $composableBuilder(
      column: $table.hasMultiUnits, builder: (column) => column);

  GeneratedColumn<bool> get hasBatches => $composableBuilder(
      column: $table.hasBatches, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    LocalProduct,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (LocalProduct, BaseReferences<_$AppDatabase, $ProductsTable, LocalProduct>),
    LocalProduct,
    PrefetchHooks Function()> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> code = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<int?> baseUnitId = const Value.absent(),
            Value<String?> baseUnitName = const Value.absent(),
            Value<bool> hasMultiUnits = const Value.absent(),
            Value<bool> hasBatches = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            name: name,
            code: code,
            barcode: barcode,
            sellingPrice: sellingPrice,
            description: description,
            imagePath: imagePath,
            baseUnitId: baseUnitId,
            baseUnitName: baseUnitName,
            hasMultiUnits: hasMultiUnits,
            hasBatches: hasBatches,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> code = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            required double sellingPrice,
            Value<String?> description = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<int?> baseUnitId = const Value.absent(),
            Value<String?> baseUnitName = const Value.absent(),
            Value<bool> hasMultiUnits = const Value.absent(),
            Value<bool> hasBatches = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            name: name,
            code: code,
            barcode: barcode,
            sellingPrice: sellingPrice,
            description: description,
            imagePath: imagePath,
            baseUnitId: baseUnitId,
            baseUnitName: baseUnitName,
            hasMultiUnits: hasMultiUnits,
            hasBatches: hasBatches,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    LocalProduct,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (LocalProduct, BaseReferences<_$AppDatabase, $ProductsTable, LocalProduct>),
    LocalProduct,
    PrefetchHooks Function()>;
typedef $$ProductCategoriesTableCreateCompanionBuilder
    = ProductCategoriesCompanion Function({
  Value<int> id,
  Value<int?> accountingId,
  required String name,
  Value<String?> description,
  Value<int?> parentId,
  Value<int?> parentAccountingId,
  Value<int> sortOrder,
  Value<String?> imagePath,
  Value<bool> isActive,
  Value<String?> childrenJson,
});
typedef $$ProductCategoriesTableUpdateCompanionBuilder
    = ProductCategoriesCompanion Function({
  Value<int> id,
  Value<int?> accountingId,
  Value<String> name,
  Value<String?> description,
  Value<int?> parentId,
  Value<int?> parentAccountingId,
  Value<int> sortOrder,
  Value<String?> imagePath,
  Value<bool> isActive,
  Value<String?> childrenJson,
});

class $$ProductCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountingId => $composableBuilder(
      column: $table.accountingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentAccountingId => $composableBuilder(
      column: $table.parentAccountingId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get childrenJson => $composableBuilder(
      column: $table.childrenJson, builder: (column) => ColumnFilters(column));
}

class $$ProductCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountingId => $composableBuilder(
      column: $table.accountingId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentId => $composableBuilder(
      column: $table.parentId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentAccountingId => $composableBuilder(
      column: $table.parentAccountingId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get childrenJson => $composableBuilder(
      column: $table.childrenJson,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductCategoriesTable> {
  $$ProductCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountingId => $composableBuilder(
      column: $table.accountingId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get parentAccountingId => $composableBuilder(
      column: $table.parentAccountingId, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get childrenJson => $composableBuilder(
      column: $table.childrenJson, builder: (column) => column);
}

class $$ProductCategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductCategoriesTable,
    LocalProductCategory,
    $$ProductCategoriesTableFilterComposer,
    $$ProductCategoriesTableOrderingComposer,
    $$ProductCategoriesTableAnnotationComposer,
    $$ProductCategoriesTableCreateCompanionBuilder,
    $$ProductCategoriesTableUpdateCompanionBuilder,
    (
      LocalProductCategory,
      BaseReferences<_$AppDatabase, $ProductCategoriesTable,
          LocalProductCategory>
    ),
    LocalProductCategory,
    PrefetchHooks Function()> {
  $$ProductCategoriesTableTableManager(
      _$AppDatabase db, $ProductCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> accountingId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int?> parentAccountingId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> childrenJson = const Value.absent(),
          }) =>
              ProductCategoriesCompanion(
            id: id,
            accountingId: accountingId,
            name: name,
            description: description,
            parentId: parentId,
            parentAccountingId: parentAccountingId,
            sortOrder: sortOrder,
            imagePath: imagePath,
            isActive: isActive,
            childrenJson: childrenJson,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> accountingId = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<int?> parentAccountingId = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> childrenJson = const Value.absent(),
          }) =>
              ProductCategoriesCompanion.insert(
            id: id,
            accountingId: accountingId,
            name: name,
            description: description,
            parentId: parentId,
            parentAccountingId: parentAccountingId,
            sortOrder: sortOrder,
            imagePath: imagePath,
            isActive: isActive,
            childrenJson: childrenJson,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductCategoriesTable,
    LocalProductCategory,
    $$ProductCategoriesTableFilterComposer,
    $$ProductCategoriesTableOrderingComposer,
    $$ProductCategoriesTableAnnotationComposer,
    $$ProductCategoriesTableCreateCompanionBuilder,
    $$ProductCategoriesTableUpdateCompanionBuilder,
    (
      LocalProductCategory,
      BaseReferences<_$AppDatabase, $ProductCategoriesTable,
          LocalProductCategory>
    ),
    LocalProductCategory,
    PrefetchHooks Function()>;
typedef $$OfflineOrdersTableCreateCompanionBuilder = OfflineOrdersCompanion
    Function({
  Value<int> id,
  required String profileId,
  required double totalPrice,
  required String paymentMethod,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
});
typedef $$OfflineOrdersTableUpdateCompanionBuilder = OfflineOrdersCompanion
    Function({
  Value<int> id,
  Value<String> profileId,
  Value<double> totalPrice,
  Value<String> paymentMethod,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
});

final class $$OfflineOrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OfflineOrdersTable, OfflineOrder> {
  $$OfflineOrdersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OfflineOrderItemsTable, List<OfflineOrderItem>>
      _offlineOrderItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.offlineOrderItems,
              aliasName: 'offline_orders__id__offline_order_items__order_id');

  $$OfflineOrderItemsTableProcessedTableManager get offlineOrderItemsRefs {
    final manager =
        $$OfflineOrderItemsTableTableManager($_db, $_db.offlineOrderItems)
            .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_offlineOrderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OfflineOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineOrdersTable> {
  $$OfflineOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  Expression<bool> offlineOrderItemsRefs(
      Expression<bool> Function($$OfflineOrderItemsTableFilterComposer f) f) {
    final $$OfflineOrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.offlineOrderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OfflineOrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.offlineOrderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OfflineOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineOrdersTable> {
  $$OfflineOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get profileId => $composableBuilder(
      column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));
}

class $$OfflineOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineOrdersTable> {
  $$OfflineOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<double> get totalPrice => $composableBuilder(
      column: $table.totalPrice, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  Expression<T> offlineOrderItemsRefs<T extends Object>(
      Expression<T> Function($$OfflineOrderItemsTableAnnotationComposer a) f) {
    final $$OfflineOrderItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.offlineOrderItems,
            getReferencedColumn: (t) => t.orderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OfflineOrderItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.offlineOrderItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$OfflineOrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OfflineOrdersTable,
    OfflineOrder,
    $$OfflineOrdersTableFilterComposer,
    $$OfflineOrdersTableOrderingComposer,
    $$OfflineOrdersTableAnnotationComposer,
    $$OfflineOrdersTableCreateCompanionBuilder,
    $$OfflineOrdersTableUpdateCompanionBuilder,
    (OfflineOrder, $$OfflineOrdersTableReferences),
    OfflineOrder,
    PrefetchHooks Function({bool offlineOrderItemsRefs})> {
  $$OfflineOrdersTableTableManager(_$AppDatabase db, $OfflineOrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> profileId = const Value.absent(),
            Value<double> totalPrice = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
          }) =>
              OfflineOrdersCompanion(
            id: id,
            profileId: profileId,
            totalPrice: totalPrice,
            paymentMethod: paymentMethod,
            createdAt: createdAt,
            isSynced: isSynced,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String profileId,
            required double totalPrice,
            required String paymentMethod,
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
          }) =>
              OfflineOrdersCompanion.insert(
            id: id,
            profileId: profileId,
            totalPrice: totalPrice,
            paymentMethod: paymentMethod,
            createdAt: createdAt,
            isSynced: isSynced,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OfflineOrdersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({offlineOrderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (offlineOrderItemsRefs) db.offlineOrderItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (offlineOrderItemsRefs)
                    await $_getPrefetchedData<OfflineOrder, $OfflineOrdersTable,
                            OfflineOrderItem>(
                        currentTable: table,
                        referencedTable: $$OfflineOrdersTableReferences
                            ._offlineOrderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OfflineOrdersTableReferences(db, table, p0)
                                .offlineOrderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OfflineOrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OfflineOrdersTable,
    OfflineOrder,
    $$OfflineOrdersTableFilterComposer,
    $$OfflineOrdersTableOrderingComposer,
    $$OfflineOrdersTableAnnotationComposer,
    $$OfflineOrdersTableCreateCompanionBuilder,
    $$OfflineOrdersTableUpdateCompanionBuilder,
    (OfflineOrder, $$OfflineOrdersTableReferences),
    OfflineOrder,
    PrefetchHooks Function({bool offlineOrderItemsRefs})>;
typedef $$OfflineOrderItemsTableCreateCompanionBuilder
    = OfflineOrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int productId,
  required int quantity,
  required double unitPrice,
});
typedef $$OfflineOrderItemsTableUpdateCompanionBuilder
    = OfflineOrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> productId,
  Value<int> quantity,
  Value<double> unitPrice,
});

final class $$OfflineOrderItemsTableReferences extends BaseReferences<
    _$AppDatabase, $OfflineOrderItemsTable, OfflineOrderItem> {
  $$OfflineOrderItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OfflineOrdersTable _orderIdTable(_$AppDatabase db) => db.offlineOrders
      .createAlias('offline_order_items__order_id__offline_orders__id');

  $$OfflineOrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OfflineOrdersTableTableManager($_db, $_db.offlineOrders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OfflineOrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineOrderItemsTable> {
  $$OfflineOrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  $$OfflineOrdersTableFilterComposer get orderId {
    final $$OfflineOrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.offlineOrders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OfflineOrdersTableFilterComposer(
              $db: $db,
              $table: $db.offlineOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OfflineOrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineOrderItemsTable> {
  $$OfflineOrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  $$OfflineOrdersTableOrderingComposer get orderId {
    final $$OfflineOrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.offlineOrders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OfflineOrdersTableOrderingComposer(
              $db: $db,
              $table: $db.offlineOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OfflineOrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineOrderItemsTable> {
  $$OfflineOrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  $$OfflineOrdersTableAnnotationComposer get orderId {
    final $$OfflineOrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.offlineOrders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OfflineOrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.offlineOrders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OfflineOrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OfflineOrderItemsTable,
    OfflineOrderItem,
    $$OfflineOrderItemsTableFilterComposer,
    $$OfflineOrderItemsTableOrderingComposer,
    $$OfflineOrderItemsTableAnnotationComposer,
    $$OfflineOrderItemsTableCreateCompanionBuilder,
    $$OfflineOrderItemsTableUpdateCompanionBuilder,
    (OfflineOrderItem, $$OfflineOrderItemsTableReferences),
    OfflineOrderItem,
    PrefetchHooks Function({bool orderId})> {
  $$OfflineOrderItemsTableTableManager(
      _$AppDatabase db, $OfflineOrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineOrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineOrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineOrderItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
          }) =>
              OfflineOrderItemsCompanion(
            id: id,
            orderId: orderId,
            productId: productId,
            quantity: quantity,
            unitPrice: unitPrice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int productId,
            required int quantity,
            required double unitPrice,
          }) =>
              OfflineOrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            productId: productId,
            quantity: quantity,
            unitPrice: unitPrice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OfflineOrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OfflineOrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OfflineOrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OfflineOrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OfflineOrderItemsTable,
    OfflineOrderItem,
    $$OfflineOrderItemsTableFilterComposer,
    $$OfflineOrderItemsTableOrderingComposer,
    $$OfflineOrderItemsTableAnnotationComposer,
    $$OfflineOrderItemsTableCreateCompanionBuilder,
    $$OfflineOrderItemsTableUpdateCompanionBuilder,
    (OfflineOrderItem, $$OfflineOrderItemsTableReferences),
    OfflineOrderItem,
    PrefetchHooks Function({bool orderId})>;
typedef $$CurrenciesConfigTableCreateCompanionBuilder
    = CurrenciesConfigCompanion Function({
  Value<int> id,
  Value<int?> accountingId,
  required String baseCurrencyName,
  required String baseCurrencySymbol,
  Value<String?> varCurrencyName,
  Value<String?> varCurrencySymbol,
  Value<double?> exchangeRate,
  Value<bool> isActive,
  Value<DateTime?> lastUpdated,
  Value<DateTime?> syncedAt,
});
typedef $$CurrenciesConfigTableUpdateCompanionBuilder
    = CurrenciesConfigCompanion Function({
  Value<int> id,
  Value<int?> accountingId,
  Value<String> baseCurrencyName,
  Value<String> baseCurrencySymbol,
  Value<String?> varCurrencyName,
  Value<String?> varCurrencySymbol,
  Value<double?> exchangeRate,
  Value<bool> isActive,
  Value<DateTime?> lastUpdated,
  Value<DateTime?> syncedAt,
});

class $$CurrenciesConfigTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesConfigTable> {
  $$CurrenciesConfigTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get accountingId => $composableBuilder(
      column: $table.accountingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrencyName => $composableBuilder(
      column: $table.baseCurrencyName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrencySymbol => $composableBuilder(
      column: $table.baseCurrencySymbol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get varCurrencyName => $composableBuilder(
      column: $table.varCurrencyName,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get varCurrencySymbol => $composableBuilder(
      column: $table.varCurrencySymbol,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CurrenciesConfigTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesConfigTable> {
  $$CurrenciesConfigTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get accountingId => $composableBuilder(
      column: $table.accountingId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrencyName => $composableBuilder(
      column: $table.baseCurrencyName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrencySymbol => $composableBuilder(
      column: $table.baseCurrencySymbol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get varCurrencyName => $composableBuilder(
      column: $table.varCurrencyName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get varCurrencySymbol => $composableBuilder(
      column: $table.varCurrencySymbol,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesConfigTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesConfigTable> {
  $$CurrenciesConfigTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get accountingId => $composableBuilder(
      column: $table.accountingId, builder: (column) => column);

  GeneratedColumn<String> get baseCurrencyName => $composableBuilder(
      column: $table.baseCurrencyName, builder: (column) => column);

  GeneratedColumn<String> get baseCurrencySymbol => $composableBuilder(
      column: $table.baseCurrencySymbol, builder: (column) => column);

  GeneratedColumn<String> get varCurrencyName => $composableBuilder(
      column: $table.varCurrencyName, builder: (column) => column);

  GeneratedColumn<String> get varCurrencySymbol => $composableBuilder(
      column: $table.varCurrencySymbol, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
      column: $table.exchangeRate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
      column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CurrenciesConfigTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesConfigTable,
    LocalCurrencyConfig,
    $$CurrenciesConfigTableFilterComposer,
    $$CurrenciesConfigTableOrderingComposer,
    $$CurrenciesConfigTableAnnotationComposer,
    $$CurrenciesConfigTableCreateCompanionBuilder,
    $$CurrenciesConfigTableUpdateCompanionBuilder,
    (
      LocalCurrencyConfig,
      BaseReferences<_$AppDatabase, $CurrenciesConfigTable, LocalCurrencyConfig>
    ),
    LocalCurrencyConfig,
    PrefetchHooks Function()> {
  $$CurrenciesConfigTableTableManager(
      _$AppDatabase db, $CurrenciesConfigTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesConfigTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesConfigTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesConfigTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> accountingId = const Value.absent(),
            Value<String> baseCurrencyName = const Value.absent(),
            Value<String> baseCurrencySymbol = const Value.absent(),
            Value<String?> varCurrencyName = const Value.absent(),
            Value<String?> varCurrencySymbol = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastUpdated = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              CurrenciesConfigCompanion(
            id: id,
            accountingId: accountingId,
            baseCurrencyName: baseCurrencyName,
            baseCurrencySymbol: baseCurrencySymbol,
            varCurrencyName: varCurrencyName,
            varCurrencySymbol: varCurrencySymbol,
            exchangeRate: exchangeRate,
            isActive: isActive,
            lastUpdated: lastUpdated,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> accountingId = const Value.absent(),
            required String baseCurrencyName,
            required String baseCurrencySymbol,
            Value<String?> varCurrencyName = const Value.absent(),
            Value<String?> varCurrencySymbol = const Value.absent(),
            Value<double?> exchangeRate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastUpdated = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              CurrenciesConfigCompanion.insert(
            id: id,
            accountingId: accountingId,
            baseCurrencyName: baseCurrencyName,
            baseCurrencySymbol: baseCurrencySymbol,
            varCurrencyName: varCurrencyName,
            varCurrencySymbol: varCurrencySymbol,
            exchangeRate: exchangeRate,
            isActive: isActive,
            lastUpdated: lastUpdated,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CurrenciesConfigTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesConfigTable,
    LocalCurrencyConfig,
    $$CurrenciesConfigTableFilterComposer,
    $$CurrenciesConfigTableOrderingComposer,
    $$CurrenciesConfigTableAnnotationComposer,
    $$CurrenciesConfigTableCreateCompanionBuilder,
    $$CurrenciesConfigTableUpdateCompanionBuilder,
    (
      LocalCurrencyConfig,
      BaseReferences<_$AppDatabase, $CurrenciesConfigTable, LocalCurrencyConfig>
    ),
    LocalCurrencyConfig,
    PrefetchHooks Function()>;
typedef $$BatchUnitPricesTableCreateCompanionBuilder = BatchUnitPricesCompanion
    Function({
  Value<int> id,
  required int batchId,
  required int unitId,
  required double sellingPrice,
});
typedef $$BatchUnitPricesTableUpdateCompanionBuilder = BatchUnitPricesCompanion
    Function({
  Value<int> id,
  Value<int> batchId,
  Value<int> unitId,
  Value<double> sellingPrice,
});

class $$BatchUnitPricesTableFilterComposer
    extends Composer<_$AppDatabase, $BatchUnitPricesTable> {
  $$BatchUnitPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));
}

class $$BatchUnitPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchUnitPricesTable> {
  $$BatchUnitPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get batchId => $composableBuilder(
      column: $table.batchId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));
}

class $$BatchUnitPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchUnitPricesTable> {
  $$BatchUnitPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get batchId =>
      $composableBuilder(column: $table.batchId, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);
}

class $$BatchUnitPricesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BatchUnitPricesTable,
    LocalBatchUnitPrice,
    $$BatchUnitPricesTableFilterComposer,
    $$BatchUnitPricesTableOrderingComposer,
    $$BatchUnitPricesTableAnnotationComposer,
    $$BatchUnitPricesTableCreateCompanionBuilder,
    $$BatchUnitPricesTableUpdateCompanionBuilder,
    (
      LocalBatchUnitPrice,
      BaseReferences<_$AppDatabase, $BatchUnitPricesTable, LocalBatchUnitPrice>
    ),
    LocalBatchUnitPrice,
    PrefetchHooks Function()> {
  $$BatchUnitPricesTableTableManager(
      _$AppDatabase db, $BatchUnitPricesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchUnitPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchUnitPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchUnitPricesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> batchId = const Value.absent(),
            Value<int> unitId = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
          }) =>
              BatchUnitPricesCompanion(
            id: id,
            batchId: batchId,
            unitId: unitId,
            sellingPrice: sellingPrice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int batchId,
            required int unitId,
            required double sellingPrice,
          }) =>
              BatchUnitPricesCompanion.insert(
            id: id,
            batchId: batchId,
            unitId: unitId,
            sellingPrice: sellingPrice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BatchUnitPricesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BatchUnitPricesTable,
    LocalBatchUnitPrice,
    $$BatchUnitPricesTableFilterComposer,
    $$BatchUnitPricesTableOrderingComposer,
    $$BatchUnitPricesTableAnnotationComposer,
    $$BatchUnitPricesTableCreateCompanionBuilder,
    $$BatchUnitPricesTableUpdateCompanionBuilder,
    (
      LocalBatchUnitPrice,
      BaseReferences<_$AppDatabase, $BatchUnitPricesTable, LocalBatchUnitPrice>
    ),
    LocalBatchUnitPrice,
    PrefetchHooks Function()>;
typedef $$ProductUnitPricesTableCreateCompanionBuilder
    = ProductUnitPricesCompanion Function({
  Value<int> id,
  required int productId,
  required int unitId,
  required double sellingPrice,
  required double conversionToBase,
});
typedef $$ProductUnitPricesTableUpdateCompanionBuilder
    = ProductUnitPricesCompanion Function({
  Value<int> id,
  Value<int> productId,
  Value<int> unitId,
  Value<double> sellingPrice,
  Value<double> conversionToBase,
});

class $$ProductUnitPricesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUnitPricesTable> {
  $$ProductUnitPricesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get conversionToBase => $composableBuilder(
      column: $table.conversionToBase,
      builder: (column) => ColumnFilters(column));
}

class $$ProductUnitPricesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUnitPricesTable> {
  $$ProductUnitPricesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitId => $composableBuilder(
      column: $table.unitId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get conversionToBase => $composableBuilder(
      column: $table.conversionToBase,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductUnitPricesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUnitPricesTable> {
  $$ProductUnitPricesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get unitId =>
      $composableBuilder(column: $table.unitId, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);

  GeneratedColumn<double> get conversionToBase => $composableBuilder(
      column: $table.conversionToBase, builder: (column) => column);
}

class $$ProductUnitPricesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductUnitPricesTable,
    LocalProductUnitPrice,
    $$ProductUnitPricesTableFilterComposer,
    $$ProductUnitPricesTableOrderingComposer,
    $$ProductUnitPricesTableAnnotationComposer,
    $$ProductUnitPricesTableCreateCompanionBuilder,
    $$ProductUnitPricesTableUpdateCompanionBuilder,
    (
      LocalProductUnitPrice,
      BaseReferences<_$AppDatabase, $ProductUnitPricesTable,
          LocalProductUnitPrice>
    ),
    LocalProductUnitPrice,
    PrefetchHooks Function()> {
  $$ProductUnitPricesTableTableManager(
      _$AppDatabase db, $ProductUnitPricesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUnitPricesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUnitPricesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUnitPricesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<int> unitId = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
            Value<double> conversionToBase = const Value.absent(),
          }) =>
              ProductUnitPricesCompanion(
            id: id,
            productId: productId,
            unitId: unitId,
            sellingPrice: sellingPrice,
            conversionToBase: conversionToBase,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            required int unitId,
            required double sellingPrice,
            required double conversionToBase,
          }) =>
              ProductUnitPricesCompanion.insert(
            id: id,
            productId: productId,
            unitId: unitId,
            sellingPrice: sellingPrice,
            conversionToBase: conversionToBase,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductUnitPricesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductUnitPricesTable,
    LocalProductUnitPrice,
    $$ProductUnitPricesTableFilterComposer,
    $$ProductUnitPricesTableOrderingComposer,
    $$ProductUnitPricesTableAnnotationComposer,
    $$ProductUnitPricesTableCreateCompanionBuilder,
    $$ProductUnitPricesTableUpdateCompanionBuilder,
    (
      LocalProductUnitPrice,
      BaseReferences<_$AppDatabase, $ProductUnitPricesTable,
          LocalProductUnitPrice>
    ),
    LocalProductUnitPrice,
    PrefetchHooks Function()>;
typedef $$ProductBatchesTableCreateCompanionBuilder = ProductBatchesCompanion
    Function({
  Value<int> id,
  required int productId,
  required String batchNumber,
  required double sellingPrice,
});
typedef $$ProductBatchesTableUpdateCompanionBuilder = ProductBatchesCompanion
    Function({
  Value<int> id,
  Value<int> productId,
  Value<String> batchNumber,
  Value<double> sellingPrice,
});

class $$ProductBatchesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => ColumnFilters(column));
}

class $$ProductBatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductBatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductBatchesTable> {
  $$ProductBatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
      column: $table.batchNumber, builder: (column) => column);

  GeneratedColumn<double> get sellingPrice => $composableBuilder(
      column: $table.sellingPrice, builder: (column) => column);
}

class $$ProductBatchesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductBatchesTable,
    LocalProductBatch,
    $$ProductBatchesTableFilterComposer,
    $$ProductBatchesTableOrderingComposer,
    $$ProductBatchesTableAnnotationComposer,
    $$ProductBatchesTableCreateCompanionBuilder,
    $$ProductBatchesTableUpdateCompanionBuilder,
    (
      LocalProductBatch,
      BaseReferences<_$AppDatabase, $ProductBatchesTable, LocalProductBatch>
    ),
    LocalProductBatch,
    PrefetchHooks Function()> {
  $$ProductBatchesTableTableManager(
      _$AppDatabase db, $ProductBatchesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductBatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductBatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductBatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> productId = const Value.absent(),
            Value<String> batchNumber = const Value.absent(),
            Value<double> sellingPrice = const Value.absent(),
          }) =>
              ProductBatchesCompanion(
            id: id,
            productId: productId,
            batchNumber: batchNumber,
            sellingPrice: sellingPrice,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int productId,
            required String batchNumber,
            required double sellingPrice,
          }) =>
              ProductBatchesCompanion.insert(
            id: id,
            productId: productId,
            batchNumber: batchNumber,
            sellingPrice: sellingPrice,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductBatchesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductBatchesTable,
    LocalProductBatch,
    $$ProductBatchesTableFilterComposer,
    $$ProductBatchesTableOrderingComposer,
    $$ProductBatchesTableAnnotationComposer,
    $$ProductBatchesTableCreateCompanionBuilder,
    $$ProductBatchesTableUpdateCompanionBuilder,
    (
      LocalProductBatch,
      BaseReferences<_$AppDatabase, $ProductBatchesTable, LocalProductBatch>
    ),
    LocalProductBatch,
    PrefetchHooks Function()>;
typedef $$LedgerEntriesTableCreateCompanionBuilder = LedgerEntriesCompanion
    Function({
  Value<int> id,
  required String operationType,
  Value<String?> description,
  required double debit,
  required double credit,
  required double balanceAfter,
  Value<String?> documentNumber,
  required DateTime createdAt,
  Value<int> sortIndex,
  Value<DateTime?> syncedAt,
});
typedef $$LedgerEntriesTableUpdateCompanionBuilder = LedgerEntriesCompanion
    Function({
  Value<int> id,
  Value<String> operationType,
  Value<String?> description,
  Value<double> debit,
  Value<double> credit,
  Value<double> balanceAfter,
  Value<String?> documentNumber,
  Value<DateTime> createdAt,
  Value<int> sortIndex,
  Value<DateTime?> syncedAt,
});

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortIndex => $composableBuilder(
      column: $table.sortIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get debit => $composableBuilder(
      column: $table.debit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get credit => $composableBuilder(
      column: $table.credit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortIndex => $composableBuilder(
      column: $table.sortIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<double> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<double> get balanceAfter => $composableBuilder(
      column: $table.balanceAfter, builder: (column) => column);

  GeneratedColumn<String> get documentNumber => $composableBuilder(
      column: $table.documentNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$LedgerEntriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LocalLedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (
      LocalLedgerEntry,
      BaseReferences<_$AppDatabase, $LedgerEntriesTable, LocalLedgerEntry>
    ),
    LocalLedgerEntry,
    PrefetchHooks Function()> {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> debit = const Value.absent(),
            Value<double> credit = const Value.absent(),
            Value<double> balanceAfter = const Value.absent(),
            Value<String?> documentNumber = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> sortIndex = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              LedgerEntriesCompanion(
            id: id,
            operationType: operationType,
            description: description,
            debit: debit,
            credit: credit,
            balanceAfter: balanceAfter,
            documentNumber: documentNumber,
            createdAt: createdAt,
            sortIndex: sortIndex,
            syncedAt: syncedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String operationType,
            Value<String?> description = const Value.absent(),
            required double debit,
            required double credit,
            required double balanceAfter,
            Value<String?> documentNumber = const Value.absent(),
            required DateTime createdAt,
            Value<int> sortIndex = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
          }) =>
              LedgerEntriesCompanion.insert(
            id: id,
            operationType: operationType,
            description: description,
            debit: debit,
            credit: credit,
            balanceAfter: balanceAfter,
            documentNumber: documentNumber,
            createdAt: createdAt,
            sortIndex: sortIndex,
            syncedAt: syncedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$LedgerEntriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $LedgerEntriesTable,
    LocalLedgerEntry,
    $$LedgerEntriesTableFilterComposer,
    $$LedgerEntriesTableOrderingComposer,
    $$LedgerEntriesTableAnnotationComposer,
    $$LedgerEntriesTableCreateCompanionBuilder,
    $$LedgerEntriesTableUpdateCompanionBuilder,
    (
      LocalLedgerEntry,
      BaseReferences<_$AppDatabase, $LedgerEntriesTable, LocalLedgerEntry>
    ),
    LocalLedgerEntry,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductCategoriesTableTableManager get productCategories =>
      $$ProductCategoriesTableTableManager(_db, _db.productCategories);
  $$OfflineOrdersTableTableManager get offlineOrders =>
      $$OfflineOrdersTableTableManager(_db, _db.offlineOrders);
  $$OfflineOrderItemsTableTableManager get offlineOrderItems =>
      $$OfflineOrderItemsTableTableManager(_db, _db.offlineOrderItems);
  $$CurrenciesConfigTableTableManager get currenciesConfig =>
      $$CurrenciesConfigTableTableManager(_db, _db.currenciesConfig);
  $$BatchUnitPricesTableTableManager get batchUnitPrices =>
      $$BatchUnitPricesTableTableManager(_db, _db.batchUnitPrices);
  $$ProductUnitPricesTableTableManager get productUnitPrices =>
      $$ProductUnitPricesTableTableManager(_db, _db.productUnitPrices);
  $$ProductBatchesTableTableManager get productBatches =>
      $$ProductBatchesTableTableManager(_db, _db.productBatches);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
}
