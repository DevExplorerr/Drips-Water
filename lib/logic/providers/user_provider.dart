import 'package:drips_water/data/services/user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService;

  UserProvider(this._userService);

  String? userName;
  String userRole = 'user';
  bool isLoading = false;
  bool _isGuest = true;
  bool get isGuest => _isGuest;

  bool get isAdmin => userRole == 'admin';

  Future<void> loadUserName(String? uid) async {
    isLoading = true;
    notifyListeners();

    if (uid == null) {
      _isGuest = true;
      userRole = 'user';
      isLoading = false;
      notifyListeners();
      return;
    }

    _isGuest = false;

    final userData = await _userService.getUserData(uid);

    if (userData != null) {
      userName = userData['name'] ?? 'Guest';
      userRole = userData['role'] ?? 'user';
    }

    isLoading = false;
    notifyListeners();
  }
}
