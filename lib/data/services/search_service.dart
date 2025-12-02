import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/product_model.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ProductModel>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}
