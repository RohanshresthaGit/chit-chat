
import 'package:chit_chat_application/core/navigation/route_transitions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDialogRoute<T> {
  const AppDialogRoute({
    required this.path,
    required this.name,
    required this.builder,
  });

  final String path;
  final String name;

  final Widget Function(BuildContext context, GoRouterState state) builder;

  GoRoute build({
    required GlobalKey<NavigatorState> parentNavigatorKey,
  }) {
    return GoRoute(
      path: path,
      name: name,
      parentNavigatorKey: parentNavigatorKey,
      pageBuilder: (context, state) {
        return RouteTransitions.dialog<T>(
          key: state.pageKey,
          child: builder(context, state),
        );
      },
    );
  }
}
