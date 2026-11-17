import 'package:chit_chat_application/core/navigation/app_routes.dart';
import 'package:flutter/material.dart';

abstract final class RouteGuards {
  static bool _isAuthenticated = false;

  static bool get isAuthenticated => _isAuthenticated;

  static final ChangeNotifier _refreshNotifier = ChangeNotifier();

  static Listenable get refreshListenable => _refreshNotifier;

  static void updateAuthentication(bool value) {
    if (_isAuthenticated == value) return;

    _isAuthenticated = value;
    _refreshNotifier.notifyListeners();
  }

  static final Set<String> _publicRoutes = {
    AppRoutes.splash.path,
    AppRoutes.login.path,
  };

  static String? redirect(String location) {
    final isPublicRoute = _publicRoutes.contains(location);
    final isLoggingIn = location == AppRoutes.login.path;
    // final isSplash = location == AppRoutes.splash.path;

    if (isAuthenticated && isLoggingIn) {
      // return AppRoutes.chats.path
      return null;
    }

    if (isPublicRoute) return null;

    if (!isAuthenticated) return AppRoutes.login.path;

    return null;
  }
}
