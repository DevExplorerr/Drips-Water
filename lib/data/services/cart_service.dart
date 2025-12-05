import 'package:drips_water/data/models/product_model.dart';
import 'package:drips_water/data/repositories/cart_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  final CartRepository _repo;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CartService(this._repo);

  String? get uid => _auth.currentUser?.uid;

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Future<String> addToCart({
    required ProductModel product,
    required String size,
    required int quantity,
  }) async {
    if (uid == null) return "Please login to continue";

    if (_isProcessing) return "Please wait...";

    if (size.isEmpty) return "Please select a size";

    if (quantity < 1) return "Invalid quantity";

    _isProcessing = true;

    try {
      await _repo.addToCart(
        uid: uid!,
        product: product,
        size: size,
        quantity: quantity,
      );

      return "Added to cart";
    } catch (_) {
      return "Failed to add item";
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> decrease(String productId, String size) async {
    if (uid == null) return;
    await _repo.decrease(uid: uid!, productId: productId, size: size);
  }

  Future<void> deleteItem(String productId, String size) async {
    if (uid == null) return;
    await _repo.deleteItem(uid: uid!, productId: productId, size: size);
  }

  Future<void> clearCart() async {
    if (uid == null) return;
    await _repo.clearCart(uid!);
  }
}
