import 'package:flutter/material.dart';
import 'package:flutter_ping_wire/src/framework/app.dart';

import 'definitions/wire.dart';
import 'navigation_state.dart';
import 'state_manager.dart';

abstract class AbstractRoutingService {
  void navigateTo(String navigatorKey, String path, {Map<String, dynamic>? queryParameters, Map<String, String>? pathParameters, Map<String, dynamic>? data});

  void navigateBack(String navigatorKey);

  void navigateToRoot(String navigatorKey);

  void navigateToNamed(String navigatorKey, String path, {Map<String, dynamic>? queryParameters, Map<String, String>? pathParameters, Map<String, dynamic>? data});

  void navigateToNamedAndRemoveUntil(String navigatorKey, String path, {Map<String, dynamic>? queryParameters, Map<String, String>? pathParameters, Map<String, dynamic>? data});

  void navigateAndRemoveUntil(String navigatorKey, String path, {Map<String, dynamic>? queryParameters, Map<String, String>? pathParameters, Map<String, dynamic>? data});

  void changeStack(String stackKey, int index, {bool initialLocation = false});

  void changeStackAndNavigate(String navigatorKey, String stackKey, int index, String path,
      {Map<String, dynamic>? queryParameters, Map<String, String>? pathParameters, Map<String, dynamic>? data, bool initialLocation = false});
}

abstract class RoutingService implements AbstractRoutingService {
  final Application application;

  RoutingService(this.application);

  setInitialLocation(String initialLocation) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .setInitialLocation(initialLocation);
  }

  addNavigatorKey(
      String navigatorKeyId, GlobalKey<NavigatorState> navigatorKey) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .addNavigatorKey(navigatorKeyId, navigatorKey);
  }

  addStackKeys(String stackKey, dynamic value) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .addStackKey(stackKey, value);
  }

  getInitialLocation() {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getInitialLocation();
  }

  getStackKeys() {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getStackKeys();
  }

  GlobalKey<NavigatorState> getMainNavigatorKey() {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getMainNavigatorKey();
  }

  void setMainNavigatorKey(GlobalKey<NavigatorState> key) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .setMainNavigatorKey(key);
  }

  getStackKey(String stackKey) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getStackKey(stackKey);
  }

  GlobalKey<NavigatorState> getNavigatorKey(String navigatorKey) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getNavigatorKey(navigatorKey);
  }

  Map<String, String> getPathParameters(String navigatorKey) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getPathParameters(navigatorKey);
  }

  Object? getExtra(String navigatorKey) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .getExtra(navigatorKey);
  }
}
