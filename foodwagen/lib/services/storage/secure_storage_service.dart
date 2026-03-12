import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:foodwagen/core/utils/logger.dart';

// Service de stockage sécurisé.
//
// Utilisé pour :
// - stocker un token (auth)
// - stocker les données utilisateur (JSON)
// - stocker le panier (JSON)
//
// Pourquoi FlutterSecureStorage ?
// - Les données sensibles ne doivent pas être en clair dans SharedPreferences.
// - Sur Android, on active encryptedSharedPreferences.
class SecureStorageService {
  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(),
  );

  static Future<void> storeToken(String token) async {
    // Écrit le token (string) dans le stockage sécurisé.
    try {
      await _storage.write(key: 'auth_token', value: token);
      AppLogger.info('Token stored successfully');
    } catch (e) {
      AppLogger.error('Failed to store token', error: e);
      rethrow;
    }
  }

  static Future<String?> getToken() async {
    // Lit le token depuis le stockage sécurisé (peut être null si absent).
    try {
      final token = await _storage.read(key: 'auth_token');
      AppLogger.debug(
        'Token retrieved: ${token != null ? 'found' : 'not found'}',
      );
      return token;
    } catch (e) {
      AppLogger.error('Failed to retrieve token', error: e);
      return null;
    }
  }

  static Future<void> removeToken() async {
    // Supprime le token.
    try {
      await _storage.delete(key: 'auth_token');
      AppLogger.info('Token removed successfully');
    } catch (e) {
      AppLogger.error('Failed to remove token', error: e);
      rethrow;
    }
  }

  static Future<void> storeUserData(Map<String, dynamic> userData) async {
    // Stockage d'un objet (Map) sous forme de JSON.
    try {
      final userDataJson = jsonEncode(userData);
      await _storage.write(key: 'user_data', value: userDataJson);
      AppLogger.info('User data stored successfully');
    } catch (e) {
      AppLogger.error('Failed to store user data', error: e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getUserData() async {
    // Récupère les données utilisateur (Map) en décodant le JSON.
    try {
      final userDataJson = await _storage.read(key: 'user_data');
      if (userDataJson != null) {
        final userData = jsonDecode(userDataJson) as Map<String, dynamic>;
        AppLogger.debug('User data retrieved successfully');
        return userData;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to retrieve user data', error: e);
      return null;
    }
  }

  static Future<void> removeUserData() async {
    try {
      await _storage.delete(key: 'user_data');
      AppLogger.info('User data removed successfully');
    } catch (e) {
      AppLogger.error('Failed to remove user data', error: e);
      rethrow;
    }
  }

  static Future<void> storeCartData(Map<String, dynamic> cartData) async {
    // Stockage du panier au format JSON.
    try {
      await _storage.write(key: 'cart_data', value: jsonEncode(cartData));
      AppLogger.info('Cart data stored successfully');
    } catch (e) {
      AppLogger.error('Failed to store cart data', error: e);
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> getCartData() async {
    // Récupère le panier depuis le stockage.
    // On décode le JSON et on vérifie que c'est bien un Map<String, dynamic>.
    try {
      final cartDataJson = await _storage.read(key: 'cart_data');
      AppLogger.debug(
        'Cart data retrieved: ${cartDataJson != null ? 'found' : 'not found'}',
      );
      if (cartDataJson == null) {
        return null;
      }
      final data = jsonDecode(cartDataJson);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return null;
    } catch (e) {
      AppLogger.error('Failed to retrieve cart data', error: e);
      return null;
    }
  }

  static Future<void> removeCartData() async {
    try {
      await _storage.delete(key: 'cart_data');
      AppLogger.info('Cart data removed successfully');
    } catch (e) {
      AppLogger.error('Failed to remove cart data', error: e);
      rethrow;
    }
  }

  static Future<void> clearAll() async {
    // Supprime toutes les clés du stockage sécurisé.
    try {
      await _storage.deleteAll();
      AppLogger.info('All secure storage data cleared');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', error: e);
      rethrow;
    }
  }

  static Future<bool> hasToken() async {
    // Helper pratique pour savoir si on a une session.
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<bool> hasUserData() async {
    final userData = await getUserData();
    return userData != null;
  }
}
