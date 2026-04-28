import 'dart:developer' as dev;

import 'package:flutter/material.dart';


/// Route observer.
class AppNavigatorObserver extends NavigatorObserver {

  /// Internal logger
  void _log(String message) {
    dev.log(message, name: runtimeType.toString());
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('Pushed: ${route.settings.name}');
    _log('Previous: ${previousRoute?.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('Popped: ${route.settings.name}');
    _log('Back to: ${previousRoute?.settings.name}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('Removed: ${route.settings.name}');
    _log('Previous: ${previousRoute?.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _log('Replaced: ${oldRoute?.settings.name} with ${newRoute?.settings.name}');
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log('User gesture started on: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {
    _log('User gesture stopped');
  }
}