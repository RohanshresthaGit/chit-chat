import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract final class RouteTransitions {
  static const Duration defaultDuration = Duration(milliseconds: 300);

  static CustomTransitionPage<void> fade({
    required LocalKey key,
    required Widget child,
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      );
      return FadeTransition(opacity: curvedAnimation, child: child);
    },
  );

  static CustomTransitionPage<void> slide({
    required LocalKey key,
    required Widget child,
    Offset beginOffset = const Offset(1.0, 0.0),
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
      );
      return SlideTransition(
        position: Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );

  static CustomTransitionPage<void> scale({
    required LocalKey key,
    required Widget child,
    double beginScale = 0.92,
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutCubic,
      );
      return ScaleTransition(
        scale: Tween<double>(
          begin: beginScale,
          end: 1.0,
        ).animate(curvedAnimation),
        child: child,
      );
    },
  );

  static CustomTransitionPage<void> fadeSlide({
    required LocalKey key,
    required Widget child,
    Offset beginScale = const Offset(0.4, 0.0),
    Duration duration = defaultDuration,
  }) => CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: beginScale,
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        ),
      );
    },
  );

  static CustomTransitionPage<T> dialog<T>({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
      child: child,
    );
  }

  static CustomTransitionPage<void> none({
    required LocalKey key,
    required Widget child,
  }) {
    return CustomTransitionPage<void>(
      key: key,
      child: child,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }
}
