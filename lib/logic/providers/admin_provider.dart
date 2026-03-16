import 'package:flutter/material.dart';
import '../../data/services/admin_service.dart';

class AdminProvider with ChangeNotifier {
  final AdminService _adminService;

  AdminProvider(this._adminService);

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    _isUpdating = true;
    notifyListeners();

    try {
      await _adminService.changeOrderStatus(orderId, newStatus);
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }
}
