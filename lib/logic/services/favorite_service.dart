import 'package:drips_water/logic/repository/favorite_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final FavoriteRepository _repo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FavoriteService(this._repo);

  String? get uid => _auth.currentUser?.uid;

  Stream<List<String>> listenFavorites() {
    if (uid == null) return const Stream.empty();
    return _repo.listenFavorites(uid!);
  }

  // Toggle logic
  Future<bool> toggleFavorite(String productId, List<String> current) async {
    if (uid == null) return false;

    final isFavorite = current.contains(productId);

    try {
      if (isFavorite) {
        await _repo.removeFavorite(uid!, productId);
      } else {
        await _repo.addFavorite(uid!, productId);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
