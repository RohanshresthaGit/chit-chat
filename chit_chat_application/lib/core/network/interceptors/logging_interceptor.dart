import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../logging/logging_service.dart';

class LoggingInterceptor extends Interceptor {
  final LoggingService logger;

  LoggingInterceptor({required this.logger});

  static const _sensitiveKeys = {
    'authorization',
    'password',
    'confirmpassword',
    'accesstoken',
    'refreshtoken',
    'token',
    'secret',
    'apikey',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.debug('''
==================================================================================================================
|| ➡️ API REQUEST
|| Method: ${options.method}
|| Path: ${options.path}
|| Headers: ${_sanitize(options.headers)}
|| Query: ${_sanitize(options.queryParameters)}
|| Body: ${_sanitizeBody(options.data)}
===================================================================================================================
''');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.info('''
===================================================================================================================
|| ✅ API RESPONSE
|| Method: ${response.requestOptions.method}
|| Path: ${response.requestOptions.path}
|| Status: ${response.statusCode}
|| Data: ${_sanitizeBody(response.data)}
===================================================================================================================
''');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.error(
      '''
===================================================================================================================
|| ❌ API ERROR
|| Method: ${err.requestOptions.method}
|| Path: ${err.requestOptions.path}
|| Status: ${err.response?.statusCode}
|| Type: ${err.type}
|| Message: ${err.message}
|| Response: ${_sanitizeBody(err.response?.data)}
===================================================================================================================
''',
      error: err,
      stackTrace: err.stackTrace,
    );

    handler.next(err);
  }

  dynamic _sanitize(dynamic data) {
    if (data is Map) {
      return data.map((key, value) {
        final normalizedKey = key.toString().toLowerCase().replaceAll(
          RegExp(r'[-_\s]'),
          '',
        );

        if (_sensitiveKeys.contains(normalizedKey)) {
          return MapEntry(key, '***REDACTED***');
        }

        return MapEntry(key, _sanitize(value));
      });
    }

    if (data is List) {
      return data.map(_sanitize).toList();
    }

    return data;
  }

  dynamic _sanitizeBody(dynamic body) {
    if (body == null) return null;

    if (body is FormData) {
      return '[Multipart body omitted]';
    }

    if (body is Uint8List || body is List<int>) {
      return '[Binary body omitted]';
    }

    if (body is Map || body is List) {
      return _sanitize(body);
    }

    return '[Body omitted]';
  }
}
