class NetworkConfig {
  NetworkConfig._();

  static const String baseUrl = 'https://api.example.com';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 20);
  static const Duration sendTimeout = Duration(seconds: 20);

  static const int maxRetries = 3;

  static const Duration retryDelay = Duration(seconds: 1);

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}