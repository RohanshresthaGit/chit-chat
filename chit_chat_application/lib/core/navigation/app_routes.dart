library;

/// Holds the path and name of each route in the application.
///
/// When maintaining separate classes for route paths and names, developers
/// might forget to register a newly created route in both classes.
///
/// To avoid this, we keep both the path and name together in a single class
/// for each route, ensuring they are always defined in one place.

class AppRoute {
  final String path;
  final String name;

  const AppRoute({required this.path, required this.name});
}

abstract final class AppRoutes {
  static const splash = AppRoute(path: '/', name: 'splash');

  static const login = AppRoute(path: '/login', name: 'login');

  static const chats = AppRoute(path: '/chats', name: 'chats');

  static const friends = AppRoute(path: '/friends', name: 'friends');

  static const settings = AppRoute(path: '/settings', name: 'settings');
}
