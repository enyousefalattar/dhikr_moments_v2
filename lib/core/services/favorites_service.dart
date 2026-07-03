import 'package:flutter/foundation.dart';

class FavoritesService extends ChangeNotifier {
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;
  FavoritesService._internal();

  final Set<String> _favorites = {};

  bool isFavorite(String itemId, String type) {
    return _favorites.contains('$type:$itemId');
  }

  void toggleFavorite(String itemId, String type) {
    final key = '$type:$itemId';
    if (_favorites.contains(key)) {
      _favorites.remove(key);
    } else {
      _favorites.add(key);
    }
    notifyListeners();
  }

  List<String> getFavorites(String type) {
    return _favorites
        .where((key) => key.startsWith('$type:'))
        .map((key) => key.split(':')[1])
        .toList();
  }
}
