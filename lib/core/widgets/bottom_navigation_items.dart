import 'package:flutter/material.dart';

typedef BottomNavTapCallback = void Function(int index);

class BottomNavigationItems {
  BottomNavigationItems._();

  static const List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
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

  /// Creates a default onTap handler that updates the current index
  /// Usage: onTap: BottomNavigationItems.createOnTapHandler(setState, (index) => _currentIndex = index)
  static BottomNavTapCallback createOnTapHandler(
    void Function(VoidCallback) setState,
    void Function(int) updateIndex,
  ) {
    return (int index) {
      setState(() {
        updateIndex(index);
      });
    };
  }
}

