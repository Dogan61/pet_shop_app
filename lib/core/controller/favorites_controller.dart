import 'package:pet_shop_app/core/constants/favorites_constants.dart';
import 'package:pet_shop_app/core/constants/image_constants.dart';
import 'package:pet_shop_app/core/constants/pet_constants.dart';

/// Business logic controller for favorites page
class FavoritesController {
  FavoritesController._();

  // In-memory storage for favorite pet indices
  // In a real app, this would be stored in a state management solution or database
  static final Set<int> _favoriteIndices = <int>{};

  /// Toggle favorite status for a pet
  static void toggleFavorite(int petIndex) {
    if (_favoriteIndices.contains(petIndex)) {
      _favoriteIndices.remove(petIndex);
    } else {
      _favoriteIndices.add(petIndex);
    }
  }

  /// Check if a pet is favorited
  static bool isFavorite(int petIndex) {
    return _favoriteIndices.contains(petIndex);
  }

  /// Get favorite pet indices
  static Set<int> getFavoriteIndices() {
    return Set<int>.from(_favoriteIndices);
  }

  /// Get sample favorites data
  /// In a real app, this would fetch from a state management solution or API
  static List<Map<String, String>> getFavoritesData() {
    if (_favoriteIndices.isEmpty) {
      return [];
    }

    return _favoriteIndices.map((index) {
      return {
        'imageUrl':
            ImageConstants.petImages[index % ImageConstants.petImages.length],
        'name': PetConstants.petNames[index % PetConstants.petNames.length],
        'breed': PetConstants.petBreeds[index % PetConstants.petBreeds.length],
        'age': PetConstants.petAges[index % PetConstants.petAges.length],
        'distance':
            PetConstants.distances[index % PetConstants.distances.length],
        'index': index.toString(),
      };
    }).toList();
  }

  /// Check if favorites list is empty
  static bool isEmpty(List<Map<String, String>> favorites) {
    return favorites.isEmpty;
  }
}
