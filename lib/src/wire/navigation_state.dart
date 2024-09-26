import 'package:flutter/material.dart' as material;

import 'definitions/wire.dart';
import 'state.dart';

class NavigationState extends State {
  NavigationState({required Map<String, dynamic> state}) : super(state: state);

  NavigationState.initial() : super(state: {}) {
    hydrate({
      'id': WireDefinition.stateNavigationState,
      'navigatorKeys': {
        "mainNavigatorKey": material.GlobalKey<material.NavigatorState>(),
      },
      'stackKeys': <String, dynamic>{},
    });
  }

  setInitialLocation(String location) {
    set('initialLocation', location);
  }

  addStackKey(String stackKey, dynamic value) {
    final stackKeys = get('stackKeys', defaultValue: {});

    if (stackKeys.isEmpty) {
      set('stackKeys', {
        stackKey: value,
      });
    }

    stackKeys[stackKey] = value;

    set('stackKeys', stackKeys);
  }

  addNavigatorKey(String navigatorKeyId, material.GlobalKey<material.NavigatorState> navigatorKey) {
    Map<String, material.GlobalKey<material.NavigatorState>> navigatorKeys = get('navigatorKeys', defaultValue: {});
    navigatorKeys[navigatorKeyId] = navigatorKey;

    set('navigatorKeys', navigatorKeys);
  }

  getInitialLocation() {
    return get('initialLocation');
  }

  Map<String, dynamic> getStackKeys() {
    return get('stackKeys', defaultValue: {});
  }

  material.GlobalKey<material.NavigatorState> getMainNavigatorKey() {
    Map<String, dynamic> navigatorKeys = get('navigatorKeys', defaultValue: {});

    return navigatorKeys['mainNavigatorKey'];
  }

  void setMainNavigatorKey(material.GlobalKey<material.NavigatorState> key) {
    Map<String, dynamic> navigatorKeys = get('navigatorKeys', defaultValue: {});

    navigatorKeys['mainNavigatorKey'] = key;

    set('navigatorKeys', navigatorKeys);
  }

  dynamic getStackKey(String stackKey) {
    Map<String, dynamic> stackKeys = get('stackKeys', defaultValue: <String, dynamic>{});

    return stackKeys[stackKey];
  }

  material.GlobalKey<material.NavigatorState> getNavigatorKey(String navigatorKey) {
    Map<String, dynamic> navigatorKeys = get('navigatorKeys', defaultValue: {});

    return navigatorKeys[navigatorKey];
  }

  Map<String, String> getPathParameters(String navigatorKey) {
    return get('pathParameters_$navigatorKey', defaultValue: <String, String>{});
  }

  void setPathParameters(String navigatorKey, Map<String, String> pathParameters) {
    set('pathParameters_$navigatorKey', pathParameters);
  }

  Object? getExtra(String navigatorKey) {
    return get('extra_$navigatorKey');
  }

  void setExtra(String navigatorKey, Object? extra) {
    set('extra_$navigatorKey', extra);
  }

  void disposePathParameters(String navigatorKey) {
    remove('pathParameters_$navigatorKey');
  }

  void disposeStackKey(String stackKey) {
    Map<String, dynamic> stackKeys = get('stackKeys', defaultValue: <String, dynamic>{});

    stackKeys.remove(stackKey);

    set('stackKeys', stackKeys);
  }

  void disposeNavigatorKey(String navigatorKey) {
    Map<String, dynamic> navigatorKeys = get('navigatorKeys', defaultValue: {});

    navigatorKeys.remove(navigatorKey);

    set('navigatorKeys', navigatorKeys);
  }

  void dispose() {
    remove('navigatorKeys');
    remove('stackKeys');
    remove('initialLocation');
  }
}
