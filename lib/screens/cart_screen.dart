// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'payment_method_screen.dart'; 

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // پیدا کردن کنترلر سبد خرید که قبلاً ایجاد شده
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      // appBar داخلی کاملا حذف شد تا تایتل بار سبد خرید هم دوتا نشود
      body: Obx(() {
        // اگر سبد خرید خالی بود
        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text('سبد خرید شما خالی است.', style: TextStyle(fontSize: 18)),
          );
        }

        // اگر محصولی در سبد بود
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  // کنترلر برای نمایش و ویرایش دستی تعداد
                  TextEditingController qtyController = TextEditingController(text: item['quantity'].toString());

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_bag, color: Colors.blueGrey, size: 35),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? 'بدون نام', 
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${item['selling_price']} تومان', 
                                  style: const TextStyle(color: Colors.grey)
                                ),
                              ],
                            ),
                          ),
                          // بخش دکمه‌های + و - و فیلد ورود دستی
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                onPressed: () {
                                  cartController.removeFromCart(item);
                                },
                              ),
                              SizedBox(
                                width: 45,
                                height: 35,
                                child: TextField(
                                  controller: qtyController,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: OutlineInputBorder(),
                                  ),
                                  onSubmitted: (value) {
                                    int? newQty = int.tryParse(value);
                                    if (newQty != null) {
                                      cartController.updateQuantity(item, newQty);
                                    } else {
                                      // برگرداندن به مقدار قبلی در صورت ورود متن نامعتبر
                                      qtyController.text = item['quantity'].toString();
                                    }
                                  },
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: () {
                                  cartController.addToCart(item);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // بخش پایین صفحه: نمایش جمع کل و دکمه ثبت نهایی
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'جمع کل: \n${cartController.totalPrice} تومان',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        // هدایت به صفحه انتخاب روش پرداخت
                        Get.to(() => const PaymentMethodScreen());
                      },
                      child: const Text('ثبت سفارش', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
