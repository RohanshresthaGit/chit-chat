import 'package:dio/dio.dart'
    show
        Dio,
        DioException,
        Interceptor,
        ErrorInterceptorHandler,
        DioExceptionType,
        RequestOptions;

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;

  const RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    // Don't retry cancelled request.
    if (request.cancelToken?.isCancelled ?? false) {
      return handler.next(err);
    }

    // Don't retry requests that are not safe to retry.
    if (!_isRetryableMethod(request)) {
      return handler.next(err);
    }

    // Check whether the error is eligible for retry.
    if (!_isRetryableError(err)) {
      return handler.next(err);
    }

    final retryCount = request.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    final nextRetryCount = retryCount + 1;

    request.extra['retryCount'] = nextRetryCount;

    final delay = initialDelay * nextRetryCount;

    try {
      await Future.delayed(delay);

      if (request.cancelToken?.isCancelled ?? false) {
        return handler.next(
          DioException(
            requestOptions: request,
            type: DioExceptionType.cancel,
            error: 'Request cancelled during retry delay.',
          ),
        );
      }

      final response = await dio.fetch(request);

      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    } catch (error, stackTrace) {
      return handler.reject(
        DioException(
          requestOptions: request,
          error: error,
          stackTrace: stackTrace,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  bool _isRetryableMethod(RequestOptions request) {
    const safeMethods = {'GET', 'HEAD', 'OPTIONS', 'PUT', 'DELETE'};

    final method = request.method.toUpperCase();

    if (safeMethods.contains(method)) {
      return true;
    }

    // POST requires explicit permission and an idempotency strategy.
    if (method == 'POST') {
      return request.extra['retryable'] == true &&
          request.headers.containsKey('Idempotency-Key');
    }

    return false;
  }

  bool _isRetryableError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;

      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;

        return {408, 429, 500, 502, 503, 504}.contains(statusCode);
      default:
        return false;
    }
  }
}
