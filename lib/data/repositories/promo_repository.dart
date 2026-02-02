import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drips_water/data/models/promo_code_model.dart';

class PromoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PromoCodeModel?> fetchPromoCode(String code) async {
    try {
      final querySnapshot = await _firestore
          .collection('promo_codes')
          .where('code', isEqualTo: code)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final data = querySnapshot.docs.first.data();
        return PromoCodeModel.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception("Error fetching promo code: $e");
    }
  }
}
