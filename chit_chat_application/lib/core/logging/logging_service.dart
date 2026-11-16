import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:logger/logger.dart';

class LoggingService {
  late final Logger _logger;

  LoggingService() {
    _logger = Logger(
      filter: DevelopmentFilter(),
      printer: PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        colors: true,
        printEmojis: true,
      ),
    );
  }

  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  void info(String message) {
    if (!kDebugMode) return;
    _logger.i(message);
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;

    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Object? error, StackTrace? stackTrace}) {
    if (!kDebugMode) return;

    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void trace(String message) {
    if (!kDebugMode) return;
    _logger.t(message);
  }
}
