int toInt(dynamic value, {int fallback = 0}) {
  if (value == null) return fallback;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString().trim()) ?? fallback;
}

double toDouble(dynamic value, {double fallback = 0}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString().trim().replaceAll(',', '')) ?? fallback;
}

String? toNullableString(dynamic value) {
  if (value == null) return null;
  final String text = value.toString().trim();
  return text.isEmpty ? null : text;
}

class MyOrderSummary {
  const MyOrderSummary({
    required this.id,
    this.orderNumber,
    this.status,
    required this.totalPrice,
    this.createdAt,
    this.itemsCount,
    this.paymentStatus,
  });

  final String id;
  final String? orderNumber;
  final String? status;
  final double totalPrice;
  final String? createdAt;
  final int? itemsCount;
  final String? paymentStatus;

  factory MyOrderSummary.fromJson(Map<String, dynamic> json) {
    return MyOrderSummary(
      id: (json['id'] ?? json['order_id'] ?? '').toString(),
      orderNumber: toNullableString(json['order_number'] ?? json['orderNumber'] ?? json['number']),
      status: toNullableString(json['status'] ?? json['order_status']),
      totalPrice: toDouble(json['total_price'] ?? json['totalPrice'] ?? json['total'] ?? json['amount']),
      createdAt: toNullableString(json['created_at'] ?? json['createdAt'] ?? json['date']),
      itemsCount: json['items_count'] == null && json['itemsCount'] == null
          ? null
          : toInt(json['items_count'] ?? json['itemsCount']),
      paymentStatus: toNullableString(json['payment_status'] ?? json['paymentStatus']),
    );
  }
}
