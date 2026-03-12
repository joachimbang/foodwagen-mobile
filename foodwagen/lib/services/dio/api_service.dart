import 'package:dio/dio.dart';
import 'package:foodwagen/core/utils/logger.dart';
import 'package:foodwagen/services/environment/env_service.dart';

// ApiService : configuration HTTP centrale.
//
// Pourquoi ce fichier existe ?
// - On veut un seul endroit pour configurer Dio (baseUrl, timeouts, headers, logs).
// - Les appels “métier” (GET /Food, POST /Food, etc.) restent dans le Repository.
//   => l’UI ne dépend pas de Dio directement.
class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EnvService.apiBaseUrl,
      connectTimeout: Duration(milliseconds: 30000),
      receiveTimeout: Duration(milliseconds: 30000),
      sendTimeout: Duration(milliseconds: 30000),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  static Dio get dio => _dio;

  // À appeler une seule fois au démarrage (voir main.dart).
  // Ici on active uniquement le logging pour déboguer les requêtes.
  static void initialize() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) {
          AppLogger.debug(object.toString());
        },
      ),
    );
  }
}
