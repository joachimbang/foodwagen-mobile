import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:foodwagen/core/utils/logger.dart';

// Service de configuration (lecture du fichier .env).
//
// But :
// - Centraliser l'accès aux variables d'environnement.
// - Fournir des getters typés (bool/int/double/String).
// - Éviter de dupliquer "dotenv.env[...]" partout.
//
// Dans cette app, la variable la plus importante est :
// - API_BASE_URL => utilisée par ApiService (Dio.baseUrl)
class EnvService {
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      AppLogger.info('Environment variables loaded successfully');
    } catch (e) {
      AppLogger.error('Failed to load environment variables', error: e);
      rethrow;
    }
  }

  static String get(String key, {String? defaultValue}) {
    // Lecture "safe" :
    // - si absent et defaultValue fourni => on retourne le default
    // - sinon on throw (car c'est une config obligatoire)
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      if (defaultValue != null) {
        AppLogger.warning(
          'Environment variable $key not found, using default value',
        );
        return defaultValue;
      }
      AppLogger.error(
        'Environment variable $key not found and no default value provided',
      );
      throw Exception('Environment variable $key not found');
    }
    return value;
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    final value = get(key, defaultValue: defaultValue.toString());
    return value.toLowerCase() == 'true';
  }

  static int getInt(String key, {int? defaultValue}) {
    final value = get(key, defaultValue: defaultValue?.toString());
    return int.tryParse(value) ?? defaultValue ?? 0;
  }

  static double getDouble(String key, {double? defaultValue}) {
    final value = get(key, defaultValue: defaultValue?.toString());
    return double.tryParse(value) ?? defaultValue ?? 0.0;
  }

  // API Configuration
  // NB: L'app utilise surtout apiBaseUrl.
  static String get apiBaseUrl => get('API_BASE_URL');
  static String get apiVersion => get('API_VERSION');
  static bool get isDebugMode => getBool('DEBUG_MODE', defaultValue: true);
  static String get environment =>
      get('ENVIRONMENT', defaultValue: 'development');

  // Security
  static String get jwtSecret => get('JWT_SECRET');
  static String get encryptionKey => get('ENCRYPTION_KEY');

  // External Services
  static String get mapsApiKey => get('MAPS_API_KEY');
  static String get paymentApiKey => get('PAYMENT_API_KEY');

  // App Configuration
  static String get appName => get('APP_NAME');
  static String get appVersion => get('APP_VERSION');
  static String get supportEmail => get('SUPPORT_EMAIL');

  static bool get isProduction => environment.toLowerCase() == 'production';
  static bool get isDevelopment => environment.toLowerCase() == 'development';
  static bool get isStaging => environment.toLowerCase() == 'staging';
}
