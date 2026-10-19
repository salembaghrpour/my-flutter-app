import 'product_batch_option.dart';
import 'product_logistics.dart';
import 'product_summary.dart';
import 'product_unit_option.dart';

class ProductDetail extends ProductSummary {
  final int? baseUnitId;
  final List<ProductUnitOption> units;
  final List<ProductBatchOption> batches;
  final ProductLogistics? logistics;

  const ProductDetail({
    required super.id,
    required super.name,
    required super.displayPrice,
    required super.priceLabel,
    super.imagePath,
    super.categoryName,
    super.baseUnitName,
    super.hasMultiUnits,
    super.hasBatches,
    super.hasLogistics,
    super.description,
    super.extraAttributes,
    this.baseUnitId,
    this.units = const [],
    this.batches = const [],
    this.logistics,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    final summary = ProductSummary.fromJson(json);
    return ProductDetail(
      id: summary.id,
      name: summary.name,
      displayPrice: summary.displayPrice,
      priceLabel: summary.priceLabel,
      imagePath: summary.imagePath,
      categoryName: summary.categoryName,
      baseUnitName: summary.baseUnitName,
      hasMultiUnits: summary.hasMultiUnits,
      hasBatches: summary.hasBatches,
      hasLogistics: summary.hasLogistics,
      description: summary.description,
      extraAttributes: summary.extraAttributes,
      baseUnitId: json['base_unit_id'] is int
          ? json['base_unit_id'] as int
          : int.tryParse('${json['base_unit_id'] ?? ''}'),
      units: (json['units'] as List? ?? [])
          .whereType<Map>()
          .map((e) => ProductUnitOption.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      batches: (json['batches'] as List? ?? [])
          .whereType<Map>()
          .map((e) => ProductBatchOption.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      logistics: json['logistics'] == null
          ? null
          : ProductLogistics.fromJson(
              Map<String, dynamic>.from(json['logistics'] as Map),
            ),
    );
  }

  ProductUnitOption get defaultUnit => units.firstWhere(
        (u) => u.isDefaultForSale,
        orElse: () => units.first,
      );

  // === متد محاسبه قیمت اصلاح شد ===
  double priceOf(ProductUnitOption unit, ProductBatchOption? batch) {
    if (batch != null) {
      // ۱. اولویت اول: بررسی وجود قیمت اختصاصی برای این واحد در این بچ
      if (batch.unitPrices != null && batch.unitPrices!.isNotEmpty) {
        for (var bup in batch.unitPrices!) {
          if (bup.unitId == unit.unitId && bup.sellingPrice > 0) {
            return bup.sellingPrice; // قیمت دقیق واکشی شده از دیتابیس
          }
        }
      }

      // ۲. اولویت دوم: در صورت نبود قیمت اختصاصی، استفاده از قیمت پایه بچ و فرمول تبدیل
      if (batch.baseSellingPrice > 0) {
        return batch.baseSellingPrice * unit.conversionToBase;
      }
    }
    
    // ۳. اولویت سوم: اگر بچی انتخاب نشده بود، قیمت عادی خود واحد
    return unit.sellingPrice;
  }
}
