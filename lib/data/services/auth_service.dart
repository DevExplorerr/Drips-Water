import 'package:drips_water/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthService> authService = ValueNotifier(
  AuthService(AuthRepository()),
);

class AuthService {
  final AuthRepository _authRepo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthService(this._authRepo);

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  static bool get isGuestUser {
    final user = FirebaseAuth.instance.currentUser;
    return user == null || user.isAnonymous;
  }

  // bool get isGuestUser => currentUser == null || currentUser!.isAnonymous;

  // Sign up with email, password and username
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userCredential.user != null) {
      await _authRepo.saveUserData(
        uid: userCredential.user!.uid,
        userName: userName,
        email: email,
      );
    }
    return userCredential;
  }

  // Login with email and password
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Reset password with email
  Future<void> resetPasswordWithEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
