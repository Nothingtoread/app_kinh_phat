import 'dart:developer' as developer;
import 'dart:io';
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

class DebugLogger {
  static const String _tag = 'KinhPhatApp';
  static bool _isEnabled = true;
  static LogLevel _minLevel = LogLevel.debug;

  static void enable() {
    _isEnabled = true;
  }

  static void disable() {
    _isEnabled = false;
  }

  static void setMinLevel(LogLevel level) {
    _minLevel = level;
  }

  static void _log(LogLevel level, String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    if (!_isEnabled || level.index < _minLevel.index) return;

    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase();
    final prefix = '[$timestamp] [$levelStr] [$_tag]';

    // Console output
    if (kDebugMode) {
      print('$prefix $message');
      if (error != null) {
        print('$prefix ERROR: $error');
      }
      if (data != null) {
        print('$prefix DATA: $data');
      }
      if (stackTrace != null) {
        print('$prefix STACK: $stackTrace');
      }
    }

    // Developer console (for Flutter DevTools)
    developer.log(
      message,
      name: _tag,
      level: level.index,
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
    );
  }

  static void debug(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.debug, message, data: data);
  }

  static void info(String message, {Map<String, dynamic>? data}) {
    _log(LogLevel.info, message, data: data);
  }

  static void warning(String message, {Object? error, Map<String, dynamic>? data}) {
    _log(LogLevel.warning, message, error: error, data: data);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace, data: data);
  }

  static void critical(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    _log(LogLevel.critical, message, error: error, stackTrace: stackTrace, data: data);
  }

  // Network specific logging
  static void networkRequest(String method, String url, {Map<String, String>? headers, Object? body}) {
    debug('NETWORK REQUEST', data: {
      'method': method,
      'url': url,
      'headers': headers,
      'body': body?.toString(),
    });
  }

  static void networkResponse(String method, String url, int statusCode, {String? responseBody, Duration? duration}) {
    final level = statusCode >= 400 ? LogLevel.error : LogLevel.info;
    _log(level, 'NETWORK RESPONSE', data: {
      'method': method,
      'url': url,
      'statusCode': statusCode,
      'responseBody': responseBody,
      'duration': duration?.inMilliseconds,
    });
  }

  static void networkError(String method, String url, Object error, {StackTrace? stackTrace}) {
    DebugLogger.error('NETWORK ERROR', error: error, stackTrace: stackTrace, data: {
      'method': method,
      'url': url,
    });
  }

  // API specific logging
  static void apiCall(String endpoint, {Map<String, dynamic>? params, Object? body}) {
    debug('API CALL', data: {
      'endpoint': endpoint,
      'params': params,
      'body': body,
    });
  }

  static void apiSuccess(String endpoint, {Object? response}) {
    info('API SUCCESS', data: {
      'endpoint': endpoint,
      'response': response?.toString(),
    });
  }

  static void apiError(String endpoint, Object error, {StackTrace? stackTrace}) {
    DebugLogger.error('API ERROR', error: error, stackTrace: stackTrace, data: {
      'endpoint': endpoint,
    });
  }

  // Authentication specific logging
  static void authEvent(String event, {Map<String, dynamic>? data}) {
    info('AUTH EVENT: $event', data: data);
  }

  static void authError(String event, Object error, {StackTrace? stackTrace}) {
    DebugLogger.error('AUTH ERROR: $event', error: error, stackTrace: stackTrace);
  }

  // Database specific logging
  static void dbOperation(String operation, {Map<String, dynamic>? data}) {
    debug('DB OPERATION: $operation', data: data);
  }

  static void dbError(String operation, Object error, {StackTrace? stackTrace}) {
    DebugLogger.error('DB ERROR: $operation', error: error, stackTrace: stackTrace);
  }

  // Performance logging
  static void performance(String operation, Duration duration, {Map<String, dynamic>? data}) {
    final level = duration.inMilliseconds > 1000 ? LogLevel.warning : LogLevel.info;
    _log(level, 'PERFORMANCE: $operation', data: {
      'duration_ms': duration.inMilliseconds,
      ...?data,
    });
  }

  // System info logging
  static void systemInfo() {
    info('SYSTEM INFO', data: {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
      'isDebug': kDebugMode,
      'isProfile': kProfileMode,
      'isRelease': kReleaseMode,
    });
  }
}
