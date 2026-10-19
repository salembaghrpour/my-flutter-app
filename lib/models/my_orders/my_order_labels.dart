import 'package:flutter/material.dart';

class MyOrderLabels {
  static String status(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'pending':
        return 'در انتظار';
      case 'confirmed':
        return 'تأیید شده';
      case 'processing':
        return 'در حال پردازش';
      case 'shipped':
        return 'ارسال شده';
      case 'delivered':
        return 'تحویل شده';
      case 'completed':
        return 'تکمیل شده';
      case 'cancelled':
      case 'canceled':
        return 'لغو شده';
      default:
        return (raw == null || raw.trim().isEmpty) ? 'نامشخص' : raw;
    }
  }

  static String payment(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'cash':
        return 'نقدی';
      case 'cheque':
        return 'چک';
      case 'credit':
        return 'اعتباری';
      case 'cash_on_delivery':
        return 'پرداخت در محل';
      default:
        return (raw == null || raw.trim().isEmpty) ? 'نامشخص' : raw;
    }
  }

  static Color statusColor(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'pending':
        return const Color(0xFFE67E22);
      case 'confirmed':
      case 'processing':
        return const Color(0xFF2980B9);
      case 'shipped':
        return const Color(0xFF8E44AD);
      case 'delivered':
      case 'completed':
        return const Color(0xFF27AE60);
      case 'cancelled':
      case 'canceled':
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFF7F8C8D);
    }
  }

  static String money(num value) {
    final negative = value < 0;
    final whole = value.abs().round().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(whole[i]);
    }
    final formatted = buffer.toString();
    return negative ? '-$formatted' : formatted;
  }

  static String dateTime(String? iso) {
    if (iso == null || iso.trim().isEmpty) return '-';
    try {
      final dt = DateTime.parse(iso).toLocal();
      String two(int n) => n.toString().padLeft(2, '0');
      return '${dt.year}/${two(dt.month)}/${two(dt.day)}  ${two(dt.hour)}:${two(dt.minute)}';
    } catch (_) {
      return iso;
    }
  }
}
