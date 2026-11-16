
import 'package:dio/dio.dart';

import 'network_config.dart';
import 'cancellation/request_cancellation.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  late final Dio dio;

  final RequestCancellation cancellation;

  DioClient({
    required AuthInterceptor authInterceptor,
    required RetryInterceptor retryInterceptor,
    required LoggingInterceptor loggingInterceptor,
    required this.cancellation,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: NetworkConfig.baseUrl,
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        sendTimeout: NetworkConfig.sendTimeout,
        headers: NetworkConfig.defaultHeaders,
      ),
    );

    _setupInterceptors(
      authInterceptor,
      retryInterceptor,
      loggingInterceptor,
    );
  }

  // Register all interceptors.
  void _setupInterceptors(
    AuthInterceptor authInterceptor,
    RetryInterceptor retryInterceptor,
    LoggingInterceptor loggingInterceptor,
  ) {
    dio.interceptors.addAll([
      authInterceptor,
      retryInterceptor,
      loggingInterceptor,
    ]);
  }

  // Centralized request method with cancellation support.
  Future<Response<T>> request<T>({
    required String path,
    required String method,
    String? requestId,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, dynamic>? headers,
  }) async {
    final CancelToken? token = requestId != null
        ? cancellation.getToken(requestId)
        : null;

    try {
      return await dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(
          method: method,
          headers: headers,
        ),
        cancelToken: token,
      );
    } finally {
      if (requestId != null) {
        cancellation.remove(requestId);
      }
    }
  }

  // Cancel a particular request.
  void cancelRequest(
    String requestId, {
    String? reason,
  }) {
    cancellation.cancel(
      requestId,
      reason: reason,
    );
  }

  // Cancel all active requests.
  void cancelAllRequests({
    String? reason,
  }) {
    cancellation.cancelAll(
      reason: reason,
    );
  }
}
