// lib/utils/my_orders_formatters.dart
class MyOrdersFormatters {
  MyOrdersFormatters._();

  static const _faDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  static String toFaDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final d = int.tryParse(ch);
      buffer.write(d == null ? ch : _faDigits[d]);
    }
    return buffer.toString();
  }

  static String formatMoney(num value) {
    final intPart = value.round().abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) buffer.write(',');
      buffer.write(intPart[i]);
    }
    final formatted = buffer.toString();
    return value < 0 ? '-$formatted' : formatted;
  }

  static String quantity(num value) {
    if (value == value.roundToDouble()) return value.round().toString();
    return value.toString();
  }

  /// پارس بدون جابه‌جایی تایم‌زون مرورگر (مهم برای Flutter Web)
  static String formatJalaliDate(String? raw) {
    final parsed = _parseDate(raw);
    if (parsed == null) return '—';

    final j = _gregorianToJalali(parsed.year, parsed.month, parsed.day);
    
    // تبدیل ماه و روز به فرمت دو رقمی (مثلاً 06 به جای 6)
    final monthStr = j.month.toString().padLeft(2, '0');
    final dayStr = j.day.toString().padLeft(2, '0');
    
    // فرمت تاریخ به شکل 1405/06/31
    final dateText = '${j.year}/$monthStr/$dayStr';

    if (parsed.hasTime) {
      final h = parsed.hour.toString().padLeft(2, '0');
      final m = parsed.minute.toString().padLeft(2, '0');
      // جداسازی تاریخ و ساعت با خط تیره برای جلوگیری از بهم ریختگی
      return toFaDigits('$dateText   -   $h:$m');
    }
    return toFaDigits(dateText);
  }

  static String paymentLabel(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    switch (v) {
      case 'cash':
      case 'cod':
      case 'pay_on_delivery':
      case 'پرداخت در محل':
        return 'پرداخت در محل';
      case 'online':
      case 'card':
      case 'gateway':
        return 'پرداخت آنلاین';
      case 'credit':
      case 'account':
        return 'اعتباری';
      case '':
        return 'نامشخص';
      default:
        return raw!.trim();
    }
  }

  static String statusLabel(String? raw) {
    switch ((raw ?? '').trim().toLowerCase()) {
      case 'synced':
      case 'registered':
      case 'submitted':
        return 'ثبت شده';
      case 'pending':
        return 'در انتظار';
      case 'confirmed':
        return 'تأیید شده';
      case 'processing':
        return 'در حال آماده‌سازی';
      case 'delivered':
        return 'تحویل شده';
      case 'cancelled':
      case 'canceled':
        return 'لغو شده';
      case 'rejected':
        return 'رد شده';
      default:
        final v = (raw ?? '').trim();
        return v.isEmpty ? 'نامشخص' : v;
    }
  }

  static _ParsedDate? _parseDate(String? raw) {
    if (raw == null) return null;
    final s = raw.trim();
    if (s.isEmpty || s == '-') return null;

    final patterns = <RegExp>[
      // 00:26 2026/09/22
      RegExp(
        r'^(\d{1,2}):(\d{2})(?::(\d{2}))?\s+(\d{4})[/-](\d{1,2})[/-](\d{1,2})$',
      ),
      // 2026-09-22T00:26:00  یا  2026/09/22 00:26
      RegExp(
        r'^(\d{4})[/-](\d{1,2})[/-](\d{1,2})[T ](\d{1,2}):(\d{2})(?::(\d{2}))?',
      ),
      // 2026-09-22
      RegExp(r'^(\d{4})[/-](\d{1,2})[/-](\d{1,2})$'),
    ];

    final m0 = patterns[0].firstMatch(s);
    if (m0 != null) {
      return _ParsedDate(
        year: int.parse(m0.group(4)!),
        month: int.parse(m0.group(5)!),
        day: int.parse(m0.group(6)!),
        hour: int.parse(m0.group(1)!),
        minute: int.parse(m0.group(2)!),
        hasTime: true,
      );
    }

    final m1 = patterns[1].firstMatch(s);
    if (m1 != null) {
      return _ParsedDate(
        year: int.parse(m1.group(1)!),
        month: int.parse(m1.group(2)!),
        day: int.parse(m1.group(3)!),
        hour: int.parse(m1.group(4)!),
        minute: int.parse(m1.group(5)!),
        hasTime: true,
      );
    }

    final m2 = patterns[2].firstMatch(s);
    if (m2 != null) {
      return _ParsedDate(
        year: int.parse(m2.group(1)!),
        month: int.parse(m2.group(2)!),
        day: int.parse(m2.group(3)!),
      );
    }

    final dt = DateTime.tryParse(s);
    if (dt == null) return null;
    return _ParsedDate(
      year: dt.year,
      month: dt.month,
      day: dt.day,
      hour: dt.hour,
      minute: dt.minute,
      hasTime: true,
    );
  }

  static ({int year, int month, int day}) _gregorianToJalali(
    int gy,
    int gm,
    int gd,
  ) {
    const gDm = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    final gy2 = gm > 2 ? gy + 1 : gy;
    var days = 355666 +
        (365 * gy) +
        ((gy2 + 3) ~/ 4) -
        ((gy2 + 99) ~/ 100) +
        ((gy2 + 399) ~/ 400) +
        gd +
        gDm[gm - 1];
    var jy = -1595 + (33 * (days ~/ 12053));
    days %= 12053;
    jy += 4 * (days ~/ 1461);
    days %= 1461;
    if (days > 365) {
      jy += (days - 1) ~/ 365;
      days = (days - 1) % 365;
    }
    late int jm;
    late int jd;
    if (days < 186) {
      jm = 1 + (days ~/ 31);
      jd = 1 + (days % 31);
    } else {
      jm = 7 + ((days - 186) ~/ 30);
      jd = 1 + ((days - 186) % 30);
    }
    return (year: jy, month: jm, day: jd);
  }
}

class _ParsedDate {
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final bool hasTime;

  const _ParsedDate({
    required this.year,
    required this.month,
    required this.day,
    this.hour = 0,
    this.minute = 0,
    this.hasTime = false,
  });
}
