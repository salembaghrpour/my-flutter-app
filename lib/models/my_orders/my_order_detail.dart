import 'my_order_summary.dart';

class MyOrderItem {
  const MyOrderItem({
    this.productName,
    required this.quantity,
    this.unitName,
    required this.unitPrice,
  });

  final String? productName;
  final double quantity;
  final String? unitName;
  final double unitPrice;

  factory MyOrderItem.fromJson(Map<String, dynamic> json) {
    return MyOrderItem(
      productName: toNullableString(
        json['product_name'] ?? json['productName'] ?? json['name'] ?? json['title'],
      ),
      quantity: toDouble(json['quantity'] ?? json['qty'] ?? 1, fallback: 1),
      unitName: toNullableString(json['unit_name'] ?? json['unitName'] ?? json['unit']),
      unitPrice: toDouble(json['unit_price'] ?? json['unitPrice'] ?? json['price']),
    );
  }
}

class MyOrderDetail {
  const MyOrderDetail({
    required this.id,
    this.orderNumber,
    this.status,
    required this.totalPrice,
    this.paymentStatus,
    this.invoiceNumber,
    this.createdAt,
    this.description,
    this.items = const <MyOrderItem>[],
  });

  final String id;
  final String? orderNumber;
  final String? status;
  final double totalPrice;
  final String? paymentStatus;
  final String? invoiceNumber;
  final String? createdAt;
  final String? description;
  final List<MyOrderItem> items;

  factory MyOrderDetail.fromJson(Map<String, dynamic> json) {
    final dynamic rawItems = json['items'] ?? json['order_items'] ?? json['details'];
    final List<MyOrderItem> parsedItems = <MyOrderItem>[];
    if (rawItems is List) {
      for (final dynamic row in rawItems) {
        if (row is Map<String, dynamic>) {
          parsedItems.add(MyOrderItem.fromJson(row));
        } else if (row is Map) {
          parsedItems.add(
            MyOrderItem.fromJson(
              row.map<String, dynamic>((dynamic k, dynamic v) => MapEntry<String, dynamic>(k.toString(), v)),
            ),
          );
        }
      }
    }

    return MyOrderDetail(
      id: (json['id'] ?? json['order_id'] ?? '').toString(),
      orderNumber: toNullableString(json['order_number'] ?? json['orderNumber'] ?? json['number']),
      status: toNullableString(json['status'] ?? json['order_status']),
      totalPrice: toDouble(json['total_price'] ?? json['totalPrice'] ?? json['total'] ?? json['amount']),
      paymentStatus: toNullableString(json['payment_status'] ?? json['paymentStatus']),
      invoiceNumber: toNullableString(json['invoice_number'] ?? json['invoiceNumber'] ?? json['invoice']),
      createdAt: toNullableString(json['created_at'] ?? json['createdAt'] ?? json['date']),
      description: toNullableString(json['description'] ?? json['note'] ?? json['notes']),
      items: parsedItems,
    );
  }
}
