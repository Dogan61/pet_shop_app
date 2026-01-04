import 'package:envied/envied.dart';

part 'app_config.g.dart';

@Envied(path: '.env.development', obfuscate: true)
abstract class DevEnv {
  @EnviedField(varName: 'API_BASE_URL')
  static final String apiBaseUrl = _DevEnv.apiBaseUrl;

  @EnviedField(varName: 'API_TIMEOUT', defaultValue: '30000')
  static final String apiTimeout = _DevEnv.apiTimeout;
}

@Envied(path: '.env.production', obfuscate: true)
abstract class ProdEnv {
  @EnviedField(varName: 'API_BASE_URL')
  static final String apiBaseUrl = _ProdEnv.apiBaseUrl;

  @EnviedField(varName: 'API_TIMEOUT', defaultValue: '30000')
  static final String apiTimeout = _ProdEnv.apiTimeout;
}

/// Application configuration
class AppConfig {
  AppConfig._();

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static const bool isDevelopment = !isProduction;

  /// Get API base URL based on environment
  static String get apiBaseUrl {
    if (isProduction) {
      return ProdEnv.apiBaseUrl;
    } else {
      return DevEnv.apiBaseUrl;
    }
  }

  /// Get API timeout in milliseconds
  static int get apiTimeout {
    final timeoutStr = isProduction ? ProdEnv.apiTimeout : DevEnv.apiTimeout;
    return int.tryParse(timeoutStr) ?? 30000;
  }

  /// Get current environment name
  static String get environment {
    return isProduction ? 'production' : 'development';
  }
}
