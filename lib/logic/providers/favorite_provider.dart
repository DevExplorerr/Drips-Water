import 'package:drips_water/logic/services/favorite_service.dart';
import 'package:flutter/material.dart';

class FavoriteProvider extends ChangeNotifier {
  final FavoriteService _service;

  List<String> favorites = [];

  FavoriteProvider(this._service) {
    _listen();
  }

  void _listen() {
    _service.listenFavorites().listen((list) {
      favorites = list;
      notifyListeners();
    });
  }

  bool isFavorite(String id) {
    return favorites.contains(id);
  }

  Future<bool> toggleFavorite(String id) async {
    return _service.toggleFavorite(id, favorites);
  }
}
