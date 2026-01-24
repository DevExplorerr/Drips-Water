import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/models/card_model.dart';
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

  CheckoutProvider({required this.userService, required this.uid}) {
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    if (uid.isEmpty) return;
    final savedAddress = await userService.getUserAddress(uid);
    if (savedAddress != null) {
      _deliveryAddress = savedAddress;
      notifyListeners();
    }
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

  void updateCardDetails(CardModel card) {
    _cardDetails = card;
    notifyListeners();
  }
}
