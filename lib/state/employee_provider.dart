import 'package:flutter/foundation.dart';

class EmployeeModel {
  EmployeeModel({
    required this.id,
    required this.name,
    this.employeeId,
    this.phone,
    this.email,
    this.department,
    this.position,
    this.salary,
    this.joiningDate,
    this.profileImagePath,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? employeeId;
  final String? phone;
  final String? email;
  final String? department;
  final String? position;
  final double? salary;
  final String? joiningDate;
  final String? profileImagePath;
  final bool isActive;
}

class EmployeeProvider with ChangeNotifier {
  final List<EmployeeModel> _employees = [];

  List<EmployeeModel> get employees =>
      List.unmodifiable(_employees.where((e) => e.isActive));

  void setEmployees(List<EmployeeModel> list) {
    _employees.clear();
    _employees.addAll(list);
    notifyListeners();
  }

  void addEmployee(EmployeeModel e) {
    _employees.add(e);
    notifyListeners();
  }

  void updateEmployee(EmployeeModel e) {
    final i = _employees.indexWhere((x) => x.id == e.id);
    if (i >= 0) {
      _employees[i] = e;
      notifyListeners();
    }
  }

  EmployeeModel? getById(String id) {
    try {
      return _employees.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
