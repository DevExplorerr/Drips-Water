import 'package:drips_water/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  // For inline validation messages
  String? validationError;
  // For Firebase/Auth errors
  String? authError;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<bool> resetPasswordWithEmail() async {
    final email = emailController.text.trim();

    final validationMsg = _validate(email);
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
      await authService.value.resetPasswordWithEmail(email: email);
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

  String? _validate(String email) {
    if (email.isEmpty) {
      return "Please enter your email address.";
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
      case 'invalid-email':
        return "Invalid email format.";
      case 'too-many-requests':
        return "Too many signup attempts. Try again later.";
      default:
        return "Authentication failed. Please check your credentials.";
    }
  }
}
