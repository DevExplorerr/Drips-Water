import 'package:drips_water/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;

  // For inline validation messages
  String? validationError;
  // For Firebase/auth errors
  String? authError;

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<bool> register() async {
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final validationMsg = _validate(userName, email, password);
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
      await authService.value.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      authError = _getFirebaseAuthErrorMessage(e);
      return false;
    } catch (_) {
      authError = "Unexpected error occurred. Try again later.";
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String? _validate(String userName, String email, String password) {
    if (userName.isEmpty || email.isEmpty || password.isEmpty) {
      return "Please fill in all fields.";
    }

    if (password.length < 6) return "Password must be at least 6 characters";

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return "Please enter a valid email address.";
    }
    return null;
  }

  String _getFirebaseAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "This email is already registered.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'weak-password':
        return "Password should be at least 6 characters.";
      case 'too-many-requests':
        return "Too many signup attempts. Try again later.";
      default:
        return "Authentication failed. Please check your credentials.";
    }
  }

  void toggleObscureText() {
    obscureText = !obscureText;
    notifyListeners();
  }
}
