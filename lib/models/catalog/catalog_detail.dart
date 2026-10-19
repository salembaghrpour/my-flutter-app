// lib/models/catalog/catalog_detail.dart

// 1. اضافه شدن کلاس BatchUnitPrice که فراموش شده بود
class BatchUnitPrice {
  final int unitId;
  final double sellingPrice;

  BatchUnitPrice({required this.unitId, required this.sellingPrice});

  factory BatchUnitPrice.fromJson(Map<String, dynamic> json) {
    return BatchUnitPrice(
      unitId: (json['unit_id'] as num?)?.toInt() ?? 0,
      sellingPrice: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CatalogUnit {
  final int unitId;
  final String unitName;
  final double sellingPrice;
  final double conversionToBase;
  final bool allowDecimalQty;
  final double qtyStep;
  final double minOrderQty;
  final bool isDefaultForSale;

  CatalogUnit({
    required this.unitId,
    required this.unitName,
    required this.sellingPrice,
    required this.conversionToBase,
    required this.allowDecimalQty,
    required this.qtyStep,
    required this.minOrderQty,
    required this.isDefaultForSale,
  });

  factory CatalogUnit.fromJson(Map<String, dynamic> json) {
    return CatalogUnit(
      unitId: (json['unit_id'] ?? json['id'] as num).toInt(),
      unitName: (json['unit_name'] ?? json['name'] ?? 'عدد').toString(),
      sellingPrice:
          (json['selling_price'] ?? json['display_price'] ?? 0).toDouble(),
      conversionToBase: (json['conversion_to_base'] ?? 1).toDouble(),
      allowDecimalQty: json['allow_decimal_qty'] ?? true,
      qtyStep: (json['qty_step'] ?? 1).toDouble(),
      minOrderQty: (json['min_order_qty'] ?? 1).toDouble(),
      isDefaultForSale: json['is_default_for_sale'] == true ||
          json['is_base_unit_price'] == true,
    );
  }
}

class CatalogBatch {
  final int id;
  final String batchNumber;
  final String? expirationDate;
  final double? baseSellingPrice;
  final List<BatchUnitPrice>? unitPrices; // اضافه شدن لیست قیمت‌های بچ-واحد

  CatalogBatch({
    required this.id,
    required this.batchNumber,
    this.expirationDate,
    this.baseSellingPrice,
    this.unitPrices, // اضافه شدن به سازنده
  });

  factory CatalogBatch.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['selling_price'] ?? json['base_selling_price'];
    return CatalogBatch(
      id: (json['id'] as num).toInt(),
      batchNumber: (json['batch_number'] ?? json['number'] ?? '').toString(),
      expirationDate: json['expiration_date']?.toString(),
      baseSellingPrice: rawPrice == null ? null : (rawPrice as num).toDouble(),
      // پردازش و مپ کردن قیمت‌های بچ-واحد از جیسون
      unitPrices: json['unit_prices'] != null
          ? (json['unit_prices'] as List)
              .map((e) => BatchUnitPrice.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
    );
  }
}

class CatalogDetail {
  final int id;
  final String name;
  final String? imagePath;
  final bool hasMultiUnits;
  final bool hasBatches;
  final List<CatalogUnit> units;
  final List<CatalogBatch> batches;

  CatalogDetail({
    required this.id,
    required this.name,
    this.imagePath,
    required this.hasMultiUnits,
    required this.hasBatches,
    required this.units,
    required this.batches,
  });

  factory CatalogDetail.fromJson(Map<String, dynamic> json) {
    final raw = json['item'] is Map ? json['item'] as Map : json;
    final data = Map<String, dynamic>.from(raw);
    return CatalogDetail(
      id: (data['id'] as num).toInt(),
      name: (data['name'] ?? '').toString(),
      imagePath: data['image_path']?.toString(),
      hasMultiUnits: data['has_multi_units'] == true,
      hasBatches: data['has_batches'] == true,
      units: (data['units'] as List? ?? [])
          .map((e) => CatalogUnit.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      batches: (data['batches'] as List? ?? [])
          .map((e) => CatalogBatch.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
