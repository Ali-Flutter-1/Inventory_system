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
}
