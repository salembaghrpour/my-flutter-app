// lib/screens/payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/currency_controller.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final OrderController orderController = Get.put(OrderController());
  final CartController cartController = Get.find<CartController>();
  final CurrencyController currencyController = CurrencyController.instance;

  String selectedMethod = 'cash_on_delivery';

  String _toFaDigits(String input) {
    const en = '0123456789';
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final index = en.indexOf(ch);
      buffer.write(index >= 0 ? fa[index] : ch);
    }
    return buffer.toString();
  }

  String _formatPrice(num price) {
    final digits = price.truncate().toString();
    final reversed = digits.split('').reversed.toList();
    final parts = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      final end = i + 3 > reversed.length ? reversed.length : i + 3;
      parts.add(reversed.sublist(i, end).join());
    }
    final grouped = parts.join(',').split('').reversed.join();
    final signed = price < 0 ? '-$grouped' : grouped;
    return _toFaDigits(signed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نحوه پرداخت و ثبت سفارش')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'مبلغ کل قابل پرداخت: ${_formatPrice(cartController.totalPrice)} ${currencyController.currencyLabel}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'روش پرداخت را انتخاب کنید:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            RadioListTile(
              title: const Text('پرداخت در محل (Cash on Delivery)'),
              value: 'cash_on_delivery',
              groupValue: selectedMethod,
              onChanged: (value) =>
                  setState(() => selectedMethod = value.toString()),
            ),
            RadioListTile(
              title: const Text('پرداخت آنلاین (درگاه بانکی)'),
              value: 'online_gateway',
              groupValue: selectedMethod,
              onChanged: (value) =>
                  setState(() => selectedMethod = value.toString()),
            ),
            const Spacer(),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: orderController.isLoading.value
                      ? null
                      : () async {
                          final success =
                              await orderController.submitOrder(selectedMethod);

                          if (success) {
                            Get.snackbar(
                              'موفق',
                              'سفارش شما با موفقیت ثبت شد',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );

                            try {
                              Get.offAllNamed('/home');
                            } catch (e) {
                              print('⚠️ خطا در مسیریابی: $e');
                              Get.back();
                            }
                          }
                        },
                  child: orderController.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'تایید نهایی و ثبت سفارش',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
