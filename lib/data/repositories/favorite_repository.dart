import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favoritesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  // Stream favorites
  Stream<List<String>> listenFavorites(String uid) {
    return _favoritesRef(uid).snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => doc.id).toList();
      },
    );
  }

  Future<void> addFavorite(String uid, String productId) {
    return _favoritesRef(uid).doc(productId).set({'createdAt': DateTime.now()});
  }

  Future<void> removeFavorite(String uid, String productId) {
    return _favoritesRef(uid).doc(productId).delete();
  }
}
