import 'package:flutter/material.dart';
import 'package:flutter_ping_wire/src/framework/app.dart';

import 'definitions/wire.dart';
import 'navigation_state.dart';
import 'state_manager.dart';

abstract class AbstractRoutingService {
  void navigateTo(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data});

  void navigateBack();

  void navigateToRoot();

  void navigateToNamed(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data});

  void navigateToNamedAndRemoveUntil(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data});

  void navigateAndRemoveUntil(String path, {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data});

  void changeStack(String stackKey, int index, {bool initialLocation = false});

  void changeStackAndNavigate(String stackKey, int index, String path,
      {Map<String, dynamic>? queryParameters, Map<String, dynamic>? data, bool initialLocation = false});
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
}
