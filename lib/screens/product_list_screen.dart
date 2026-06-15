// lib/screens/product_list_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart'; 
import '../main_screen.dart'; // برای دسترسی به UIController

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CartController cartController = Get.find<CartController>(); 
  final UIController uiController = Get.find<UIController>(); // اتصال به کنترلر نمایش عکس
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProducts() async {
    try {
      final data = await _productService.fetchProducts();
      setState(() {
        _allProducts = data;
        _filteredProducts = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar('خطا', 'مشکل در دریافت محصولات: $e');
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts
            .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // فقط بخش جستجو باقی ماند
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            onChanged: _filterSearchResults,
            decoration: InputDecoration(
              hintText: 'جستجوی نام کالا...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        
        // لیست محصولات حساس به تغییرات UIController
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredProducts.isEmpty
                  ? const Center(child: Text('محصولی یافت نشد.'))
                  : Obx(() => uiController.showImages.value 
                      ? _buildGridView() // نمایش گرید با عکس
                      : _buildListView()), // نمایش لیست بدون عکس
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.70, // کمی فضای بیشتر برای متون و دکمه‌ها
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _filteredProducts.length,
        itemBuilder: (context, index) {
          final product = _filteredProducts[index];
          return ProductGridCard(
            product: product,
            onAddToCart: () => cartController.addToCart(product.toJson()),
          );
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16.0),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return ProductListCard(
          product: product,
          onAddToCart: () => cartController.addToCart(product.toJson()),
        );
      },
    );
  }
}
