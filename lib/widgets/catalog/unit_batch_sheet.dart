// lib/widgets/catalog/unit_batch_sheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cart_controller.dart';
import '../../controllers/currency_controller.dart';
import '../../models/catalog/catalog_detail.dart';
import '../../models/catalog/product_summary.dart';
import '../../services/catalog/catalog_api.dart';

Future<bool> showUnitBatchSheet(BuildContext context, ProductSummary product) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _UnitBatchSheet(product: product),
  );
  return result == true;
}

class _UnitBatchSheet extends StatefulWidget {
  final ProductSummary product;
  const _UnitBatchSheet({required this.product});

  @override
  State<_UnitBatchSheet> createState() => _UnitBatchSheetState();
}

class _UnitBatchSheetState extends State<_UnitBatchSheet> {
  final _api = CatalogApi();
  final CurrencyController _currencyController = CurrencyController.instance;
  CatalogDetail? _detail;
  bool _loading = true;
  int _unitIndex = 0;
  int? _batchIndex;
  double _qty = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final detail = await _api.fetchProduct(widget.product.id);
    if (!mounted) return;
    if (detail == null) {
      setState(() => _loading = false);
      return;
    }
    final defaultUnit = detail.units.indexWhere((u) => u.isDefaultForSale);
    setState(() {
      _detail = detail;
      _unitIndex = defaultUnit >= 0 ? defaultUnit : 0;
      _batchIndex = detail.batches.isNotEmpty ? 0 : null;
      _qty = detail.units.isNotEmpty ? detail.units[_unitIndex].minOrderQty : 1;
      _loading = false;
    });
  }

  CatalogUnit? get _unit {
    if (_detail == null || _detail!.units.isEmpty) return null;
    return _detail!.units[_unitIndex];
  }

  CatalogBatch? get _batch {
    if (_detail == null || _batchIndex == null) return null;
    return _detail!.batches[_batchIndex!];
  }

  // === منطق جدید محاسبه قیمت با پشتیبانی از قیمت‌های اختصاصی بچ-واحد ===
  double get _unitPrice {
    final unit = _unit;
    if (unit == null) return widget.product.displayPrice;
    
    final batch = _batch;
    // اگر بچی انتخاب نشده باشد، همان قیمت عادی واحد برمی‌گردد
    if (batch == null) return unit.sellingPrice;

    // ۱. اولویت اول: بررسی وجود قیمت اختصاصی برای ترکیب این بچ و این واحد
    // (اطمینان حاصل کنید که unitPrices را در مدل CatalogBatch اضافه کرده‌اید)
    if (batch.unitPrices != null && batch.unitPrices!.isNotEmpty) {
      for (var bup in batch.unitPrices!) {
        if (bup.unitId == unit.unitId && bup.sellingPrice > 0) {
          return bup.sellingPrice; // یافتن قیمت دقیق از دیتابیس
        }
      }
    }

    // ۲. اولویت دوم: در صورت عدم وجود قیمت اختصاصی، استفاده از فرمول تبدیلی
    if (batch.baseSellingPrice == null) return unit.sellingPrice;
    return batch.baseSellingPrice! * unit.conversionToBase;
  }

  void _changeQty(double delta) {
    final unit = _unit;
    final minQty = unit?.minOrderQty ?? 1;
    final next = _qty + delta;
    if (next < minQty) return;
    if (unit != null && !unit.allowDecimalQty && next != next.roundToDouble()) {
      return;
    }
    setState(() => _qty = next);
  }

  void _confirm() {
    if (widget.product.hasBatches && _batch == null) {
      Get.snackbar('خطا', 'برای این کالا انتخاب بچ الزامی است.');
      return;
    }
    final unit = _unit;
    Get.find<CartController>().addToCart({
      'id': widget.product.id,
      'name': widget.product.name,
      'selling_price': _unitPrice, // قیمت محاسبه‌شده دقیق اینجا پاس داده می‌شود
      'quantity': _qty,
      'image_path': widget.product.imagePath,
      'unit_id': unit?.unitId ?? 0,
      'unit_name': unit?.unitName ?? widget.product.baseUnitName ?? 'عدد',
      'conversion_to_base': unit?.conversionToBase ?? 1,
      'batch_id': _batch?.id,
      'batch_number': _batch?.batchNumber,
      'expiration_date': _batch?.expirationDate,
    });
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.decimalPattern('fa').format(_unitPrice);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: _loading
          ? const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                if (_detail != null && _detail!.units.length > 1)
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var i = 0; i < _detail!.units.length; i++)
                        ChoiceChip(
                          label: Text(_detail!.units[i].unitName),
                          selected: _unitIndex == i,
                          onSelected: (_) => setState(() => _unitIndex = i),
                        ),
                    ],
                  ),
                if (_detail != null && _detail!.batches.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'انتخاب بچ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var i = 0; i < _detail!.batches.length; i++)
                        ChoiceChip(
                          label: Text(
                            _detail!.batches[i].expirationDate == null
                                ? _detail!.batches[i].batchNumber
                                : '${_detail!.batches[i].batchNumber} / ${_detail!.batches[i].expirationDate}',
                          ),
                          selected: _batchIndex == i,
                          onSelected: (_) => setState(() => _batchIndex = i),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => _changeQty(-(_unit?.qtyStep ?? 1)),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '$_qty',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _changeQty(_unit?.qtyStep ?? 1),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                    const Spacer(),
                    Obx(() {
                      final currencyLabel = _currencyController.currencyLabel;
                      return Text(
                        '$price $currencyLabel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w900,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _confirm,
                  child: const Text('افزودن به سبد'),
                ),
              ],
            ),
    );
  }
}
