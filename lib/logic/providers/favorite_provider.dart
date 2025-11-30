import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:drips_water/data/services/favorite_service.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service;

  List<String> favorites = [];
  StreamSubscription? _favoritesSub;
  StreamSubscription? _authSub;

  FavoriteProvider(this._service) {
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) {
      _restartListener();
    });
  }

  // Restarting listener when user changes
  void _restartListener() {
    _favoritesSub?.cancel();

    if (_service.uid == null) {
      favorites = [];
      notifyListeners();
      return;
    }

    _favoritesSub = _service.listenFavorites().listen((ids) {
      favorites = ids;
      notifyListeners();
    });
  }

  bool isFavorite(String id) => favorites.contains(id);

  Future<bool> toggleFavorite(String id) async {
    return _service.toggleFavorite(id, favorites);
  }

  @override
  void dispose() {
    _favoritesSub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }
}
