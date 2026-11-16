import 'package:chit_chat_application/core/network/uitls/token_provider.dart';
import 'package:dio/dio.dart' 
      show Interceptor, RequestOptions, RequestInterceptorHandler, DioException, DioExceptionType;

class AuthInterceptor extends Interceptor {
  final TokenProvider tokenProvider;

    const AuthInterceptor({
    required this.tokenProvider,
  });

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final requireAuth = options.extra['requireAuth'] as bool? ?? true;

      if(requireAuth) return handler.next(options);

      final token = await tokenProvider.getAccessToken();

      if(token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } 
       handler.next(options);

    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
          type: DioExceptionType.unknown,
        ),
      );

    }
  }
}