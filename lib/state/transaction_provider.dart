import 'package:flutter/foundation.dart';

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    this.unitPrice,
    this.unitSellingPrice,
    this.reference,
    this.notes,
    required this.createdAt,
  });

  final String id;
  final String productId;
  final String productName;
  final String type; // IN | OUT
  final double quantity;
  /// Unit cost (for IN: purchase price; for OUT: avg cost at time of OUT).
  final double? unitPrice;
  /// For OUT only: price per unit actually charged (e.g. discount sale).
  final double? unitSellingPrice;
  final String? reference;
  final String? notes;
  final DateTime createdAt;
}

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

  /// Total profit/loss from all OUT transactions that have selling price recorded.
  /// Profit = quantity × (unitSellingPrice - unitPrice) for each OUT.
  double get totalProfit {
    return _transactions
        .where((t) =>
            t.type == 'OUT' &&
            t.unitPrice != null &&
            t.unitSellingPrice != null)
        .fold<double>(
            0,
            (sum, t) =>
                sum + t.quantity * (t.unitSellingPrice! - t.unitPrice!));
  }

  /// Profit/loss for a single product (from its OUT transactions with selling price).
  double profitForProduct(String productId) {
    return _transactions
        .where((t) =>
            t.productId == productId &&
            t.type == 'OUT' &&
            t.unitPrice != null &&
            t.unitSellingPrice != null)
        .fold<double>(
            0,
            (sum, t) =>
                sum + t.quantity * (t.unitSellingPrice! - t.unitPrice!));
  }

  void setTransactions(List<TransactionModel> list) {
    _transactions.clear();
    _transactions.addAll(list);
    notifyListeners();
  }

  void addTransaction(TransactionModel t) {
    _transactions.insert(0, t);
    notifyListeners();
  }
}
