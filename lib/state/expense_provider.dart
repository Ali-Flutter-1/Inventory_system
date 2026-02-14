import 'package:flutter/foundation.dart';

class ExpenseModel {
  ExpenseModel({
    required this.id,
    required this.amount,
    required this.currency,
    required this.description,
    this.employeeId,
    this.employeeName,
    this.category,
    required this.date,
    this.paymentMethod,
    this.receiptImagePath,
    this.vendor,
    this.isRecurring = false,
    this.notes,
  });

  final String id;
  final double amount;
  final String currency;
  final String description;
  final String? employeeId;
  final String? employeeName;
  final String? category;
  final DateTime date;
  final String? paymentMethod;
  final String? receiptImagePath;
  final String? vendor;
  final bool isRecurring;
  final String? notes;
}

class ExpenseProvider with ChangeNotifier {
  final List<ExpenseModel> _expenses = [];

  List<ExpenseModel> get expenses => List.unmodifiable(_expenses);

  double get totalExpenses =>
      _expenses.fold(0, (sum, e) => sum + e.amount);

  void setExpenses(List<ExpenseModel> list) {
    _expenses.clear();
    _expenses.addAll(list);
    notifyListeners();
  }

  void addExpense(ExpenseModel e) {
    _expenses.add(e);
    notifyListeners();
  }

  void updateExpense(ExpenseModel e) {
    final i = _expenses.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      _expenses[i] = e;
      notifyListeners();
    }
  }

  ExpenseModel? getById(String id) {
    try {
      return _expenses.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
