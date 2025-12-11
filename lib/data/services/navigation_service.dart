import 'package:flutter/material.dart';
import 'package:gauva_driver/core/routes/app_routes.dart';

import '../../core/utils/helpers.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static bool _isNavigatingToLogin = false;

  /// Navigates to login and removes all previous routes
  static void navigateToLogin() {
    if (_isNavigatingToLogin) return;
    _isNavigatingToLogin = true;

    navigatorKey.currentState?.pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);

    Future.delayed(const Duration(seconds: 1), () {
      _isNavigatingToLogin = false;
    });
  }

  /// Push a named route
  static Future<dynamic>? pushNamed(String route, {Object? arguments}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.pushNamed(context, route, arguments: arguments);
    } else {
      return null;
    }
  }

  /// Push a new route and remove all previous routes
  static Future<dynamic>? pushNamedAndRemoveUntil(String route, {Object? arguments, RoutePredicate? predicate}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        predicate ?? (_) => false, // handle default here
        arguments: arguments,
      );
    } else {
      return null;
    }
  }

  /// Replace current screen with a named route
  static Future<dynamic>? pushReplacementNamed(String route, {Object? arguments}) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      return Navigator.pushReplacementNamed(context, route, arguments: arguments);
    } else {
      return null;
    }
  }

  /// Pop the current screen
  static void pop<T extends Object?>([T? result]) {
    if (navigatorKey.currentState?.canPop() ?? false) {
      navigatorKey.currentState?.pop(result);
    } else {
      showNotification(message: "Can't go previous. There is no page available!");
    }
  }

  /// Pop until a certain route name
  static void popUntil(String routeName) {
    navigatorKey.currentState?.popUntil(ModalRoute.withName(routeName));
  }

  /// Check if can pop
  static bool canPop() => navigatorKey.currentState?.canPop() ?? false;
}
