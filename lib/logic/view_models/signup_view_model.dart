import 'package:drips_water/logic/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  bool obscureText = true;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register({
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final userName = userNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    final validation = _validate(userName, email, password);
    if (validation != null) {
      errorMessage = validation;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      await authService.value.signUp(
        email: email,
        password: password,
        userName: userName,
      );
      onSuccess();
    } on FirebaseAuthException catch (e) {
      final errorMsg = _getFirebaseAuthErrorMessage(e);
      errorMessage = errorMsg;
      notifyListeners();
      onError(errorMsg);
    } catch (_) {
      const errorMsg = "Unexpected error occurred. Try again later.";
      onError(errorMsg);
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
