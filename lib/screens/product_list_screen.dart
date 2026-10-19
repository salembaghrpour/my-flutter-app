// lib/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/catalog/product_summary.dart';
import '../models/catalog/category.dart';
import '../services/product_service.dart';
import '../widgets/catalog/category_tree_sheet.dart';
import '../widgets/catalog/unit_batch_sheet.dart';
import '../widgets/product_card.dart';
import '../controllers/ui_controller.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CartController cartController = Get.find<CartController>();
  final UIController uiController = Get.put(UIController());
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  List<ProductSummary> _allProducts = [];
  List<ProductCategory> _mainCategories = [];
  List<ProductSummary> _filteredProducts = [];

  ProductCategory? _selectedCategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.fetchProducts();
      final categories = await _productService.fetchCategories();

      setState(() {
        _allProducts = products;
        _mainCategories = categories;
        _selectedCategory = _findInTree(categories, _selectedCategory?.id);
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('خطا', 'مشکل در دریافت اطلاعات: $e');
    }
  }

  ProductCategory? _findInTree(List<ProductCategory> items, int? id) {
    if (id == null) return null;
    for (final item in items) {
      if (item.id == id) return item;
      final found = _findInTree(item.children, id);
      if (found != null) return found;
    }
    return null;
  }

  List<String> _selectedPathNames() {
    final selected = _selectedCategory;
    if (selected == null) return const [];

    final path = <ProductCategory>[];

    bool walk(List<ProductCategory> nodes) {
      for (final node in nodes) {
        if (node.id == selected.id) {
          path.add(node);
          return true;
        }
        if (walk(node.children)) {
          path.insert(0, node);
          return true;
        }
      }
      return false;
    }

    walk(_mainCategories);
    return path.map((item) => item.name).toList();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesQuery = query.isEmpty || product.name.toLowerCase().contains(query);
        return matchesQuery && _matchesSelectedCategory(product);
      }).toList();
    });
  }

  bool _matchesSelectedCategory(ProductSummary product) {
    final selected = _selectedCategory;
    if (selected == null) return true;
    return product.categoryName == selected.name;
  }

  void _clearCategory() {
    setState(() => _selectedCategory = null);
    _applyFilters();
  }

  Future<void> _openCategorySheet() async {
    if (_mainCategories.isEmpty) {
      Get.snackbar('توجه', 'هنوز دسته‌بندی‌ای دریافت نشده است.');
      return;
    }

    await showCategoryTreeSheet(
      context: context,
      categories: _mainCategories,
      selected: _selectedCategory,
      onSelected: (category) {
        setState(() => _selectedCategory = category);
        _applyFilters();
      },
    );
  }

  Future<void> _onAddToCart(ProductSummary product) async {
    final productMap = product.toJson();

    if (productMap['needsOptions'] == true) {
      await showUnitBatchSheet(context, product);
      return;
    }

    cartController.addToCart(productMap);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _applyFilters(),
            decoration: const InputDecoration(
              hintText: 'جستجوی نام کالا...',
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
          ),
        ),
        _buildCategoryBar(),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _fetchData,
                  child: _filteredProducts.isEmpty
                      ? _buildEmptyState()
                      : Obx(() => uiController.showImages.value
                          ? _buildGridView()
                          : _buildListView()),
                ),
        ),
      ],
    );
  }

  Widget _buildCategoryBar() {
    final selected = _selectedCategory;
    final path = _selectedPathNames();

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: selected == null
                  ? Colors.grey[100]
                  : Theme.of(context).colorScheme.primary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _openCategorySheet,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      Icon(Icons.account_tree_rounded,
                          color: selected == null
                              ? Colors.grey[700]
                              : Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected?.name ?? 'دسته‌بندی‌ها',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: selected == null
                                    ? Colors.black87
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if (path.isNotEmpty)
                              Text(
                                path.join(' / '),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey[600]),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (selected != null) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: _clearCategory,
              icon: const Icon(Icons.close_rounded),
              tooltip: 'حذف فیلتر',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.55,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('محصولی یافت نشد'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh),
              label: const Text('تلاش مجدد'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) => ProductGridCard(
          product: _filteredProducts[index],
          onAddToCart: () => _onAddToCart(_filteredProducts[index]),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) => ProductListCard(
        product: _filteredProducts[index],
        onAddToCart: () => _onAddToCart(_filteredProducts[index]),
      ),
    );
  }
}
