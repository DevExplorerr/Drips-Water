import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/admin_repository.dart';

class AdminService {
  final AdminRepository _adminRepository;

  AdminService(this._adminRepository);

  Stream<QuerySnapshot> getOrdersStream() {
    return _adminRepository.fetchAllOrders();
  }

  Future<void> changeOrderStatus(String orderId, String status) {
    return _adminRepository.updateStatus(orderId, status);
  }

  Future<void> removeOrder(String orderId) {
    return _adminRepository.deleteOrder(orderId);
  }
}
