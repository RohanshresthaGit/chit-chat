import 'package:dio/dio.dart';

import 'app_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  static AppException handle(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException(
          message: 'The request timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badCertificate:
        return const NetworkException(
          message: 'Secure connection could not be established.',
        );

      case DioExceptionType.cancel:
        return const RequestCancelledException();

      case DioExceptionType.badResponse:
        return _handleResponse(exception.response);

      case DioExceptionType.unknown:
        return const UnknownException(
          message: "An unexpected error occurred. Please try again.",
        );

      case DioExceptionType.transformTimeout:
        throw UnknownException(
          message: 'Transform timeout is not implemented yet.',
        );
        
      default:
        return const UnknownException(
          message: "An unexpected error occurred. Please try again.",
        );
    }
  }

  static AppException _handleResponse(Response? response) {
    if (response == null) {
      return const UnknownException(
        message: "An unexpected error occurred. Please try again.",
      );
    }

    final statusCode = response.statusCode;
    final message = _extractMessage(response.data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message ?? 'Invalid request.',
          statusCode: statusCode,
        );

      case 401:
        return UnauthorizedException(
          message: message ?? 'Session expired. Please login again.',
        );

      case 403:
        return ForbiddenException(
          message: message ?? 'You do not have permission.',
        );

      case 404:
        return NotFoundException(
          message: message ?? 'Requested resource not found.',
        );

      case 408:
        return const TimeoutException(
          message: 'The server took too long to respond.',
        );

      case 422:
        return BadRequestException(
          message: message ?? 'Validation failed.',
          statusCode: statusCode,
        );

      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );

      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
          );
        }

        if (statusCode != null && statusCode >= 400) {
          return BadRequestException(
            message: message ?? 'Request failed.',
            statusCode: statusCode,
          );
        }

        return UnknownException(
          message: message ?? 'An unexpected error occurred.',
        );
    }
  }

  static String? _extractMessage(dynamic data) {
    if (data is! Map) return null;

    final message = data['message'] ?? data['detail'] ?? data['error'];

    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    return null;
  }
}
