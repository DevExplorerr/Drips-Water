import 'package:drips_water/logic/services/user_service.dart';
import 'package:flutter/material.dart';

class HomeAppBarViewModel extends ChangeNotifier {
  final UserService _userService;

  HomeAppBarViewModel(this._userService);

  String? userName;
  bool isLoading = false;
  bool _isGuest = true;
  bool get isGuest => _isGuest;

  Future<void> loadUserName(String? uid) async {
    isLoading = true;
    notifyListeners();

    if (uid == null) {
      _isGuest = true;
      isLoading = false;
      notifyListeners();
      return;
    }

    _isGuest = false;

    userName = await _userService.fetchUserName(uid) ?? 'Guest';

    isLoading = false;
    notifyListeners();
  }
}
