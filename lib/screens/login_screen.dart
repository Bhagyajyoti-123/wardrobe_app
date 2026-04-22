import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLogin = true;
  bool _obscure = true;
  bool _loading = false;
  String _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF),
                  borderRadius:
                      BorderRadius.circular(24),
                ),
                child: const Icon(
                    Icons.checkroom_rounded,
                    size: 56,
                    color: Colors.white),
              ),
              const SizedBox(height: 24),
              const Text('My Wardrobe',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF))),
              const SizedBox(height: 8),
              Text(
                _isLogin
                    ? 'Welcome back!'
                    : 'Create your account',
                style: const TextStyle(
                    color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameCtrl,
                      decoration: _inputDec('Username',
                          Icons.person_outline),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordCtrl,
                      obscureText: _obscure,
                      decoration: _inputDec('Password',
                              Icons.lock_outline)
                          .copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_obscure
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () => setState(() =>
                              _obscure = !_obscure),
                        ),
                      ),
                    ),
                    if (_errorMsg.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10),
                        child: Text(_errorMsg,
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12)),
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF6C63FF),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      14)),
                        ),
                        onPressed:
                            _loading ? null : _submit,
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                _isLogin
                                    ? 'Login'
                                    : 'Register',
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() {
                        _isLogin = !_isLogin;
                        _errorMsg = '';
                      }),
                      child: Text(
                        _isLogin
                            ? "Don't have an account? Register"
                            : 'Already have an account? Login',
                        style: const TextStyle(
                            color: Color(0xFF6C63FF),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDec(
          String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: Colors.grey.shade200)),
      );

  Future<void> _submit() async {
    if (_usernameCtrl.text.trim().isEmpty ||
        _passwordCtrl.text.trim().isEmpty) {
      setState(
          () => _errorMsg = 'Please fill all fields');
      return;
    }
    if (_passwordCtrl.text.trim().length < 6) {
      setState(() => _errorMsg =
          'Password must be at least 6 characters');
      return;
    }
    setState(() {
      _loading = true;
      _errorMsg = '';
    });
    final auth =
        Provider.of<AuthProvider>(context, listen: false);
    bool ok;
    if (_isLogin) {
      ok = await auth.login(_usernameCtrl.text.trim(),
          _passwordCtrl.text.trim());
      if (!ok && mounted) {
        setState(() =>
            _errorMsg = 'Invalid username or password');
      }
    } else {
      ok = await auth.register(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text.trim());
      if (!ok && mounted) {
        setState(() =>
            _errorMsg = 'Username taken or error occurred');
      }
    }
    if (mounted) setState(() => _loading = false);
  }
}