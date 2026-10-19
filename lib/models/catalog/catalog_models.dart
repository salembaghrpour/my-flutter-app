// lib/models/catalog/catalog_models.dart

double _asDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _asInt(dynamic value, [int fallback = 0]) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? fallback;
}

class ProductCategory {
  final int id;
  final String name;
  final int? parentId;
  final List<ProductCategory> children;

  ProductCategory({
    required this.id,
    required this.name,
    this.parentId,
    this.children = const [],
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List? ?? const [];
    return ProductCategory(
      id: _asInt(json['id']),
      name: json['name']?.toString() ?? '',
      parentId: json['parent_id'] == null ? null : _asInt(json['parent_id']),
      children: rawChildren
          .map((e) => ProductCategory.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

List<ProductCategory> flattenCategories(List<ProductCategory> roots) {
  final out = <ProductCategory>[];
  void walk(ProductCategory node) {
    out.add(node);
    for (final child in node.children) {
      walk(child);
    }
  }

  for (final root in roots) {
    walk(root);
  }
  return out;
}

class ProductUnit {
  final int unitId;
  final String unitName;
  final double sellingPrice;
  final double conversionToBase;
  final bool allowDecimalQty;
  final double qtyStep;
  final double minOrderQty;
  final bool isDefaultForSale;
  final bool isBaseUnitPrice;

  ProductUnit({
    required this.unitId,
    required this.unitName,
    required this.sellingPrice,
    this.conversionToBase = 1,
    this.allowDecimalQty = true,
    this.qtyStep = 1,
    this.minOrderQty = 1,
    this.isDefaultForSale = false,
    this.isBaseUnitPrice = false,
  });

  factory ProductUnit.fromJson(Map<String, dynamic> json) {
    return ProductUnit(
      unitId: _asInt(json['unit_id'] ?? json['id']),
      unitName: json['unit_name']?.toString() ??
          json['name']?.toString() ??
          'عدد',
      sellingPrice: _asDouble(json['selling_price'] ?? json['price']),
      conversionToBase: _asDouble(json['conversion_to_base'] ?? 1),
      allowDecimalQty: json['allow_decimal_qty'] ?? true,
      qtyStep: _asDouble(json['qty_step'] ?? 1),
      minOrderQty: _asDouble(json['min_order_qty'] ?? 1),
      isDefaultForSale: json['is_default_for_sale'] ?? false,
      isBaseUnitPrice: json['is_base_unit_price'] ?? false,
    );
  }
}

class ProductBatch {
  final int id;
  final String batchNumber;
  final String? expirationDate;
  final double sellingPrice;

  ProductBatch({
    required this.id,
    required this.batchNumber,
    this.expirationDate,
    required this.sellingPrice,
  });

  factory ProductBatch.fromJson(Map<String, dynamic> json) {
    return ProductBatch(
      id: _asInt(json['id']),
      batchNumber: json['batch_number']?.toString() ?? '',
      expirationDate: json['expiration_date']?.toString(),
      sellingPrice:
          _asDouble(json['selling_price'] ?? json['base_selling_price']),
    );
  }
}

class ProductDetail {
  final int id;
  final String name;
  final String? imagePath;
  final bool hasBatches;
  final bool hasMultiUnits;
  final List<ProductUnit> units;
  final List<ProductBatch> batches;

  ProductDetail({
    required this.id,
    required this.name,
    this.imagePath,
    required this.hasBatches,
    required this.hasMultiUnits,
    required this.units,
    required this.batches,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final src = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'])
        : json;
    final rawUnits = src['units'] as List? ?? const [];
    final rawBatches = src['batches'] as List? ?? const [];
    return ProductDetail(
      id: _asInt(src['id']),
      name: src['name']?.toString() ?? '',
      imagePath: src['image_path']?.toString(),
      hasBatches: src['has_batches'] ?? rawBatches.isNotEmpty,
      hasMultiUnits: src['has_multi_units'] ?? rawUnits.length > 1,
      units: rawUnits
          .map((e) => ProductUnit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      batches: rawBatches
          .map((e) => ProductBatch.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  ProductUnit? get defaultUnit {
    for (final unit in units) {
      if (unit.isDefaultForSale) return unit;
    }
    for (final unit in units) {
      if (unit.isBaseUnitPrice) return unit;
    }
    return units.isEmpty ? null : units.first;
  }
}
