import 'package:drips_water/data/models/address_model.dart';
import 'package:drips_water/data/services/user_service.dart';
import 'package:flutter/material.dart';

class CheckoutProvider with ChangeNotifier {
  final UserService userService;
  final String uid;
  AddressModel? _deliveryAddress;

  CheckoutProvider({required this.userService, required this.uid}) {
    _loadSavedAddress();
  }

  AddressModel? get deliveryAddress => _deliveryAddress;

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
}
