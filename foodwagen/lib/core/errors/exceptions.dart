import 'package:dio/dio.dart';

// Exceptions "métier" / techniques.
//
// Objectif :
// - Normaliser les erreurs côté app (au lieu d'exposer directement DioException).
// - Faciliter l'affichage d'un message clair dans l'UI.
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  // Erreur réseau "générique" (pas de connexion, DNS, etc.).
  final String message;

  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  // Erreur liée au cache / stockage local.
  final String message;

  CacheException({required this.message});

  @override
  String toString() => 'CacheException: $message';
}

class ValidationException implements Exception {
  // Erreur de validation (ex: formulaire invalide, champ obligatoire).
  final String message;
  final Map<String, String>? fieldErrors;

  ValidationException({required this.message, this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message';
}

class AuthenticationException implements Exception {
  // Erreur d'auth (token invalide/expiré, non autorisé, etc.).
  final String message;

  AuthenticationException({required this.message});

  @override
  String toString() => 'AuthenticationException: $message';
}

class ApiException implements Exception {
  // Erreur "API" normalisée.
  // - message : message utilisateur
  // - statusCode : code HTTP si disponible
  // - data : payload brut (utile pour debug)
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  factory ApiException.fromDioError(DioException error) {
    // Mapping DioException -> ApiException (messages compréhensibles).
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            error.response?.statusMessage ??
            'An error occurred';
        return ApiException(
          message: message,
          statusCode: statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(message: 'Request was cancelled');
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection');
      case DioExceptionType.badCertificate:
        return ApiException(message: 'SSL certificate error');
      case DioExceptionType.unknown:
        return ApiException(message: 'An unexpected error occurred');
    }
  }

  @override
  String toString() => 'ApiException: $message';
}
