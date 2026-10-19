// D:\accounting_Arya\mobile_app\customer_app\lib\models\catalog\product_batch_option.dart

class ProductBatchOption {
  final int batchId;
  final int? accountingId;
  final String batchNumber;
  final DateTime? manufactureDate;
  final DateTime? expirationDate;
  final double baseSellingPrice;
  final double? availableQtyBase;

  const ProductBatchOption({
    required this.batchId,
    this.accountingId,
    required this.batchNumber,
    required this.baseSellingPrice,
    this.manufactureDate,
    this.expirationDate,
    this.availableQtyBase,
  });

  factory ProductBatchOption.fromJson(Map<String, dynamic> json) {
    return ProductBatchOption(
      batchId: json['batch_id'] as int,
      accountingId: json['accounting_id'] != null ? json['accounting_id'] as int : null,
      batchNumber: json['batch_number'] as String,
      manufactureDate: json['manufacture_date'] == null
          ? null
          : DateTime.tryParse(json['manufacture_date'].toString()),
      expirationDate: json['expiration_date'] == null
          ? null
          : DateTime.tryParse(json['expiration_date'].toString()),
      baseSellingPrice: (json['base_selling_price'] as num).toDouble(),
      availableQtyBase: (json['available_qty_base'] as num?)?.toDouble(),
    );
  }

  double priceFor(ProductUnitOptionLike unit) =>
      baseSellingPrice > 0 ? baseSellingPrice * unit.conversionToBase : 0;
}

abstract class ProductUnitOptionLike {
  double get conversionToBase;
}
