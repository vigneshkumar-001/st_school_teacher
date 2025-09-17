import 'package:flutter/material.dart';

class CustomNavigation {
  static Future<T?> pushFadeScale<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.push<T>(
      context,
      PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          );
        },
      ),
    );
  }

  /// Optional: Replace current route (for login flows etc.)
  static Future<T?> pushReplacementFadeScale<T>(
    BuildContext context,
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return Navigator.pushReplacement<T, T>(
      context,
      PageRouteBuilder(
        transitionDuration: duration,
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fadeAnimation = Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation);
          final scaleAnimation = Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(animation);

          return FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          );
        },
      ),
    );
  }
}
