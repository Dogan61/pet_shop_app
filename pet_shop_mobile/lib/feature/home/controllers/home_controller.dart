import 'package:flutter/material.dart';
import 'package:pet_shop_app/core/models/pet_category.dart';

/// Business logic controller for home page
class HomeController extends ChangeNotifier {
  PetCategory _selectedCategory = PetCategory.all;
  bool _hasLoadedFavorites = false;

  PetCategory get selectedCategory => _selectedCategory;
  bool get hasLoadedFavorites => _hasLoadedFavorites;

  /// Set selected category
  void setCategory(PetCategory category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Mark favorites as loaded
  void markFavoritesLoaded() {
    if (!_hasLoadedFavorites) {
      _hasLoadedFavorites = true;
      notifyListeners();
    }
  }

  /// Reset controller state
  void reset() {
    _selectedCategory = PetCategory.all;
    _hasLoadedFavorites = false;
    notifyListeners();
  }
}
