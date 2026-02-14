import 'package:flutter/foundation.dart';

class TransactionModel {
  TransactionModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.type,
    required this.quantity,
    this.reference,
    this.notes,
    required this.createdAt,
  });

  final String id;
  final String productId;
  final String productName;
  final String type; // IN | OUT
  final int quantity;
  final String? reference;
  final String? notes;
  final DateTime createdAt;
}

class TransactionProvider with ChangeNotifier {
  final List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => List.unmodifiable(_transactions);

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
