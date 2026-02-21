import 'package:flutter/foundation.dart';

/// Placeholder auth state. Replace with Firebase Auth when backend is ready.
class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userId;
  String? _userName;
  String? _companyId;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get userName => _userName;
  String? get companyId => _companyId;
  String? _companyName = 'Demo Company';
  String? get companyName => _companyName;
  String? _companySlogan;
  String? get companySlogan => _companySlogan;
  String? _currency = 'USD';
  String? get currency => _currency;
  String? _companyLogo;
  String? get companyLogo => _companyLogo;

  Future<void> signInWithEmail(String email, String password) async {
    // TODO: Firebase Auth signInWithEmailAndPassword
    _isLoggedIn = true;
    _userId = 'demo_uid';
    _userName = 'Demo User';
    _companyId = 'demo_company';
    notifyListeners();
  }

  Future<void> signUpWithEmail(String email, String password, String name) async {
    // TODO: Firebase Auth createUserWithEmailAndPassword + create company
    _isLoggedIn = true;
    _userId = 'demo_uid';
    _userName = name;
    _companyId = 'demo_company';
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    // TODO: Google Sign-In + Firebase
    _isLoggedIn = true;
    _userId = 'demo_uid';
    _userName = 'Google User';
    _companyId = 'demo_company';
    notifyListeners();
  }

  Future<void> signOut() async {
    _isLoggedIn = false;
    _userId = null;
    _userName = null;
    _companyId = null;
    notifyListeners();
  }

  void setDemoLoggedIn() {
    _isLoggedIn = true;
    _userId = 'demo';
    _userName = 'Demo';
    _companyId = 'demo_company';
    notifyListeners();
  }

  void updateProfile({String? name, String? companyName, String? companySlogan, String? currency, String? logoPath}) {
    if (name != null) _userName = name;
    if (companyName != null) _companyName = companyName;
    if (companySlogan != null) _companySlogan = companySlogan;
    if (currency != null) _currency = currency;
    if (logoPath != null) _companyLogo = logoPath;
    notifyListeners();
  }
}
