import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_shop_app/core/controller/favorites_controller.dart';

/// Callback type for bottom navigation tap events
typedef BottomNavTapCallback = void Function(int index);

/// Bottom navigation bar items and routing configuration
class BottomNavigationItems {
  BottomNavigationItems._();

  /// Get bottom navigation bar items with dynamic favorite count badge
  static List<BottomNavigationBarItem> getItems() {
    final favoriteCount = FavoritesController.getFavoriteIndices().length;
    
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.favorite),
            if (favoriteCount > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    favoriteCount > 99 ? '99+' : '$favoriteCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        label: 'Favorites',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }

  /// Route paths for each bottom navigation item
  /// Must match the order of items list
  static const List<String> routes = [
    '/home',
    '/favorites',
    '/profile',
  ];

  /// Creates a route handler that navigates to the corresponding route
  /// when a bottom navigation item is tapped
  static BottomNavTapCallback createRouteHandler(
    BuildContext context,
    void Function(VoidCallback) setState,
    void Function(int) updateIndex,
  ) {
    return (int index) {
      if (index >= 0 && index < routes.length) {
        final route = routes[index];
        setState(() {
          updateIndex(index);
        });
        context.go(route);
      }
    };
  }
}
