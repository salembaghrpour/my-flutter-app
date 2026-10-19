import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../controllers/ledger/ledger_controller.dart';
import '../../controllers/currency_controller.dart';
import '../../models/ledger/ledger_entry.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LedgerController ledgerController = Get.isRegistered<LedgerController>()
        ? Get.find<LedgerController>()
        : Get.put(LedgerController(), permanent: true);
    final CurrencyController currencyController = Get.find<CurrencyController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3EEE3),
      body: Obx(() {
        final hasEntries = ledgerController.entries.isNotEmpty;
        final showInitialLoader = ledgerController.isLoading.value && !hasEntries;

        if (showInitialLoader) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFFC9A227)),
                SizedBox(height: 12),
                Text(
                  'در حال بارگذاری صورتحساب...',
                  style: TextStyle(color: Color(0xFF6D5C3D)),
                ),
              ],
            ),
          );
        }

        if (!hasEntries && ledgerController.errorMessage.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ledgerController.isOffline.value
                        ? Icons.wifi_off
                        : Icons.error_outline,
                    color: ledgerController.isOffline.value
                        ? const Color(0xFF8D6E63)
                        : Colors.red,
                    size: 42,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    ledgerController.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ledgerController.isOffline.value
                          ? const Color(0xFF6D5C3D)
                          : Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton(
                    onPressed: () => ledgerController.fetchHistory(),
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!hasEntries) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long, size: 48, color: Color(0xFFB5A57A)),
                SizedBox(height: 10),
                Text(
                  'هیچ تراکنشی یافت نشد.',
                  style: TextStyle(color: Color(0xFF6D5C3D), fontSize: 15),
                ),
              ],
            ),
          );
        }

        final entries = ledgerController.entries.toList();
        final currency = currencyController.baseName;
        final bannerText = _bannerText(ledgerController);

        return Column(
          children: [
            if (ledgerController.isRefreshing.value)
              const LinearProgressIndicator(
                minHeight: 2,
                color: Color(0xFFC9A227),
                backgroundColor: Color(0xFFE6D9B8),
              ),
            if (bannerText != null) _StatusBanner(text: bannerText),
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFFC9A227),
                onRefresh: () => ledgerController.fetchHistory(),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 28),
                  children: [
                    _SummaryCard(entries: entries, currency: currency),
                    ..._buildGroupedCards(entries, currency),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String? _bannerText(LedgerController controller) {
    if (controller.syncWarning.isNotEmpty) {
      return controller.syncWarning.value;
    }
    if (controller.isOffline.value) {
      return 'اتصال اینترنت برقرار نیست. آخرین نسخه ذخیره‌شده نمایش داده می‌شود.';
    }
    if (controller.isFromCache.value) {
      return 'در حال نمایش نسخه ذخیره‌شده. برای به‌روزرسانی صفحه را بکشید.';
    }
    return null;
  }

  List<Widget> _buildGroupedCards(List<LedgerEntry> entries, String currency) {
    final widgets = <Widget>[];
    String? lastKey;

    for (final entry in entries) {
      final key = LedgerFormat.dateKey(entry.createdAt);
      if (key != lastKey) {
        widgets.add(_DateHeader(date: entry.createdAt));
        lastKey = key;
      }
      widgets.add(_EntryCard(entry: entry, currency: currency));
    }

    return widgets;
  }
}

class _StatusBanner extends StatelessWidget {
  final String text;

  const _StatusBanner({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3CD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE0C35A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 18, color: Color(0xFF6D5C3D)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF6D5C3D),
                fontSize: 12.5,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LedgerFormat {
  LedgerFormat._();

  static final NumberFormat _amount = NumberFormat('#,##0.##', 'en_US');

  static String digits(String input) {
    const english = '0123456789,';
    const persian = '۰۱۲۳۴۵۶۷۸۹٬';
    final buffer = StringBuffer();
    for (final ch in input.split('')) {
      final index = english.indexOf(ch);
      buffer.write(index >= 0 ? persian[index] : ch);
    }
    return buffer.toString();
  }

  static String money(num value) {
    final formatted = _amount.format(value.abs());
    final signed = value < 0 ? '-$formatted' : formatted;
    return digits(signed);
  }

  static Jalali _jalali(DateTime dateTime) {
    return Jalali.fromDateTime(dateTime.toLocal());
  }

  static String dateKey(DateTime dateTime) {
    final jalali = _jalali(dateTime);
    return '${jalali.year}-${jalali.month}-${jalali.day}';
  }

  static String compactDate(DateTime dateTime) {
    final formatter = _jalali(dateTime).formatter;
    return digits('${formatter.yyyy}/${formatter.mm}/${formatter.dd}');
  }

  static String fullDate(DateTime dateTime) {
    final jalali = _jalali(dateTime);
    final formatter = jalali.formatter;
    return '${digits(formatter.d)} ${formatter.mN} ${digits(formatter.yyyy)}';
  }

  static String? invoiceNumber(LedgerEntry entry) {
    final document = entry.documentNumber?.trim();
    if (document != null && document.isNotEmpty) {
      return document;
    }

    final description = entry.description ?? '';
    final match = RegExp(r'INV[-_]?\d+', caseSensitive: false).firstMatch(description);
    return match?.group(0)?.toUpperCase();
  }

  static String cleanDescription(LedgerEntry entry) {
    var text = entry.description?.trim() ?? '';
    if (text.isEmpty) {
      return '';
    }

    final invoice = invoiceNumber(entry);
    if (invoice != null && text.toUpperCase().startsWith(invoice.toUpperCase())) {
      text = text.substring(invoice.length).trim();
      if (text.startsWith('-') || text.startsWith(':') || text.startsWith('–')) {
        text = text.substring(1).trim();
      }
    }
    return text;
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, right: 4, left: 4),
      child: Row(
        children: [
          Expanded(
            child: Divider(color: Colors.brown.withOpacity(0.2), thickness: 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              LedgerFormat.fullDate(date),
              style: TextStyle(
                color: Colors.brown.shade700,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Divider(color: Colors.brown.withOpacity(0.2), thickness: 1),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final List<LedgerEntry> entries;
  final String currency;

  const _SummaryCard({
    required this.entries,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final latest = entries.reduce(
      (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
    );
    final totalDebit = entries.fold<double>(0, (sum, item) => sum + item.debit);
    final totalCredit = entries.fold<double>(0, (sum, item) => sum + item.credit);
    final balance = latest.balanceAfter;
    final isDebtor = balance > 0;
    final isCreditor = balance < 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFC9A227), Color(0xFFE0C35A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC9A227).withOpacity(0.28),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'مانده فعلی',
                style: TextStyle(
                  color: Color(0xFF4E3B12),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${LedgerFormat.digits(entries.length.toString())} تراکنش',
                style: const TextStyle(
                  color: Color(0xFF5A4718),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${LedgerFormat.money(balance.abs())} $currency',
            style: const TextStyle(
              color: Color(0xFF2B1F08),
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isDebtor
                ? 'وضعیت: بدهکار'
                : isCreditor
                    ? 'وضعیت: بستانکار'
                    : 'وضعیت: تسویه',
            style: TextStyle(
              color: isDebtor
                  ? const Color(0xFF8B1E1E)
                  : isCreditor
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF4E3B12),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _miniStat(
                  title: 'جمع بدهکار',
                  value: '${LedgerFormat.money(totalDebit)} $currency',
                  color: const Color(0xFF8B1E1E),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _miniStat(
                  title: 'جمع بستانکار',
                  value: '${LedgerFormat.money(totalCredit)} $currency',
                  color: const Color(0xFF1B5E20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4E3B12),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final LedgerEntry entry;
  final String currency;

  const _EntryCard({
    required this.entry,
    required this.currency,
  });

  Color get _accentColor {
    if (entry.hasDebit && !entry.hasCredit) {
      return const Color(0xFFC62828);
    }
    if (entry.hasCredit && !entry.hasDebit) {
      return const Color(0xFF2E7D32);
    }
    return const Color(0xFFC9A227);
  }

  Color get _cardColor {
    if (entry.hasDebit && !entry.hasCredit) {
      return const Color(0xFFE7D3C4);
    }
    if (entry.hasCredit && !entry.hasDebit) {
      return const Color(0xFFD3E2D4);
    }
    return const Color(0xFFE2D8C4);
  }

  Color get _chipColor {
    switch (entry.operationType.trim().toLowerCase()) {
      case 'sales':
      case 'sale':
        return const Color(0xFF1565C0);
      case 'general':
        return const Color(0xFF5D4037);
      case 'payment':
      case 'receipt':
        return const Color(0xFF2E7D32);
      case 'return':
      case 'refund':
        return const Color(0xFFEF6C00);
      case 'purchase':
        return const Color(0xFF6A1B9A);
      case 'discount':
        return const Color(0xFF00838F);
      case 'transfer':
        return const Color(0xFF37474F);
      default:
        return const Color(0xFFC9A227);
    }
  }

  String _getPersianOperationType(String type) {
    switch (type.trim().toLowerCase()) {
      case 'sales':
      case 'sale':
        return 'فروش';
      case 'general':
        return 'عمومی';
      case 'payment':
        return 'پرداختی';
      case 'receipt':
        return 'دریافتی';
      case 'return':
      case 'refund':
        return 'مرجوعی';
      case 'purchase':
        return 'خرید';
      case 'discount':
        return 'تخفیف';
      case 'transfer':
        return 'انتقال';
      default:
        return 'سایر';
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoice = LedgerFormat.invoiceNumber(entry);
    final description = LedgerFormat.cleanDescription(entry);
    final balance = entry.balanceAfter;
    final balanceColor = balance > 0
        ? const Color(0xFFB71C1C)
        : balance < 0
            ? const Color(0xFF1B5E20)
            : const Color(0xFF5D5344);
    final balanceStatus = balance > 0
        ? 'بدهکار'
        : balance < 0
            ? 'بستانکار'
            : 'تسویه';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 6, color: _accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _chip(
                          text: _getPersianOperationType(entry.operationType),
                          foreground: _chipColor,
                          background: _chipColor.withOpacity(0.12),
                        ),
                        if (invoice != null) ...[
                          const SizedBox(width: 6),
                          _chip(
                            text: invoice,
                            foreground: const Color(0xFF6D4C00),
                            background: const Color(0xFFFFF3CD),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          LedgerFormat.compactDate(entry.createdAt),
                          style: TextStyle(
                            color: Colors.brown.shade600,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Color(0xFF3E3426),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _amountLine(
                                  label: 'بدهکار',
                                  amount: entry.debit,
                                  activeColor: const Color(0xFFC62828),
                                ),
                              ),
                              Expanded(
                                child: _amountLine(
                                  label: 'بستانکار',
                                  amount: entry.credit,
                                  activeColor: const Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text(
                                'مانده پس از تراکنش: ',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF3E3426),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${LedgerFormat.money(balance.abs())} $currency  ($balanceStatus)',
                                  textAlign: TextAlign.start,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: balanceColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip({
    required String text,
    required Color foreground,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: foreground.withOpacity(0.28)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _amountLine({
    required String label,
    required double amount,
    required Color activeColor,
  }) {
    final isZero = amount == 0;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF4E4538),
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '${LedgerFormat.money(amount)} $currency',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: isZero ? Colors.grey.shade600 : activeColor,
            ),
          ),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
