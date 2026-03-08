import 'package:drips_water/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../data/models/address_model.dart';
import '../../data/services/address_service.dart';

class AddressProvider extends ChangeNotifier {
  final AddressService _addressService = AddressService();
  bool isLoading = false;

  List<AddressModel> _allAddresses = [];

  String? get _currentUid => authService.value.currentUser?.uid;

  AddressModel? get selectedAddress {
    if (_allAddresses.isEmpty) return null;
    try {
      return _allAddresses.firstWhere((element) => element.isDefault);
    } catch (_) {
      return _allAddresses.first;
    }
  }

  void syncAddresses(List<AddressModel> addresses) {
    _allAddresses = addresses;
    notifyListeners();
  }

  // Save or Update
  Future<bool> handleSaveAddress(
    AddressModel address, {
    String? addressId,
  }) async {
    if (_currentUid == null) return false;

    isLoading = true;
    notifyListeners();

    try {
      await _addressService.saveAddress(
        _currentUid!,
        address,
        addressId: addressId,
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String addressId) async {
    if (_currentUid != null) {
      await _addressService.removeAddress(_currentUid!, addressId);
    }
  }

  Stream<List<AddressModel>> get addressStream {
    if (_currentUid == null) return const Stream.empty();
    return _addressService.getAddresses(_currentUid!);
  }

  Future<void> setAsDefault(String addressId) async {
    if (_currentUid == null) return;

    await _addressService.setAsDefault(_currentUid!, addressId);
  }
}
