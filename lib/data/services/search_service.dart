import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs;
  }
}
