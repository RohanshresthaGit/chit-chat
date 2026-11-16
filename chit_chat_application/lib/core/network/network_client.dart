
import 'package:dio/dio.dart';

import 'dio_client.dart';
import 'errors/error_handler.dart';

class NetworkClient {
  final DioClient _dioClient;

  NetworkClient({
    required this._dioClient,
  });

  /// GET request
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      requestId: requestId,
      cancelToken: cancelToken,
    );
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      path: path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestId: requestId,
      cancelToken: cancelToken,
    );
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      path: path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestId: requestId,
      cancelToken: cancelToken,
    );
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      path: path,
      method: 'PATCH',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestId: requestId,
      cancelToken: cancelToken,
    );
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      path: path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      requestId: requestId,
      cancelToken: cancelToken,
    );
  }

  /// Centralized request handler
  Future<Response<T>> _request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    String? requestId,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dioClient.dio.request<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken ??
            (requestId != null
                ? _dioClient.cancellation.getToken(requestId)
                : null),
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      return response;
    } on DioException catch (error) {
      throw ErrorHandler.handle(error);
    } finally {
      if (requestId != null) {
        _dioClient.cancellation.remove(requestId);
      }
    }
  }

  /// Cancel a specific request
  void cancelRequest(
    String requestId, {
    String? reason,
  }) {
    _dioClient.cancelRequest(
      requestId,
      reason: reason,
    );
  }

  /// Cancel all active requests
  void cancelAllRequests({
    String? reason,
  }) {
    _dioClient.cancelAllRequests(
      reason: reason,
    );
  }
}
