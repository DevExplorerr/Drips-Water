import 'dart:async';
import 'package:drips_water/presentation/widgets/dialog/custom_login_prompt_dialog.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  StreamSubscription<QuerySnapshot>? _favSub;
  StreamSubscription<User?>? _authSub;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool isFavorite(String productId) => _favorites.contains(productId);

  FavoriteProvider() {
    // Listen to auth state
    _authSub = _auth.authStateChanges().listen(_onAuthStateChanged);
    final user = _auth.currentUser;
    if (user != null) _attachFavoritesListener(user.uid);
  }

  // when authentication changes (login or logout)
  void _onAuthStateChanged(User? user) {
    _favSub?.cancel();

    if (user == null) {
      _favorites.clear();
      notifyListeners();
      return;
    }

    _attachFavoritesListener(user.uid);
  }

  // real time listener for firestore favorites
  void _attachFavoritesListener(String uid) {
    final favRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites');

    // Listen in real-time; keeps _favorites in sync across devices
    _favSub = favRef.snapshots().listen((snapshot) {
      _favorites
        ..clear()
        ..addAll(snapshot.docs.map((doc) => doc.id));
      notifyListeners();
    });
  }

  // Toggle favorite in local cache and persist to Firestore for the current user.
  Future<void> toggleFavorite(String productId, BuildContext context) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      showDialog(
        context: context,
        barrierDismissible: true,
        animationStyle: AnimationStyle(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 300),
          reverseDuration: const Duration(milliseconds: 200),
        ),
        builder: (context) => const CustomLoginPromptDialog(),
      );
      return;
    }

    final favRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(productId);

    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
      notifyListeners();
      await favRef.delete();
    } else {
      _favorites.add(productId);
      notifyListeners();
      await favRef.set({'timestamp': FieldValue.serverTimestamp()});
    }
  }

  @override
  void dispose() {
    _favSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}

// Would you like me to extend this system to include real-time Firestore sync (so if user favorites from another device, it updates automatically too)?
// Would you like me to show how to extend this to show all favorited products in a “Favorites Screen” next? (It will reuse the same Provider, no extra Firestore reads.)
