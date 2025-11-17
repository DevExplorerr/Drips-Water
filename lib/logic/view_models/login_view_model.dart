import 'package:drips_water/logic/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool obscureText = true;

  // For inline validation messages
  String? validationError;
  // For Firebase/auth errors
  String? authError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<bool> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final validationMsg = _validate(email, password);
    if (validationMsg != null) {
      validationError = validationMsg;
      authError = null;
      notifyListeners();
      return false;
    }

    validationError = null;
    authError = null;
    isLoading = true;
    notifyListeners();

    try {
      await authService.value.login(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      authError = _getFirebaseAuthErrorMessage(e);
      notifyListeners();
      return false;
    } catch (_) {
      authError = "Unexpected error occurred. Try again later.";
      notifyListeners();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }

  String? _validate(String email, String password) {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter email and password";
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Please enter a valid email address.";
    }

    return null;
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "No account found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'user-disabled':
        return "This account has been disabled. Contact support.";
      case 'too-many-requests':
        return "Too many login attempts. Try again later.";
      default:
        return "Authentication failed. Please check your credentials.";
    }
  }
}
