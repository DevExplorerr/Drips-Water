import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FavoriteProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Set<String> get favorites => _favorites;

  bool isFavorite(String productId) => _favorites.contains(productId);

  // Load user's favorites from Firestore once at startup
  Future<void> loadFavorites() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .get();

    _favorites
      ..clear()
      ..addAll(snapshot.docs.map((doc) => doc.id));

    notifyListeners();
  }

  /// Toggle favorite both in Firestore and local cache
  Future<void> toggleFavorite(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(productId);

    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
      await favRef.delete();
    } else {
      _favorites.add(productId);
      await favRef.set({'isFavorite': true});
    }

    notifyListeners();
  }
}


// Would you like me to extend this system to include real-time Firestore sync (so if user favorites from another device, it updates automatically too)?
// Would you like me to show how to extend this to show all favorited products in a “Favorites Screen” next? (It will reuse the same Provider, no extra Firestore reads.)