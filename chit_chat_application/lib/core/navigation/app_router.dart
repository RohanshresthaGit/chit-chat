import 'package:chit_chat_application/core/navigation/app_routes.dart';
import 'package:chit_chat_application/core/navigation/route_guards.dart';
import 'package:chit_chat_application/core/navigation/widgets/app_navigation_shell.dart';
import 'package:chit_chat_application/features/dummy/chats_page.dart';
import 'package:chit_chat_application/features/error/presentation/pages/not_found_page.dart';
import 'package:chit_chat_application/features/splash/splash_screen.dart';
import 'package:chit_chat_application/core/navigation/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash.path,
    redirect: (context, state) {
      return RouteGuards.redirect(state.matchedLocation);
    },
    refreshListenable: RouteGuards.refreshListenable,
    routes: [
      GoRoute(
        path: AppRoutes.splash.path,
        name: AppRoutes.splash.name,
        pageBuilder: (context, state) {
          return RouteTransitions.none(
            key: state.pageKey,
            child: const SplashPage(),
          );
        },
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppNavigationShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chats.path,
                name: AppRoutes.chats.name,
                builder: (context, state) {
                  return ChatsPage();
                },
                routes: [
                  GoRoute(
                    path: ':chatId',
                    name: 'chatDetails',
                    pageBuilder: (context, state) {
                      final chatId = state.pathParameters['chatId']!;
                      return RouteTransitions.scale(
                        key: state.pageKey,
                        child: ChatDetailsPage(chatId: chatId),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.friends.path,
                name: AppRoutes.friends.name,
                builder: (context, state) {
                  return FriendsPage();
                },
              ),
            ],
          ),

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings.path,
                name: AppRoutes.settings.name,
                builder: (context, state) {
                  return SettingsPage();
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/delete-chat',
        name: 'deleteChat',
        parentNavigatorKey: rootNavigatorKey,
        pageBuilder: (context, state) {
          return RouteTransitions.dialog<bool>(
            key: state.pageKey,
            child: const DeleteChatDialog(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) {
      return const NotFoundPage();
    },
  );
}
