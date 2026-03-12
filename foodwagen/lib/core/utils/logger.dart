import 'package:logger/logger.dart';

// Logger applicatif.
//
// Pourquoi ce wrapper ?
// - Éviter d'appeler directement Logger() partout.
// - Avoir un format de log cohérent (PrettyPrinter).
// - Centraliser l'évolution (ex: désactiver en prod, envoyer vers un service, etc.).
class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    // Logs de debug (utile pendant le dev).
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  static void info(String message, {dynamic error, StackTrace? stackTrace}) {
    // Info (étapes importantes / événements normaux).
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message, {dynamic error, StackTrace? stackTrace}) {
    // Warning (comportement inattendu mais récupérable).
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    // Erreur (exception / échec).
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void verbose(String message, {dynamic error, StackTrace? stackTrace}) {
    // Logs très verbeux (trace). À utiliser avec parcimonie.
    _logger.t(message, error: error, stackTrace: stackTrace);
  }
}
