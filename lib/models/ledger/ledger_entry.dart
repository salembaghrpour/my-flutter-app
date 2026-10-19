import 'package:customer_app/core/local/db/app_database.dart';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

class LedgerEntry {
  final int id;
  final String operationType;
  final String? description;
  final double debit;
  final double credit;
  final double balanceAfter;
  final String? documentNumber;
  final DateTime createdAt;
  final int sortIndex;
  final DateTime? syncedAt;

  const LedgerEntry({
    required this.id,
    required this.operationType,
    this.description,
    required this.debit,
    required this.credit,
    required this.balanceAfter,
    this.documentNumber,
    required this.createdAt,
    this.sortIndex = 0,
    this.syncedAt,
  });

  bool get hasDebit => debit > 0;
  bool get hasCredit => credit > 0;

  String get operationTypeFa {
    const map = {
      'sales': 'فروش',
      'sale': 'فروش',
      'payment': 'دریافت',
      'receipt': 'دریافت',
      'receive': 'دریافت',
      'purchase': 'خرید',
      'return': 'برگشت',
      'sales_return': 'برگشت از فروش',
      'adjustment': 'تعدیل',
      'opening': 'افتتاحیه',
      'opening_balance': 'مانده اول دوره',
      'debit': 'بدهکار',
      'credit': 'بستانکار',
    };
    return map[operationType.toLowerCase().trim()] ?? operationType;
  }

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      id: _toInt(json['id']),
      operationType: (json['operation_type'] ??
              json['operationType'] ??
              json['type'] ??
              '')
          .toString(),
      description: json['description']?.toString(),
      debit: _toDouble(json['debit']),
      credit: _toDouble(json['credit']),
      balanceAfter: _toDouble(json['balance_after'] ?? json['balanceAfter']),
      documentNumber: (json['document_number'] ?? json['documentNumber'])
          ?.toString(),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      sortIndex: _toInt(json['sort_index'] ?? json['sortIndex'] ?? json['id']),
    );
  }

  factory LedgerEntry.fromLocal(LocalLedgerEntry row) {
    return LedgerEntry(
      id: row.id,
      operationType: row.operationType,
      description: row.description,
      debit: row.debit,
      credit: row.credit,
      balanceAfter: row.balanceAfter,
      documentNumber: row.documentNumber,
      createdAt: row.createdAt,
      sortIndex: row.sortIndex,
      syncedAt: row.syncedAt,
    );
  }

  LedgerEntriesCompanion toCompanion({
    DateTime? syncedAt,
    int? sortIndex,
  }) {
    return LedgerEntriesCompanion.insert(
      id: Value(id),
      operationType: operationType,
      debit: debit,
      credit: credit,
      balanceAfter: balanceAfter,
      createdAt: createdAt,
      description: Value(description),
      documentNumber: Value(documentNumber),
      sortIndex: Value(sortIndex ?? this.sortIndex),
      syncedAt: Value(syncedAt ?? this.syncedAt ?? DateTime.now()),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString().replaceAll(',', '')) ?? 0;
  }

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}

class LedgerFormat {
  static const _en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ','];
  static const _fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹', '٬'];

  static String money(num value) {
    final formatted = NumberFormat('#,###').format(value.round().abs());
    final signed = value < 0 ? '-$formatted' : formatted;
    return toPersianDigits(signed);
  }

  static String toPersianDigits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final ch = String.fromCharCode(rune);
      final idx = _en.indexOf(ch);
      buffer.write(idx >= 0 ? _fa[idx] : ch);
    }
    return buffer.toString();
  }

  static String jalaliDate(DateTime dt) {
    final f = Jalali.fromDateTime(dt).formatter;
    return toPersianDigits('${f.yyyy}/${f.mm}/${f.dd}');
  }

  static String jalaliDateTime(DateTime dt) {
    final f = Jalali.fromDateTime(dt).formatter;
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return toPersianDigits('${f.yyyy}/${f.mm}/${f.dd}  $h:$m');
  }
}
