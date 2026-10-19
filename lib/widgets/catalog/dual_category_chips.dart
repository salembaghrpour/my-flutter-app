// lib/widgets/catalog/dual_category_chips.dart
import 'package:flutter/material.dart';
import '../../models/catalog/category.dart';

class DualCategoryChips extends StatelessWidget {
  final List<ProductCategory> mainCategories;
  final ProductCategory? selectedMain;
  final ProductCategory? selectedSub;
  final ProductCategory? selectedLeaf;
  final ValueChanged<ProductCategory?> onMainSelected;
  final ValueChanged<ProductCategory?> onSubSelected;
  final ValueChanged<ProductCategory?> onLeafSelected;

  const DualCategoryChips({
    super.key,
    required this.mainCategories,
    required this.selectedMain,
    required this.selectedSub,
    required this.selectedLeaf,
    required this.onMainSelected,
    required this.onSubSelected,
    required this.onLeafSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (mainCategories.isEmpty) return const SizedBox.shrink();

    final subCategories = selectedMain?.children ?? const <ProductCategory>[];
    final leafCategories = selectedSub?.children ?? const <ProductCategory>[];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _chipRow(
          items: mainCategories,
          selected: selectedMain,
          allLabel: 'همه',
          onAll: () => onMainSelected(null),
          onItem: onMainSelected,
        ),
        if (subCategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          _chipRow(
            items: subCategories,
            selected: selectedSub,
            allLabel: 'همه موارد',
            compact: true,
            onAll: () => onSubSelected(null),
            onItem: onSubSelected,
          ),
        ],
        if (leafCategories.isNotEmpty) ...[
          const SizedBox(height: 8),
          _chipRow(
            items: leafCategories,
            selected: selectedLeaf,
            allLabel: 'همه این گروه',
            compact: true,
            onAll: () => onLeafSelected(null),
            onItem: onLeafSelected,
          ),
        ],
        const SizedBox(height: 4),
      ],
    );
  }

  Widget _chipRow({
    required List<ProductCategory> items,
    required ProductCategory? selected,
    required String allLabel,
    required VoidCallback onAll,
    required ValueChanged<ProductCategory> onItem,
    bool compact = false,
  }) {
    return SizedBox(
      height: compact ? 40 : 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: items.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ChoiceChip(
              label: Text(allLabel),
              selected: selected == null,
              showCheckmark: false,
              selectedColor: compact ? Colors.blue.shade100 : null,
              backgroundColor: compact ? Colors.grey.shade100 : null,
              onSelected: (_) => onAll(),
            );
          }

          final category = items[index - 1];
          return ChoiceChip(
            label: Text(category.name),
            selected: selected?.id == category.id,
            showCheckmark: false,
            selectedColor: compact ? Colors.blue.shade100 : null,
            backgroundColor: compact ? Colors.grey.shade100 : null,
            onSelected: (_) => onItem(category),
          );
        },
      ),
    );
  }
}
