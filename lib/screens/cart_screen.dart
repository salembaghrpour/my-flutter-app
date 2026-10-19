
// lib/screens/cart_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/currency_controller.dart';
import 'payment_method_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
    final rounded = price.round();
    final digits = rounded.abs().toString();
    final reversed = digits.split('').reversed.toList();
    final parts = <String>[];
    for (var i = 0; i < reversed.length; i += 3) {
      final end = i + 3 > reversed.length ? reversed.length : i + 3;
      parts.add(reversed.sublist(i, end).join());
    }
    final grouped = parts.join(',').split('').reversed.join();
    final signed = rounded < 0 ? '-$grouped' : grouped;
    return _toFaDigits(signed);
  }

  int _wholeQty(dynamic qty) {
    if (qty is num) {
      if (qty <= 0) return 1;
      if (qty < 1) return 1;
      return qty.round();
    }
    final parsed = int.tryParse('$qty') ?? 1;
    return parsed < 1 ? 1 : parsed;
  }

  String _linePriceText(Map<String, dynamic> item, String currencySymbol) {
    final num priceValue = item['selling_price'] ??
        item['unit_price'] ??
        item['price'] ??
        0;
    final unit = (item['unit_name'] ?? '').toString().trim();
    final suffix = unit.isEmpty ? currencySymbol : '$currencySymbol / $unit';
    return '${_formatPrice(priceValue)} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final CurrencyController currencyController = CurrencyController.instance;

    return Scaffold(
      body: Obx(() {
        final String currencySymbol = currencyController.currencyLabel;

        if (cartController.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'سبد خرید شما خالی است.',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  final qty = _wholeQty(item['quantity']);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 12.0,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag,
                            color: Colors.blueGrey,
                            size: 35,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? 'بدون نام',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  _linePriceText(item, currencySymbol),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  cartController.removeFromCart(item);
                                },
                              ),
                              _QtyField(
                                quantity: qty,
                                onSubmitted: (newQty) {
                                  cartController.updateQuantity(item, newQty);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  cartController.increaseQuantity(item);
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
                      'جمع کل:\n${_formatPrice(cartController.totalPrice)} $currencySymbol',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Get.to(() => const PaymentMethodScreen());
                      },
                      child: const Text(
                        'ثبت سفارش',
                        style: TextStyle(fontSize: 16),
                      ),
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

class _QtyField extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onSubmitted;

  const _QtyField({
    required this.quantity,
    required this.onSubmitted,
  });

  @override
  State<_QtyField> createState() => _QtyFieldState();
}

class _QtyFieldState extends State<_QtyField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.quantity.toString());
  }

  @override
  void didUpdateWidget(covariant _QtyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _controller.text = widget.quantity.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int? _parseQty(String value) {
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    const ar = '٠١٢٣٤٥٦٧٨٩';
    final buffer = StringBuffer();
    for (final rune in value.runes) {
      final ch = String.fromCharCode(rune);
      final fi = fa.indexOf(ch);
      if (fi >= 0) {
        buffer.write(fi);
        continue;
      }
      final ai = ar.indexOf(ch);
      if (ai >= 0) {
        buffer.write(ai);
        continue;
      }
      buffer.write(ch);
    }
    final cleaned = buffer.toString().replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 35,
      child: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          final newQty = _parseQty(value);
          if (newQty != null && newQty > 0) {
            widget.onSubmitted(newQty);
          } else {
            _controller.text = widget.quantity.toString();
          }
        },
      ),
    );
  }
}