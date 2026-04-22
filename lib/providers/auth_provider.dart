import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  bool _initialized = false;
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get initialized => _initialized;
  String get username => _username;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _isLoggedIn = true;
        String name =
            user.displayName ?? user.email ?? '';
        if (name.contains('@wardrobe.app')) {
          name = name.split('@')[0];
        }
        _username = name;
      } else {
        _isLoggedIn = false;
        _username = '';
      }
      _initialized = true;
      notifyListeners();
    });
  }

  Future<bool> login(
      String username, String password) async {
    try {
      final email = '$username@wardrobe.app';
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login: ${e.code}');
      return false;
    }
  }

  Future<bool> register(
      String username, String password) async {
    try {
      final email = '$username@wardrobe.app';
      final cred =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password.trim(),
      );
      await cred.user?.updateDisplayName(username);
      return true;
    } on FirebaseAuthException catch (e) {
      debugPrint('Register: ${e.code}');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}