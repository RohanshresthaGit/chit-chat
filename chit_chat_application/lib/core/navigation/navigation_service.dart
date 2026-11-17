import 'package:chit_chat_application/core/navigation/app_router.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  NavigationService._();

  static final NavigationService instance = NavigationService._();

  GoRouter get _router => AppRouter.router;

  void go(String location, {Object? extra}) {
    _router.go(location, extra: extra);
  }

  Future<T?> push<T extends Object?>(String location, {Object? extra}) {
    return _router.push<T>(location, extra: extra);
  }

  void goNamed(String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, String> queryParameters = const <String, String>{},
    Object? extra,
  }) {
    _router.goNamed(
      name,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      extra: extra,
    );
  }

  void pop<T extends Object?>([T? result]) {
    if(_router.canPop()) {
      _router.pop<T>(result);
    }
  }

  bool canPop() => _router.canPop();
}