// lib/utils/jalali_date.dart
class JalaliDate {
  final int year;
  final int month;
  final int day;

  const JalaliDate({
    required this.year,
    required this.month,
    required this.day,
  });

  static JalaliDate fromDateTime(DateTime date) {
    final local = date.toLocal();
    return fromGregorian(local.year, local.month, local.day);
  }

  /// تبدیل میلادی به شمسی (الگوریتم استاندارد جلالی).
  static JalaliDate fromGregorian(int gy, int gm, int gd) {
    final gDm = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
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

    final jm = days < 186 ? 1 + (days ~/ 31) : 7 + ((days - 186) ~/ 30);
    final jd = 1 + (days < 186 ? (days % 31) : ((days - 186) % 30));
    return JalaliDate(year: jy, month: jm, day: jd);
  }

  static String formatDate(DateTime date) {
    final j = fromDateTime(date);
    return '${j.year}/${_two(j.month)}/${_two(j.day)}';
  }

  static String formatDateTime(DateTime date) {
    final local = date.toLocal();
    return '${formatDate(local)} ${_two(local.hour)}:${_two(local.minute)}';
  }

  /// رشتهٔ ISO یا `yyyy-MM-dd HH:mm` را به شمسی برمی‌گرداند.
  static String formatRaw(
    String raw, {
    bool withTime = true,
  }) {
    final text = raw.trim();
    if (text.isEmpty) return '';
    final parsed = DateTime.tryParse(text.replaceFirst(' ', 'T'));
    if (parsed == null) return text;
    return withTime ? formatDateTime(parsed) : formatDate(parsed);
  }

  static String toPersianDigits(String input) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    var out = input;
    for (var i = 0; i < en.length; i++) {
      out = out.replaceAll(en[i], fa[i]);
    }
    return out;
  }

  static String _two(int value) => value.toString().padLeft(2, '0');
}
