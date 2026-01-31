import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/card_model.dart';
import 'package:drips_water/data/models/promo_code_model.dart';
import 'package:drips_water/data/services/user_service.dart';
import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  final UserService userService;
  final String uid;

  AddressModel? _deliveryAddress;
  AddressModel? get deliveryAddress => _deliveryAddress;

  String _deliveryOption = 'standard';
  String get deliveryOption => _deliveryOption;
  bool get showCalendar => _deliveryOption == 'schedule';

  DateTime? _scheduledTime;
  DateTime? get scheduledTime => _scheduledTime;

  String _paymentMethod = 'cod';
  CardModel? _cardDetails;

  String get paymentMethod => _paymentMethod;
  CardModel? get cardDetails => _cardDetails;

  PromoCodeModel? _appliedPromo;
  String? _promoError;
  final double _deliveryFee = 5.0;

  PromoCodeModel? get appliedPromo => _appliedPromo;
  String? get promoError => _promoError;
  double get deliveryFee => _deliveryFee;

  CheckoutProvider({required this.userService, required this.uid}) {
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    if (uid.isEmpty) return;

    final savedAddress = await userService.getUserAddress(uid);
    if (savedAddress != null) {
      _deliveryAddress = savedAddress;
    }

    final savedCard = await userService.getUserCard(uid);
    if (savedCard != null) {
      _cardDetails = savedCard;
    }
    notifyListeners();
  }

  Future<void> updateDeliveryAddress(AddressModel newAddress) async {
    _deliveryAddress = newAddress;
    notifyListeners();

    if (uid.isNotEmpty) {
      await userService.saveUserAddress(uid, newAddress);
    }
  }

  void setDeliveryOption(String option) {
    _deliveryOption = option;

    if (option == 'schedule' && _scheduledTime == null) {
      _scheduledTime = DateTime.now().add(const Duration(days: 1));
    }
    notifyListeners();
  }

  void setScheduledTime(DateTime date) {
    _scheduledTime = date;
    if (_deliveryOption != 'schedule') {
      _deliveryOption = 'schedule';
    }
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    _paymentMethod = method;
    notifyListeners();
  }

  void updateCardDetails(CardModel card) async {
    _cardDetails = card;
    notifyListeners();

    if (uid.isNotEmpty) {
      await userService.saveUserCard(uid, card);
    }
  }

  void validatePromoCode(String code) {
    _promoError = null;

    try {
      final validCode = PromoCodeModel.mockCodes.firstWhere(
        (element) => element.code.toUpperCase() == code.toUpperCase(),
      );

      _appliedPromo = validCode;
      notifyListeners();
    } catch (e) {
      _appliedPromo = null;
      _promoError = "Invalid Promo Code";
      notifyListeners();
    }
  }

  void removePromoCode() {
    _appliedPromo = null;
    _promoError = null;
    notifyListeners();
  }

  double calculateDiscount(double subtotal) {
    if (_appliedPromo == null) return 0.0;

    if (_appliedPromo!.isPercentage) {
      return subtotal * (_appliedPromo!.value / 100);
    } else {
      return _appliedPromo!.value;
    }
  }

  double calculateFinalTotal(double subtotal) {
    final discount = calculateDiscount(subtotal);
    final total = (subtotal + _deliveryFee) - discount;
    return total > 0 ? total : 0.0;
  }
}
