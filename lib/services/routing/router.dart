import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'observer.dart';
import 'paths.dart';


/// Application navigation.
///
/// For Navigation use: [AppNavigator.router]
class AppNavigator {
  static final GlobalKey<NavigatorState> parentNavigatorKey = GlobalKey<NavigatorState>();
  static late final GoRouter router;

  static BuildContext get context => router.routerDelegate.navigatorKey.currentContext!;
  static GoRouterDelegate get routerDelegate => router.routerDelegate;
  static GoRouteInformationParser get routeInformationParser => router.routeInformationParser;

  static final NavigatorObserver observer = AppNavigatorObserver();

  static void init() {
    AppNavigator._internal();
  }

  AppNavigator._internal() {
    final routes = <RouteBase>[];

    router = GoRouter(
      navigatorKey: parentNavigatorKey,
      observers: [AppNavigator.observer],
      initialLocation: RoutePath.root,
      routes: routes,
    );
  }
}
