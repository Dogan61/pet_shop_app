import 'package:flutter/widgets.dart';
import 'package:pet_shop_app/core/di/injection_container.dart' as di;

/// Handles app initialization
class AppInitializer {
  /// Initialize the app
  /// Call this before runApp()
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
  }
}
