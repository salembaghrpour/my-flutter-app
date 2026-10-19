// lib/screens/my_orders/my_orders_widgets.dart

import 'package:flutter/material.dart';

import '../../utils/my_orders_formatters.dart';

class OrderPalette {
  static const cream = Color(0xFFFFF8E8);
  static const creamDeep = Color(0xFFFFF1CC);
  static const cardBorder = Color(0xFFE8D39A);
  static const ink = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
  static const amountLow = Color(0xFF0F766E);
  static const amountMid = Color(0xFFC2410C);
  static const amountHigh = Color(0xFF9F1239);
  static const unitPrice = Color(0xFF4338CA);

  static Color amountColor(num value) {
    if (value >= 10000000) return amountHigh;
    if (value >= 1000000) return amountMid;
    return amountLow;
  }

  static Color statusColor(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'synced':
      case 'confirmed':
      case 'delivered':
      case 'registered':
      case 'submitted':
        return const Color(0xFF15803D);
      case 'pending':
      case 'processing':
        return const Color(0xFFD97706);
      case 'cancelled':
      case 'canceled':
      case 'rejected':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF64748B);
    }
  }
}

class OrderStatusChip extends StatelessWidget {
  final String status;
  const OrderStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = OrderPalette.statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.28)),
      ),
      child: Text(
        MyOrdersFormatters.statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class OrderMoneyText extends StatelessWidget {
  final num value;
  final double fontSize;
  final bool showToman;
  final Color? color;

  const OrderMoneyText({
    super.key,
    required this.value,
    this.fontSize = 16,
    this.showToman = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? OrderPalette.amountColor(value);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            // ******** FIX: Renamed 'money' to 'formatMoney' ********
            text: MyOrdersFormatters.formatMoney(value),
            style: TextStyle(
              color: c,
              fontSize: fontSize,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          if (showToman)
            TextSpan(
              text: ' تومان',
              style: TextStyle(
                color: c.withOpacity(0.85),
                fontSize: fontSize * 0.7,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      textDirection: TextDirection.rtl,
    );
  }
}

class SoftOrderCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color accent;

  const SoftOrderCard({
    super.key,
    required this.child,
    this.onTap,
    this.accent = const Color(0xFFF5C518),
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [OrderPalette.cream, Colors.white, OrderPalette.creamDeep],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: OrderPalette.cardBorder.withOpacity(0.85)),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.14),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
              child: child,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: card,
      ),
    );
  }
}

class MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const MetaLine({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: OrderPalette.muted),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: OrderPalette.muted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
