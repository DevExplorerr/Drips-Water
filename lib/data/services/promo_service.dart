import 'package:drips_water/data/models/promo_code_model.dart';
import 'package:drips_water/data/repositories/promo_repository.dart';

class PromoService {
  final PromoRepository _repository = PromoRepository();

  Future<PromoCodeModel?> validateCode(String code) async {
    final promo = await _repository.fetchPromoCode(code);

    if (promo == null) {
      throw "This promo code doesn't exist";
    }

    if (!promo.isActive) {
      throw "This promo code has expired";
    }

    return promo;
  }
}
