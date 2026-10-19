import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/my_orders/my_orders_controller.dart';
import '../../models/my_orders/my_order_summary.dart';
import '../../utils/my_orders_formatters.dart';
import 'my_order_detail_screen.dart';
import 'my_orders_widgets.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MyOrdersController controller = Get.isRegistered<MyOrdersController>()
        ? Get.find<MyOrdersController>()
        : Get.put(MyOrdersController(), permanent: true);

    return Scaffold(
      backgroundColor: OrderPalette.cream,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.amber));
        }
        if (controller.errorMessage.value.isNotEmpty) {
          return _MessageState(
            message: controller.errorMessage.value,
            onAction: controller.loadOrders,
          );
        }
        if (controller.orders.isEmpty) {
          return _MessageState(
            message: 'هیچ سفارشی ثبت نشده است.',
            onAction: controller.loadOrders,
          );
        }
        return RefreshIndicator(
          color: Colors.amber.shade800,
          onRefresh: controller.loadOrders,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            itemCount: controller.orders.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    'سفارش‌های من (${controller.orders.length})',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                );
              }
              final MyOrderSummary order = controller.orders[index - 1];
              return _OrderSummaryCard(
                order: order,
                onTap: () => Get.to(() => MyOrderDetailScreen(orderId: order.id)),
              );
            },
          ),
        );
      }),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.order, required this.onTap});

  final MyOrderSummary order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SoftOrderCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    'سفارش شماره ${(order.orderNumber ?? '').trim().isEmpty ? order.id : order.orderNumber}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                ),
                OrderStatusChip(status: order.status ?? 'نامشخص'),
              ],
            ),
            const SizedBox(height: 8),
            OrderMoneyText(value: order.totalPrice, fontSize: 20),
            const SizedBox(height: 8),
            MetaLine(icon: Icons.calendar_month_outlined, text: MyOrdersFormatters.formatJalaliDate(order.createdAt)),
            if ((order.itemsCount ?? 0) > 0)
              MetaLine(icon: Icons.shopping_bag_outlined, text: 'تعداد اقلام: ${order.itemsCount}'),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({required this.message, required this.onAction});

  final String message;
  final Future<void> Function() onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.receipt_long_outlined, size: 48, color: Colors.amber.shade700),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: OrderPalette.muted, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onAction(),
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }
}
