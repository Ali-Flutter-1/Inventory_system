import 'package:flutter/foundation.dart';

/// Simple product model for UI. Replace with Firestore when backend is ready.
class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    this.sku,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.stock,
    this.lowStockLimit = 0,
    this.imagePath,
    this.description,
    this.category,
  });

  final String id;
  final String name;
  final String? sku;
  final double purchasePrice;
  final double sellingPrice;
  final int stock;
  final int lowStockLimit;
  final String? imagePath;
  final String? description;
  final String? category;

  bool get isLowStock => lowStockLimit > 0 && stock <= lowStockLimit;
}

class ProductProvider with ChangeNotifier {
  final List<ProductModel> _products = [];

  List<ProductModel> get products => List.unmodifiable(_products);

  List<ProductModel> get lowStockProducts =>
      _products.where((p) => p.isLowStock).toList();

  int get totalProductsCount => _products.length;

  void setProducts(List<ProductModel> list) {
    _products.clear();
    _products.addAll(list);
    notifyListeners();
  }

  void addProduct(ProductModel p) {
    _products.add(p);
    notifyListeners();
  }

  void updateProduct(ProductModel p) {
    final i = _products.indexWhere((e) => e.id == p.id);
    if (i >= 0) {
      _products[i] = p;
      notifyListeners();
    }
  }

  void removeProduct(String id) {
    _products.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  ProductModel? getById(String id) {
    try {
      return _products.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
