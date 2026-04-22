import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
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
      debugPrint('Login error: ${e.code} ${e.message}');
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
      debugPrint(
          'Register error: ${e.code} ${e.message}');
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}