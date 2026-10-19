// lib/widgets/catalog/category_tree_sheet.dart
import 'package:flutter/material.dart';
import '../../models/catalog/category.dart';

Future<void> showCategoryTreeSheet({
  required BuildContext context,
  required List<ProductCategory> categories,
  ProductCategory? selected,
  required ValueChanged<ProductCategory?> onSelected,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return CategoryTreeSheet(
        categories: categories,
        selected: selected,
        onSelected: onSelected,
      );
    },
  );
}

class CategoryTreeSheet extends StatefulWidget {
  final List<ProductCategory> categories;
  final ProductCategory? selected;
  final ValueChanged<ProductCategory?> onSelected;

  const CategoryTreeSheet({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  State<CategoryTreeSheet> createState() => _CategoryTreeSheetState();
}

class _CategoryTreeSheetState extends State<CategoryTreeSheet> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _expandedIds = <int>{};

  @override
  void initState() {
    super.initState();
    _expandSelectedPath(widget.categories, widget.selected);
    if (widget.categories.length <= 8) {
      for (final category in widget.categories) {
        if (category.hasChildren) {
          _expandedIds.add(category.id);
        }
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _expandSelectedPath(
    List<ProductCategory> nodes,
    ProductCategory? selected,
  ) {
    if (selected == null) return false;
    for (final node in nodes) {
      if (node.id == selected.id) return true;
      if (_expandSelectedPath(node.children, selected)) {
        _expandedIds.add(node.id);
        return true;
      }
    }
    return false;
  }

  List<ProductCategory> _visibleTree() {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return widget.categories;
    return _filterTree(widget.categories, query);
  }

  List<ProductCategory> _filterTree(
    List<ProductCategory> nodes,
    String query,
  ) {
    final result = <ProductCategory>[];
    for (final node in nodes) {
      final selfMatch = node.name.toLowerCase().contains(query);
      final matchedChildren = _filterTree(node.children, query);
      if (selfMatch || matchedChildren.isNotEmpty) {
        result.add(
          node.copyWith(
            children: selfMatch ? node.children : matchedChildren,
          ),
        );
      }
    }
    return result;
  }

  void _toggleExpanded(int id) {
    setState(() {
      if (_expandedIds.contains(id)) {
        _expandedIds.remove(id);
      } else {
        _expandedIds.add(id);
      }
    });
  }

  void _select(ProductCategory? category) {
    widget.onSelected(category);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final visible = _visibleTree();
    final isSearching = _searchController.text.trim().isNotEmpty;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
        child: Container(
          height: media.size.height * 0.78,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'دسته‌بندی محصولات',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'بستن',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'جستجوی گروه یا زیرگروه...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              icon: const Icon(Icons.clear),
                            ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: visible.isEmpty
                      ? const Center(child: Text('دسته‌ای با این نام پیدا نشد.'))
                      : ListView(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 20),
                          children: [
                            _AllCategoriesTile(
                              selected: widget.selected == null,
                              onTap: () => _select(null),
                            ),
                            const SizedBox(height: 4),
                            ...visible.map(
                              (category) => _CategoryNode(
                                category: category,
                                depth: 0,
                                selectedId: widget.selected?.id,
                                forceExpand: isSearching,
                                expandedIds: _expandedIds,
                                onToggle: _toggleExpanded,
                                onSelect: _select,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AllCategoriesTile extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const _AllCategoriesTile({
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: selected
          ? theme.colorScheme.primary.withOpacity(0.10)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(
          Icons.apps_rounded,
          color: selected ? theme.colorScheme.primary : Colors.grey[700],
        ),
        title: Text(
          'همه دسته‌ها',
          style: TextStyle(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? theme.colorScheme.primary : null,
          ),
        ),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
            : null,
      ),
    );
  }
}

class _CategoryNode extends StatelessWidget {
  final ProductCategory category;
  final int depth;
  final int? selectedId;
  final bool forceExpand;
  final Set<int> expandedIds;
  final ValueChanged<int> onToggle;
  final ValueChanged<ProductCategory> onSelect;

  const _CategoryNode({
    required this.category,
    required this.depth,
    required this.selectedId,
    required this.forceExpand,
    required this.expandedIds,
    required this.onToggle,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = category.id == selectedId;
    final expanded = forceExpand || expandedIds.contains(category.id);
    final childCount = category.children.length;

    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: depth * 14.0),
          child: Material(
            color: selected
                ? theme.colorScheme.primary.withOpacity(0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => onSelect(category),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 36,
                      child: category.hasChildren
                          ? IconButton(
                              visualDensity: VisualDensity.compact,
                              tooltip: expanded ? 'بستن' : 'باز کردن',
                              onPressed: () => onToggle(category.id),
                              icon: Icon(
                                expanded
                                    ? Icons.expand_more_rounded
                                    : Icons.chevron_left_rounded,
                              ),
                            )
                          : Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.grey[400],
                            ),
                    ),
                    Icon(
                      category.hasChildren
                          ? (expanded
                              ? Icons.folder_open_rounded
                              : Icons.folder_rounded)
                          : Icons.label_outline_rounded,
                      size: 22,
                      color: selected
                          ? theme.colorScheme.primary
                          : Colors.grey[700],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: TextStyle(
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                              color: selected ? theme.colorScheme.primary : null,
                            ),
                          ),
                          if (category.hasChildren)
                            Text(
                              '$childCount زیرگروه',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (selected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.colorScheme.primary,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (category.hasChildren && expanded)
          ...category.children.map(
            (child) => _CategoryNode(
              category: child,
              depth: depth + 1,
              selectedId: selectedId,
              forceExpand: forceExpand,
              expandedIds: expandedIds,
              onToggle: onToggle,
              onSelect: onSelect,
            ),
          ),
      ],
    );
  }
}
