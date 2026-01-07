import 'package:flutter/foundation.dart';

/// Controller for Profile page state management
class ProfileController extends ChangeNotifier {
  bool _notificationsEnabled = true;

  /// Whether notifications are enabled
  bool get notificationsEnabled => _notificationsEnabled;

  /// Toggle notifications enabled state
  void toggleNotifications(bool value) {
    if (_notificationsEnabled != value) {
      _notificationsEnabled = value;
      notifyListeners();
    }
  }
}
