abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException({required super.message});
}

class TimeoutException extends AppException {
  const TimeoutException({required super.message});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized. Please login again.',
    super.statusCode = 401,
  });
}

class ForbiddenException extends AppException {
  const ForbiddenException({
    super.message = 'You do not have permission.',
    super.statusCode = 403,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}

class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Invalid request.',
    super.statusCode = 400,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Something went wrong on the server.',
    super.statusCode = 500,
  });
}

class RequestCancelledException extends AppException {
  const RequestCancelledException({
    super.message = 'Request cancelled.',
    super.statusCode = 499,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred.',
  });
}