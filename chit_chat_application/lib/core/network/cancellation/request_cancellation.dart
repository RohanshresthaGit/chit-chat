import 'package:dio/dio.dart' show CancelToken;

class RequestCancellation {
  final Map<String, CancelToken> _tokens = {};

  CancelToken getToken(String requestId) =>
      _tokens.putIfAbsent(requestId, CancelToken.new);

  void cancel(String requestId, {String? reason}) {
    final token = _tokens.remove(requestId);
    if (token != null && !token.isCancelled) {
      token.cancel(reason);
    }
  }

  void cancelAll({String? reason}) {
    for (final token in _tokens.values) {
      if (!token.isCancelled) {
        token.cancel(reason);
      }
    }
    _tokens.clear();
  }

  void remove(String requestId) => _tokens.remove(requestId);

  /// Checks whether a request is currently tracked.
  bool contains(String requestId) => _tokens.containsKey(requestId);
}
