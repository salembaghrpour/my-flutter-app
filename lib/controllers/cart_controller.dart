
// lib/controllers/cart_controller.dart
import 'package:get/get.dart';
import '../models/cart/cart_line.dart';

class CartController extends GetxController {
  final cartLines = <CartLine>[].obs;

  List<Map<String, dynamic>> get cartItems => cartLines.map((line) {
        final item = <String, dynamic>{
          'id': line.productId,
          'name': line.productName,
          'selling_price': line.unitPrice,
          'price': line.unitPrice,
          'unit_price': line.unitPrice,
          'quantity': line.quantity,
          'unit_name': line.unitName,
          'batch_number': line.batchNumber,
          'expiration_date': line.expirationDate,
          'image_path': line.imagePath,
          'conversion_to_base': line.conversionToBase,
          'size_label': line.sizeLabel,
        };

        final unitId = line.validUnitId;
        if (unitId != null) {
          item['unit_id'] = unitId;
        }

        final batchId = _sanitizeUnitId(line.batchId);
        if (batchId != null) {
          item['batch_id'] = batchId;
        }

        return item;
      }).toList();

  int get totalItemsCount => cartLines.fold<int>(
        0,
        (sum, line) => sum + _asWholeQty(line.quantity),
      );

  double get totalPrice => cartLines.fold<double>(
        0,
        (sum, line) => sum + (line.unitPrice * _asWholeQty(line.quantity)),
      );

  @override
  void onInit() {
    super.onInit();
    _normalizeLines();
  }

  @override
  void onReady() {
    super.onReady();
    _normalizeLines();
  }

  void addLine(CartLine line) {
    final cleanUnitId = _sanitizeUnitId(line.unitId);
    final cleanBatchId = _sanitizeUnitId(line.batchId);

    final incoming = CartLine(
      productId: line.productId,
      productName: line.productName,
      unitId: cleanUnitId,
      unitName: line.unitName,
      batchId: cleanBatchId,
      batchNumber: line.batchNumber,
      expirationDate: line.expirationDate,
      quantity: _asWholeQty(line.quantity).toDouble(),
      unitPrice: line.unitPrice > 0 ? line.unitPrice : 0.0,
      conversionToBase: line.conversionToBase > 0 ? line.conversionToBase : 1,
      imagePath: line.imagePath,
      sizeLabel: line.sizeLabel,
    );

    final index = cartLines.indexWhere((e) => e.lineKey == incoming.lineKey);
    if (index == -1) {
      cartLines.add(incoming);
      return;
    }

    final current = cartLines[index];
    final nextUnitId = incoming.validUnitId ?? current.validUnitId;
    cartLines[index] = current.copyWith(
      quantity: (_asWholeQty(current.quantity) + _asWholeQty(incoming.quantity))
          .toDouble(),
      unitPrice:
          incoming.unitPrice > 0 ? incoming.unitPrice : current.unitPrice,
      unitId: nextUnitId,
      clearUnitId: nextUnitId == null,
    );
  }

  void addToCart(Map<String, dynamic> product) {
    addLine(CartLine(
      productId: _asInt(product['id'] ?? product['product_id']),
      productName:
          (product['name'] ?? product['product_name'] ?? '').toString(),
      unitId: _extractUnitId(product),
      unitName: (product['unit_name'] ??
              product['base_unit_name'] ??
              product['baseUnitName'] ??
              'عدد')
          .toString(),
      batchId: _asNullableInt(product['batch_id'] ?? product['batchId']),
      batchNumber: product['batch_number'] as String? ??
          product['batchNumber'] as String?,
      expirationDate: product['expiration_date'] as String? ??
          product['expirationDate'] as String?,
      quantity: _extractQuantity(product),
      unitPrice: _extractUnitPrice(product),
      conversionToBase: _parseNumber(
        product['conversion_to_base'] ?? product['conversionToBase'],
        fallback: 1,
      ),
      imagePath:
          product['image_path'] as String? ?? product['imagePath'] as String?,
      sizeLabel:
          product['size_label'] as String? ?? product['sizeLabel'] as String?,
    ));
  }

  void increaseQuantity(Map<String, dynamic> product) {
    final key = _keyOf(product);
    final index = cartLines.indexWhere((e) => e.lineKey == key);
    if (index == -1) {
      addToCart({...product, 'quantity': 1});
      return;
    }
    final current = cartLines[index];
    cartLines[index] = current.copyWith(
      quantity: (_asWholeQty(current.quantity) + 1).toDouble(),
    );
  }

  void removeFromCart(Map<String, dynamic> product) {
    final key = _keyOf(product);
    final index = cartLines.indexWhere((e) => e.lineKey == key);
    if (index == -1) return;
    final currentQty = _asWholeQty(cartLines[index].quantity);
    if (currentQty > 1) {
      cartLines[index] =
          cartLines[index].copyWith(quantity: (currentQty - 1).toDouble());
    } else {
      cartLines.removeAt(index);
    }
  }

  void updateQuantity(Map<String, dynamic> product, num quantity) {
    final key = _keyOf(product);
    final whole = _asWholeQty(quantity);
    if (whole <= 0) {
      cartLines.removeWhere((e) => e.lineKey == key);
      return;
    }
    final index = cartLines.indexWhere((e) => e.lineKey == key);
    if (index != -1) {
      cartLines[index] =
          cartLines[index].copyWith(quantity: whole.toDouble());
    }
  }

  List<Map<String, dynamic>> toOrderItems() {
    return cartLines.map((line) {
      final payload = Map<String, dynamic>.from(line.toOrderPayload());
      payload.removeWhere((key, value) {
        if (key != 'unit_id' && key != 'batch_id') return false;
        if (value == null || value == '' || value == 'null') return true;
        final parsed = value is num ? value.toInt() : int.tryParse('$value');
        return parsed == null || parsed <= 0;
      });
      return payload;
    }).toList();
  }

  void clearCart() => cartLines.clear();

  void _normalizeLines() {
    for (var i = 0; i < cartLines.length; i++) {
      final line = cartLines[i];
      final whole = _asWholeQty(line.quantity).toDouble();
      final unitId = _sanitizeUnitId(line.unitId);
      final batchId = _sanitizeUnitId(line.batchId);
      if (whole != line.quantity ||
          unitId != line.unitId ||
          batchId != line.batchId) {
        cartLines[i] = line.copyWith(
          quantity: whole,
          unitId: unitId,
          clearUnitId: unitId == null,
        );
      }
    }
  }

  String _keyOf(Map<String, dynamic> product) {
    final id = _asInt(product['id'] ?? product['product_id']);
    final unitId = _extractUnitId(product) ?? 0;
    final batchId = _sanitizeUnitId(product['batch_id'] ?? product['batchId']) ?? 0;
    return '$id-$unitId-$batchId';
  }

  int? _extractUnitId(Map<String, dynamic> product) {
    return _sanitizeUnitId(
      product['unit_id'] ??
          product['unitId'] ??
          product['base_unit_id'] ??
          product['baseUnitId'],
    );
  }

  double _extractQuantity(Map<String, dynamic> product) {
    if (!product.containsKey('quantity') || product['quantity'] == null) {
      return 1;
    }
    return _asWholeQty(_parseNumber(product['quantity'], fallback: 1))
        .toDouble();
  }

  double _extractUnitPrice(Map<String, dynamic> product) {
    const keys = [
      'selling_price',
      'unit_price',
      'unitPrice',
      'display_price',
      'displayPrice',
      'price',
      'sale_price',
      'final_price',
      'priceLabel',
      'price_label',
    ];

    for (final key in keys) {
      if (!product.containsKey(key) || product[key] == null) continue;
      final parsed = _parseNumber(product[key]);
      if (parsed > 0) return parsed;
    }
    return 0;
  }

  static int? _sanitizeUnitId(dynamic raw) {
    if (raw == null || raw == '' || raw == 'null') return null;
    final value = _asInt(raw);
    return value > 0 ? value : null;
  }

  static int _asWholeQty(num value) {
    if (value <= 0) return 1;
    if (value < 1) return 1;
    return value.round();
  }

  static String _toEnDigits(String input) {
    const fa = '۰۱۲۳۴۵۶۷۸۹';
    const ar = '٠١٢٣٤٥٦٧٨٩';
    final buffer = StringBuffer();
    for (final rune in input.runes) {
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
    return buffer.toString();
  }

  static double _parseNumber(dynamic raw, {double fallback = 0}) {
    if (raw == null) return fallback;
    if (raw is num) return raw.toDouble();
    var text = _toEnDigits(raw.toString()).trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return fallback;
    text = text
        .replaceAll(',', '')
        .replaceAll('٬', '')
        .replaceAll('،', '')
        .replaceAll(' ', '');
    final match = RegExp(r'-?\d+(?:\.\d+)?').firstMatch(text);
    if (match == null) return fallback;
    return double.tryParse(match.group(0)!) ?? fallback;
  }

  static int _asInt(dynamic raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    return int.tryParse(_toEnDigits('${raw ?? ''}').trim()) ?? 0;
  }

  static int? _asNullableInt(dynamic raw) {
    return _sanitizeUnitId(raw);
  }
}
