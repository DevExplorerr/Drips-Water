import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/model/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    Query<Map<String, dynamic>> query = _firestore.collection('products');

    if (category != 'All') {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}
