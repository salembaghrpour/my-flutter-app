// lib/screens/payment_method_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../controllers/cart_controller.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final OrderController orderController = Get.put(OrderController());
  final CartController cartController = Get.find<CartController>();
  
  String selectedMethod = 'cash_on_delivery';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نحوه پرداخت و ثبت سفارش')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'مبلغ کل قابل پرداخت: ${cartController.totalPrice} تومان',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            const Text('روش پرداخت را انتخاب کنید:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            RadioListTile(
              title: const Text('پرداخت در محل (Cash on Delivery)'),
              value: 'cash_on_delivery',
              groupValue: selectedMethod,
              onChanged: (value) => setState(() => selectedMethod = value.toString()),
            ),
            RadioListTile(
              title: const Text('پرداخت آنلاین (درگاه بانکی)'),
              value: 'online_gateway',
              groupValue: selectedMethod,
              onChanged: (value) => setState(() => selectedMethod = value.toString()),
            ),
            const Spacer(),
            Obx(() => SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
                onPressed: orderController.isLoading.value 
                  ? null 
                  : () async {
                      // آیدی تستی حذف شد. تابع حالا فقط روش پرداخت را می‌گیرد
                      // و کنترلر خودش آیدی واقعی را از حافظه می‌خواند
                      bool success = await orderController.submitOrder(selectedMethod);
                      
                      if (success) {
                        // در صورت موفقیت، بازگشت به صفحه اصلی یا نمایش رسید
                        Get.offAllNamed('/home'); // مسیر صفحه اصلی خود را جایگزین کنید
                      }
                    },
                child: orderController.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('تایید نهایی و ثبت سفارش', style: TextStyle(fontSize: 18)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
