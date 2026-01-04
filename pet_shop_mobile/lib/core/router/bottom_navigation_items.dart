import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Callback type for bottom navigation tap events
typedef BottomNavTapCallback = void Function(int index);

/// Bottom navigation bar items and routing configuration
class BottomNavigationItems {
  BottomNavigationItems._();

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

  /// Get bottom navigation bar items without badge
  static List<BottomNavigationBarItem> getItems() {
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Favorites',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];
  }
}
