// lib/widgets/product_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';

import '../models/catalog/product_summary.dart';
import '../constants/api_constants.dart';
import '../controllers/currency_controller.dart';

const Color _kAddButtonColor = Color(0xFF7B6CF6);

final CurrencyController _currencyController = Get.find<CurrencyController>();

String _toFaDigits(String input) {
  const en = '0123456789';
  const fa = '۰۱۲۳۴۵۶۷۸۹';
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    final ch = String.fromCharCode(rune);
    final index = en.indexOf(ch);
    buffer.write(index >= 0 ? fa[index] : ch);
  }
  return buffer.toString();
}

String _formatPrice(num value) {
  final digits = value.truncate().toString();
  final reversed = digits.split('').reversed.toList();
  final parts = <String>[];
  for (var i = 0; i < reversed.length; i += 3) {
    final end = i + 3 > reversed.length ? reversed.length : i + 3;
    parts.add(reversed.sublist(i, end).join());
  }
  final grouped = parts.join(',').split('').reversed.join();
  final signed = value < 0 ? '-$grouped' : grouped;
  return _toFaDigits(signed);
}

String _priceText(ProductSummary product) {
  final unit = (product.baseUnitName ?? '').trim();
  final currencySymbol = _currencyController.displaySymbol.isNotEmpty
      ? _currencyController.displaySymbol
      : 'ریال';

  final suffix = unit.isEmpty ? currencySymbol : '$currencySymbol / $unit';

  if (product.displayPrice > 0) {
    final price = _formatPrice(product.displayPrice);
    if (product.hasMultiUnits) {
      return 'از $price $suffix';
    }
    return '$price $suffix';
  }

  final ready = product.priceLabel.trim();
  if (ready.isNotEmpty) {
    final parsedNumeric = double.tryParse(ready);
    if (parsedNumeric != null) {
      final formatted = _formatPrice(parsedNumeric);
      if (product.hasMultiUnits) {
        return 'از $formatted $suffix';
      }
      return '$formatted $suffix';
    }
    return ready;
  }

  return 'نامشخص';
}

String? _cleanText(String? value) {
  final text = value?.trim();
  if (text == null || text.isEmpty) return null;
  final lower = text.toLowerCase();
  if (lower == 'null' || lower == 'undefined') return null;
  return text;
}

class _ProductImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const _ProductImage({
    required this.imagePath,
    this.width = 80,
    this.height = 80,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    String? cleanPath;
    if (imagePath != null && imagePath!.isNotEmpty) {
      final fileName = imagePath!.replaceAll('\\', '/').split('/').last;
      cleanPath = '/photos/$fileName';
    }

    final String? fullUrl = ApiConstants.getImageUrl(cleanPath);
    final double iconSize = height * 0.4;

    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: borderRadius,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: fullUrl == null
              ? Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey.shade300,
                  size: iconSize,
                )
              : CachedNetworkImage(
                  imageUrl: fullUrl,
                  fit: BoxFit.contain,
                  width: width,
                  height: height,
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.broken_image_outlined,
                    color: Colors.grey.shade400,
                    size: iconSize,
                  ),
                ),
        ),
      ),
    );
  }
}

class ProductListCard extends StatefulWidget {
  final ProductSummary product;
  final VoidCallback onAddToCart;
  final bool showImage;

  const ProductListCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.showImage = true,
  });

  @override
  State<ProductListCard> createState() => _ProductListCardState();
}

class _ProductListCardState extends State<ProductListCard> {
  bool _isImageExpanded = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final description = _cleanText(product.description);
    final attributes = product.customAttributes;
    final unit = (product.baseUnitName ?? '').trim();
    final bool hasImage = product.imagePath != null && product.imagePath!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                          ),
                          if (hasImage)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  setState(() {
                                    _isImageExpanded = !_isImageExpanded;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: _isImageExpanded ? Colors.blue.shade50 : Colors.grey.shade100,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isImageExpanded ? Icons.image : Icons.image_outlined,
                                    size: 18,
                                    color: _isImageExpanded ? Colors.blue.shade600 : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ),
                          if (unit.isNotEmpty) ...[
                            _SoftChip(text: unit),
                          ],
                        ],
                      ),
                      if (description != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.4,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      if (attributes.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: attributes
                              .map((item) => _SoftChip(text: item, filled: true))
                              .toList(),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        _priceText(product),
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (product.hasMultiUnits || product.hasBatches) ...[
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            if (product.hasMultiUnits)
                              const _SoftChip(text: 'چند واحدی'),
                            if (product.hasBatches)
                              const _SoftChip(text: 'دارای بچ'),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _AddButton(onPressed: widget.onAddToCart),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isImageExpanded
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Center(
                        child: _ProductImage(
                          imagePath: product.imagePath,
                          width: double.infinity,
                          height: 180,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductGridCard extends StatelessWidget {
  final ProductSummary product;
  final VoidCallback onAddToCart;
  final bool showImage;

  const ProductGridCard({
    super.key,
    required this.product,
    required this.onAddToCart,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    final description = _cleanText(product.description);
    final attributes = product.customAttributes;
    final unit = (product.baseUnitName ?? '').trim();

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showImage)
            _ProductImage(
              imagePath: product.imagePath,
              height: 130,
              width: double.infinity,
              borderRadius: BorderRadius.zero,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            height: 1.3,
                          ),
                        ),
                      ),
                      if (unit.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: _SoftChip(text: unit),
                        ),
                    ],
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  if (attributes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      attributes.join(' • '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.35,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    _priceText(product),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            if (product.hasMultiUnits)
                              const _SoftChip(text: 'چند واحدی'),
                            if (product.hasBatches)
                              const _SoftChip(text: 'دارای بچ'),
                          ],
                        ),
                      ),
                      _AddButton(onPressed: onAddToCart, compact: true),
                    ],
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

class _AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool compact;

  const _AddButton({
    required this.onPressed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 36.0 : 42.0;
    return Material(
      color: _kAddButtonColor.withOpacity(0.18),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            Icons.layers_outlined,
            color: _kAddButtonColor,
            size: compact ? 18 : 22,
          ),
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  final String text;
  final bool filled;

  const _SoftChip({
    required this.text,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFF4F1FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
