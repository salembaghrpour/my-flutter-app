import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/my_orders/my_orders_controller.dart';
import '../../models/my_orders/my_order_detail.dart';
import '../../utils/my_orders_formatters.dart';
import 'my_orders_widgets.dart';

class MyOrderDetailScreen extends StatefulWidget {
  const MyOrderDetailScreen({super.key, this.orderId});

  final String? orderId;

  @override
  State<MyOrderDetailScreen> createState() => _MyOrderDetailScreenState();
}

class _MyOrderDetailScreenState extends State<MyOrderDetailScreen> {
  late final MyOrdersController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<MyOrdersController>()
        ? Get.find<MyOrdersController>()
        : Get.put(MyOrdersController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOrderDetail(_resolveOrderId());
    });
  }

  String _resolveOrderId() {
    final String fromWidget = widget.orderId?.trim() ?? '';
    if (fromWidget.isNotEmpty) return fromWidget;

    final dynamic args = Get.arguments;
    if (args is String && args.trim().isNotEmpty) return args.trim();
    if (args is Map) {
      for (final String key in <String>['id', 'orderId', 'order_id']) {
        final dynamic value = args[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString().trim();
        }
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrderPalette.cream,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black87,
        title: const Text(
          'جزئیات سفارش',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (controller.isDetailLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.amber));
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(controller.errorMessage.value, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => controller.loadOrderDetail(_resolveOrderId()),
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            ),
          );
        }

        final MyOrderDetail? order = controller.selectedOrder.value;
        if (order == null) {
          return const Center(child: Text('سفارشی یافت نشد'));
        }

        return RefreshIndicator(
          color: Colors.amber.shade800,
          onRefresh: () => controller.loadOrderDetail(_resolveOrderId()),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: <Widget>[
              SoftOrderCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'سفارش شماره ${(order.orderNumber ?? '').trim().isEmpty ? order.id : order.orderNumber}',
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: Colors.black87),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OrderStatusChip(status: order.status ?? 'نامشخص'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    OrderMoneyText(value: order.totalPrice, fontSize: 20),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MetaLine(
                            icon: Icons.payments_outlined,
                            text: 'پرداخت: ${(order.paymentStatus ?? 'نامشخص').trim()}',
                          ),
                          MetaLine(
                            icon: Icons.receipt_long_outlined,
                            text: 'فاکتور: ${(order.invoiceNumber ?? 'ثبت نشده').trim()}',
                          ),
                          MetaLine(
                            icon: Icons.calendar_month_outlined,
                            text: 'تاریخ: ${MyOrdersFormatters.formatJalaliDate(order.createdAt)}',
                          ),
                          if ((order.description ?? '').trim().isNotEmpty)
                            MetaLine(
                              icon: Icons.notes_outlined,
                              text: (order.description ?? '').trim(),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'اقلام سفارش (${order.items.length})',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
              ),
              const SizedBox(height: 10),
              ...order.items.map(
                (MyOrderItem item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _OrderItemCard(item: item),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({required this.item});

  final MyOrderItem item;

  @override
  Widget build(BuildContext context) {
    final String unit = (item.unitName ?? '').trim();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: OrderPalette.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.brown),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  (item.productName ?? 'کالا').trim(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.black87),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: <Widget>[
                    _MiniBadge(text: 'تعداد: ${item.quantity}'),
                    _MiniBadge(text: 'واحد: ${unit.isEmpty ? 'عدد' : unit}'),
                    Text(
                      '${MyOrdersFormatters.formatMoney(item.unitPrice)} تومان / واحد',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: OrderPalette.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: OrderPalette.cardBorder.withOpacity(0.7)),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: OrderPalette.muted)),
    );
  }
}
