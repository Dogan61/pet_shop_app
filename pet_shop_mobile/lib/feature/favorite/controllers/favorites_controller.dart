import 'package:flutter/material.dart';

/// Business logic controller for favorites page
class FavoritesController extends ChangeNotifier {
  bool _hasLoadedFavorites = false;

  bool get hasLoadedFavorites => _hasLoadedFavorites;

  /// Mark favorites as loaded
  void markFavoritesLoaded() {
    if (!_hasLoadedFavorites) {
      _hasLoadedFavorites = true;
      notifyListeners();
    }
  }

  /// Reset controller state
  void reset() {
    _hasLoadedFavorites = false;
    notifyListeners();
  }
}
