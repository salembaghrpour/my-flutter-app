// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/product.dart';

// کارت گرید (برای نمایش با عکس)
class ProductGridCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // فرمت‌بندی قیمت با جداکننده هزارگان
    final formattedPrice = NumberFormat.decimalPattern('fa').format(product.sellingPrice);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // لبه‌های گردتر
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // سایه کمی ملایم‌تر
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 90,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Icon(Icons.image_outlined, size: 40, color: Colors.grey),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$formattedPrice تومان',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary, // رنگ مکمل (طلایی/نارنجی)
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: const Text('افزودن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 36),
                      padding: EdgeInsets.zero,
                      elevation: 0,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // لبه‌های گرد (Pill-shape)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// کارت لیست (برای نمایش بدون عکس)
class ProductListCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductListCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.decimalPattern('fa').format(product.sellingPrice);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16), // یکسان‌سازی گردی گوشه‌ها
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '$formattedPrice تومان',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, // رنگ مکمل (طلایی/نارنجی)
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        trailing: ElevatedButton(
          onPressed: onAddToCart,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(12),
            elevation: 0, 
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.primary, // هماهنگی با تم اصلی
          ),
          child: const Icon(Icons.add_shopping_cart, size: 22),
        ),
      ),
    );
  }
}
