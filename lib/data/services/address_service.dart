import '../models/address_model.dart';
import '../repositories/address_repository.dart';

class AddressService {
  final AddressRepository _repository = AddressRepository();

  Stream<List<AddressModel>> getAddresses(String uid) =>
      _repository.getAddressesStream(uid);

  Future<void> saveAddress(
    String uid,
    AddressModel address, {
    String? addressId,
  }) async {
    if (addressId != null) {
      await _repository.updateAddress(uid, addressId, address);
    } else {
      await _repository.addAddress(uid, address);
    }
  }

  Future<void> removeAddress(String uid, String addressId) async {
    await _repository.deleteAddress(uid, addressId);
  }
}
