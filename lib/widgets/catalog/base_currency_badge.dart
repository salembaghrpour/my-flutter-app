// lib/widgets/catalog/base_currency_badge.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/currency_controller.dart';

class BaseCurrencyBadge extends StatelessWidget {
  const BaseCurrencyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CurrencyController>()) {
      return const SizedBox.shrink();
    }

    final controller = Get.find<CurrencyController>();
    return Obx(() {
      final text = controller.headerText;
      if (text.isEmpty) return const SizedBox.shrink();

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF1E3A8A).withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E3A8A),
          ),
        ),
      );
    });
  }
}
