// lib/models/product.dart
import 'dart:convert';

bool _asBool(dynamic value) {
  if (value == true) return true;
  if (value == false || value == null) return false;
  if (value is num) return value != 0;
  final normalized = value.toString().trim().toLowerCase();
  return normalized == 'true' || normalized == '1' || normalized == 'yes';
}

double _asDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) {
    return value.isFinite ? value.toDouble() : 0;
  }
  var text = value.toString().trim();
  if (text.isEmpty) return 0;
  text = text
      .replaceAll('٬', '')
      .replaceAll('،', '')
      .replaceAll(',', '')
      .replaceAll(' ', '');
  return double.tryParse(text) ?? 0;
}

int? _asIntOrNull(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim());
}

String? _asNonEmpty(dynamic value, {bool allowNumeric = false}) {
  if (value == null) return null;
  final text = value.toString().trim();
  if (text.isEmpty) return null;
  final lower = text.toLowerCase();
  if (lower == 'null' || lower == 'undefined') return null;
  if (!allowNumeric && int.tryParse(text) != null) return null;
  return text;
}

dynamic _firstValue(Map<String, dynamic> json, List<String> keys) {
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value != null) return value;
  }
  return null;
}

dynamic _displayValue(Map<String, dynamic> json, List<String> keys) {
  dynamic fallback;
  for (final key in keys) {
    if (!json.containsKey(key)) continue;
    final value = json[key];
    if (value == null) continue;
    fallback ??= value;
    final text = value.toString().trim();
    if (text.isEmpty) continue;
    if (_looksScientific(text)) continue;
    return value;
  }
  return fallback;
}

bool _looksScientific(String text) {
  return RegExp(r'[-+]?\d*\.?\d+e[-+]?\d+', caseSensitive: false).hasMatch(text);
}

List<Map<String, dynamic>> _asMaps(dynamic raw) {
  if (raw is! List) return const [];
  return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
}

List<Map<String, dynamic>> _asUnitMaps(Map<String, dynamic> json) {
  return [
    ..._asMaps(json['units']),
    ..._asMaps(json['unit_prices']),
    ..._asMaps(json['product_units']),
    ..._asMaps(json['product_unit_prices']),
    ..._asMaps(json['unitPrices']),
    ..._asMaps(json['productUnits']),
    ..._asMaps(json['productUnitPrices']),
  ];
}

bool _isActiveUnit(Map<String, dynamic> unit) {
  if (!unit.containsKey('is_active') && !unit.containsKey('isActive')) {
    return true;
  }
  return _asBool(unit['is_active'] ?? unit['isActive']);
}

int? _unitRowId(Map<String, dynamic> unit) {
  return _asIntOrNull(unit['id']) ??
      _asIntOrNull(unit['unitId']) ??
      _asIntOrNull(unit['unit_id']);
}

String? _unitRowName(Map<String, dynamic> unit) {
  return _asNonEmpty(unit['unit_name']) ??
      _asNonEmpty(unit['unitName']) ??
      _asNonEmpty(unit['name']) ??
      _asNonEmpty(unit['symbol']) ??
      _asNonEmpty(unit['unit_symbol']) ??
      _asNonEmpty(unit['unitSymbol']);
}

bool _isProductBasePriceRow(Map<String, dynamic> unit, int? baseUnitId) {
  if (unit.containsKey('is_base_unit_price') ||
      unit.containsKey('isBaseUnitPrice')) {
    return _asBool(unit['is_base_unit_price'] ?? unit['isBaseUnitPrice']);
  }
  if (unit.containsKey('is_base_unit') || unit.containsKey('isBaseUnit')) {
    return _asBool(unit['is_base_unit'] ?? unit['isBaseUnit']);
  }
  if (unit.containsKey('is_base') || unit.containsKey('isBase')) {
    return _asBool(unit['is_base'] ?? unit['isBase']);
  }
  final unitId = _unitRowId(unit);
  return baseUnitId != null && unitId != null && unitId == baseUnitId;
}

int? _baseUnitIdFromJson(Map<String, dynamic> json) {
  final direct = _asIntOrNull(
    _firstValue(json, ['base_unit_id', 'baseUnitId']),
  );
  if (direct != null) return direct;

  final nested = json['base_unit'] ?? json['baseUnit'];
  if (nested is Map) {
    return _asIntOrNull(nested['id']);
  }
  return null;
}

String? _baseUnitNameFromJson(Map<String, dynamic> json, int? baseUnitId) {
  final nested = json['base_unit'] ?? json['baseUnit'];
  if (nested is Map) {
    final nestedName = _asNonEmpty(nested['name']) ??
        _asNonEmpty(nested['symbol']) ??
        _asNonEmpty(nested['unit_name']) ??
        _asNonEmpty(nested['unitName']);
    if (nestedName != null) return nestedName;
  } else if (nested is String) {
    final nestedName = _asNonEmpty(nested);
    if (nestedName != null) return nestedName;
  }

  final joinedName = _asNonEmpty(
    _firstValue(json, [
      'base_unit_name',
      'baseUnitName',
      'unit_name',
      'unitName',
      'base_uom_name',
      'uom_name',
      'unit_title',
      'base_unit_title',
    ]),
  );
  if (joinedName != null) return joinedName;

  if (baseUnitId != null) {
    for (final unit in _asUnitMaps(json)) {
      if (_unitRowId(unit) == baseUnitId) {
        final name = _unitRowName(unit);
        if (name != null) return name;
      }
    }
  }

  for (final unit in _asUnitMaps(json)) {
    if (_isActiveUnit(unit) && _isProductBasePriceRow(unit, baseUnitId)) {
      final name = _unitRowName(unit);
      if (name != null) return name;
    }
  }

  return null;
}

const Map<int, String> kDefaultUnitNamesById = {
  1: 'بکس',
  2: 'عدد',
  3: 'کیلو',
  4: 'کارتن',
  5: 'پاکت',
  6: 'ورق',
  7: 'دانه',
};

String? unitNameForId(int? unitId) {
  if (unitId == null) return null;
  return kDefaultUnitNamesById[unitId];
}

String? resolveStoredBaseUnitName(String? rawName, int? baseUnitId) {
  final unit = rawName?.trim();
  if (unit != null && unit.isNotEmpty && unit != 'عدد') {
    return unit;
  }
  final known = unitNameForId(baseUnitId);
  if (known != null) return known;
  if (unit != null && unit.isNotEmpty) return unit;
  return null;
}

bool _hasAtLeastOneExtraUnit(Map<String, dynamic> json, int? baseUnitId) {
  for (final key in [
    'extra_units_count',
    'extra_unit_count',
    'non_base_units_count',
    'extraUnitsCount',
    'extraUnitCount',
    'nonBaseUnitsCount',
  ]) {
    final count = json[key];
    if (count is num && count >= 1) return true;
  }

  final unitsCount = json['units_count'] ?? json['unitsCount'];
  if (unitsCount is num && unitsCount >= 2) return true;

  final units = _asUnitMaps(json);
  if (units.isNotEmpty) {
    var extra = 0;
    for (final unit in units) {
      if (!_isActiveUnit(unit)) continue;
      if (_isProductBasePriceRow(unit, baseUnitId)) continue;
      extra++;
    }
    if (extra >= 1) return true;
  }

  return _asBool(
    json['has_multi_units'] ?? json['hasMultiUnits'],
  );
}

String? _sanitizedPriceLabel(dynamic raw) {
  final label = _asNonEmpty(raw, allowNumeric: true);
  if (label == null) return null;
  if (_looksScientific(label)) return null;
  return label;
}

Map<String, dynamic>? _asStringKeyedMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) {
    return Map<String, dynamic>.from(raw);
  }
  return null;
}

String? parseProductDescription(Map<String, dynamic> json) {
  final raw = _firstValue(json, [
    'description',
    'desc',
    'product_description',
    'productDescription',
    'details',
    'note',
    'notes',
  ]);
  if (raw == null) return null;
  if (raw is Map) {
    final nested = _firstValue(Map<String, dynamic>.from(raw), [
      'text',
      'value',
      'content',
      'fa',
      'name',
    ]);
    return _asNonEmpty(nested, allowNumeric: true);
  }
  return _asNonEmpty(raw, allowNumeric: true);
}

Map<String, dynamic>? parseExtraAttributes(Map<String, dynamic> json) {
  dynamic raw = _firstValue(json, [
    'extra_attributes',
    'extraAttributes',
    'attributes',
    'specs',
    'extra_attrs',
    'extraAttrs',
  ]);

  if (raw is String && raw.trim().isNotEmpty) {
    try {
      raw = jsonDecode(raw);
    } catch (_) {}
  }

  final map = <String, dynamic>{};

  if (raw is Map) {
    map.addAll(Map<String, dynamic>.from(raw));
  } else if (raw is List) {
    for (final item in raw) {
      if (item is! Map) {
        final text = _asNonEmpty(item, allowNumeric: true);
        if (text != null) {
          map[text] = text;
        }
        continue;
      }
      final row = Map<String, dynamic>.from(item);
      final label = _asNonEmpty(
        _firstValue(row, ['label', 'name', 'key', 'title']),
        allowNumeric: true,
      );
      final value = row['value'] ?? row['text'] ?? row['content'];
      if (label != null && value != null) {
        map[label] = value;
      }
    }
    if (map.isEmpty) {
      map['items'] = raw;
    }
  }

  for (final key in ['brand', 'color', 'model', 'برند', 'رنگ', 'مدل']) {
    final current = map[key];
    final empty = current == null || current.toString().trim().isEmpty;
    if (empty &&
        json[key] != null &&
        json[key].toString().trim().isNotEmpty) {
      map[key] = json[key];
    }
  }

  return map.isEmpty ? null : map;
}

class Product {
  final int id;
  final String name;
  final String? code;
  final String? barcode;
  final double sellingPrice;
  final String? description;
  final String? imagePath;
  final bool isActive;
  final int? categoryId;
  final String? categoryName;
  final int? baseUnitId;
  final bool hasMultiUnits;
  final bool hasBatches;
  final bool hasLogistics;
  final String? priceLabel;
  final String? baseUnitName;
  final Map<String, dynamic>? extraAttributes;

  const Product({
    required this.id,
    required this.name,
    this.code,
    this.barcode,
    required this.sellingPrice,
    this.description,
    this.imagePath,
    required this.isActive,
    this.categoryId,
    this.categoryName,
    this.baseUnitId,
    this.hasMultiUnits = false,
    this.hasBatches = false,
    this.hasLogistics = false,
    this.priceLabel,
    this.baseUnitName,
    this.extraAttributes,
  });

  bool get needsOptions => hasMultiUnits || hasBatches;

  String get resolvedBaseUnitName {
    return resolveStoredBaseUnitName(baseUnitName, baseUnitId) ?? '';
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final baseUnitId = _baseUnitIdFromJson(json);

    // دیباگ موقت - بعد از حل مشکل حذف کنید
    print(
      'FROMJSON id=${json['id']} keys=${json.keys.toList()} '
      'desc=${json['description']} extra=${json['extra_attributes']}',
    );

    return Product(
      id: _asIntOrNull(json['id']) ?? 0,
      name: _asNonEmpty(json['name'], allowNumeric: true) ?? 'بدون نام',
      code: json['code']?.toString(),
      barcode: json['barcode']?.toString(),
      sellingPrice: _asDouble(
        _displayValue(json, [
          'selling_price',
          'display_price',
          'price',
          'sellingPrice',
          'displayPrice',
        ]),
      ),
      description: parseProductDescription(json),
      imagePath: _firstValue(json, ['image_path', 'imagePath'])?.toString(),
      isActive: _asBool(json['is_active'] ?? json['isActive'] ?? true),
      categoryId: _asIntOrNull(
        _firstValue(json, ['category_id', 'categoryId']),
      ),
      categoryName: _asNonEmpty(
        _firstValue(json, ['category_name', 'categoryName']),
        allowNumeric: true,
      ),
      baseUnitId: baseUnitId,
      hasMultiUnits: _hasAtLeastOneExtraUnit(json, baseUnitId),
      hasBatches: _asBool(json['has_batches'] ?? json['hasBatches']),
      hasLogistics: _asBool(json['has_logistics'] ?? json['hasLogistics']),
      priceLabel: _sanitizedPriceLabel(
        _firstValue(json, ['price_label', 'priceLabel']),
      ),
      baseUnitName: resolveStoredBaseUnitName(
        _baseUnitNameFromJson(json, baseUnitId),
        baseUnitId,
      ),
      extraAttributes: parseExtraAttributes(json),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'barcode': barcode,
      'selling_price': sellingPrice,
      'description': description,
      'image_path': imagePath,
      'is_active': isActive,
      'category_id': categoryId,
      'category_name': categoryName,
      'base_unit_id': baseUnitId,
      'has_multi_units': hasMultiUnits,
      'has_batches': hasBatches,
      'has_logistics': hasLogistics,
      'price_label': priceLabel,
      'base_unit_name': baseUnitName,
      'unit_name': baseUnitName,
      'extra_attributes': extraAttributes,
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? code,
    String? barcode,
    double? sellingPrice,
    String? description,
    String? imagePath,
    bool? isActive,
    int? categoryId,
    String? categoryName,
    int? baseUnitId,
    bool? hasMultiUnits,
    bool? hasBatches,
    bool? hasLogistics,
    String? priceLabel,
    String? baseUnitName,
    Map<String, dynamic>? extraAttributes,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      baseUnitId: baseUnitId ?? this.baseUnitId,
      hasMultiUnits: hasMultiUnits ?? this.hasMultiUnits,
      hasBatches: hasBatches ?? this.hasBatches,
      hasLogistics: hasLogistics ?? this.hasLogistics,
      priceLabel: priceLabel ?? this.priceLabel,
      baseUnitName: baseUnitName ?? this.baseUnitName,
      extraAttributes: extraAttributes ?? this.extraAttributes,
    );
  }
}
