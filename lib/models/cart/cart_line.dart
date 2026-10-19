
// D:\accounting_Arya\mobile_app\customer_app\lib\models\cart\cart_line.dart

class CartLine {
  final int productId;
  final String productName;
  final int? unitId;
  final int? unitAccountingId;
  final String unitName;
  final int? batchId;
  final int? batchAccountingId;
  final String? batchNumber;
  final String? expirationDate;
  final double quantity;
  final double unitPrice;
  final double conversionToBase;
  final String? imagePath;
  final String? sizeLabel;

  CartLine({
    required this.productId,
    required this.productName,
    this.unitId,
    this.unitAccountingId,
    required this.unitName,
    this.batchId,
    this.batchAccountingId,
    this.batchNumber,
    this.expirationDate,
    required this.quantity,
    required this.unitPrice,
    this.conversionToBase = 1,
    this.imagePath,
    this.sizeLabel,
  });

  int? get validUnitId => (unitId != null && unitId! > 0) ? unitId : null;
  int? get validUnitAccountingId => (unitAccountingId != null && unitAccountingId! > 0) ? unitAccountingId : null;

  int? get validBatchId => (batchId != null && batchId! > 0) ? batchId : null;
  int? get validBatchAccountingId => (batchAccountingId != null && batchAccountingId! > 0) ? batchAccountingId : null;

  String get lineKey => '$productId-${validUnitId ?? 0}-${validBatchId ?? 0}';

  double get totalPrice => unitPrice * quantity;

  CartLine copyWith({
    int? productId,
    String? productName,
    int? unitId,
    int? unitAccountingId,
    bool clearUnitId = false,
    String? unitName,
    int? batchId,
    int? batchAccountingId,
    bool clearBatchId = false,
    String? batchNumber,
    String? expirationDate,
    double? quantity,
    double? unitPrice,
    double? conversionToBase,
    String? imagePath,
    String? sizeLabel,
  }) {
    return CartLine(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      unitId: clearUnitId ? null : (unitId ?? this.unitId),
      unitAccountingId: clearUnitId ? null : (unitAccountingId ?? this.unitAccountingId),
      unitName: unitName ?? this.unitName,
      batchId: clearBatchId ? null : (batchId ?? this.batchId),
      batchAccountingId: clearBatchId ? null : (batchAccountingId ?? this.batchAccountingId),
      batchNumber: batchNumber ?? this.batchNumber,
      expirationDate: expirationDate ?? this.expirationDate,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      conversionToBase: conversionToBase ?? this.conversionToBase,
      imagePath: imagePath ?? this.imagePath,
      sizeLabel: sizeLabel ?? this.sizeLabel,
    );
  }

  Map<String, dynamic> toOrderPayload() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'unit_price': unitPrice,
      // ارسال آیدی حسابداری در صورت وجود، در غیر این صورت آیدی داخلی
      if (validUnitAccountingId != null) 
        'unit_id': validUnitAccountingId
      else if (validUnitId != null) 
        'unit_id': validUnitId,

      if (validBatchAccountingId != null) 
        'batch_id': validBatchAccountingId
      else if (validBatchId != null) 
        'batch_id': validBatchId,
    };
  }
}
