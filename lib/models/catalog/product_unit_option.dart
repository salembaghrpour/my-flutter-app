// D:\accounting_Arya\mobile_app\customer_app\lib\models\catalog\product_unit_option.dart

class ProductUnitOption {
  final int unitId;
  final int? accountingId;
  final String unitName;
  final String? unitSymbol;
  final double sellingPrice;
  final double conversionToBase;
  final bool isDefaultForSale;
  final bool allowDecimalQty;
  final double qtyStep;
  final double minOrderQty;

  const ProductUnitOption({
    required this.unitId,
    this.accountingId,
    required this.unitName,
    required this.sellingPrice,
    required this.conversionToBase,
    this.unitSymbol,
    this.isDefaultForSale = false,
    this.allowDecimalQty = true,
    this.qtyStep = 1,
    this.minOrderQty = 1,
  });

  factory ProductUnitOption.fromJson(Map<String, dynamic> json) {
    return ProductUnitOption(
      unitId: json['unit_id'] as int,
      accountingId: json['accounting_id'] != null ? json['accounting_id'] as int : null,
      unitName: json['unit_name'] as String,
      unitSymbol: json['unit_symbol'] as String?,
      sellingPrice: (json['selling_price'] as num).toDouble(),
      conversionToBase: (json['conversion_to_base'] as num).toDouble(),
      isDefaultForSale: json['is_default_for_sale'] == true,
      allowDecimalQty: json['allow_decimal_qty'] != false,
      qtyStep: (json['qty_step'] as num?)?.toDouble() ?? 1,
      minOrderQty: (json['min_order_qty'] as num?)?.toDouble() ?? 1,
    );
  }
}
