import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/wire/scope_state.dart';

import 'app_state.dart';
import 'state.dart';

class StateManager {
  final Application application;
  final AppState _appState = AppState(state: {});

  StateManager(this.application);

  T get<T>(String stateId, String key, {T? defaultValue}) {
    return getState<State>(stateId).get<T>(key, defaultValue: defaultValue);
  }

  T getState<T>(String stateId) {
    return _appState.getState(stateId) as T;
  }

  bindScope(String scopeKey, Map<String, dynamic> scopeContext) {
    _appState.addState(
        ScopeState(state: {"id": "scoped_state_$scopeKey", ...scopeContext}));
  }

  ScopeState getScope(String scopeKey) {
    return _appState.getState<ScopeState>("scoped_state_$scopeKey");
  }

  disposeScope(String scopeKey) {
    _appState.removeState("scoped_state_$scopeKey");
  }

  void set<T>(String stateId, String key, T value) {
    _appState.getState(stateId).set(key, value);
  }

  void setAll(String stateId, Map<String, dynamic> other) {
    _appState.getState(stateId).setAll(other);
  }

  void remove(String stateId) {
    _appState.removeState(stateId);
  }

  void hydrate(Map<String, dynamic> state) {
    _appState.hydrate(state);
  }

  Map<String, dynamic> dehydrate() {
    return _appState.dehydrate();
  }

  void dispose() {
    _appState.dispose();
  }

  void disposeState(String stateId) {
    _appState.getState(stateId).dispose();
  }

  dynamic dynamicGet(String key) {
    final List<String> keys = key.split(".");

    if (keys.length == 1) {
      return _appState.getState(keys[0]);
    } else {
      dynamic value = _appState.getState(keys[0]);

      keys.removeAt(0);

      for (var key in keys) {
        if (value is Map<String, dynamic>) {
          value = value[key];
        } else if (value is State) {
          value = value.get<dynamic>(key);
        } else {
          throw Exception("Invalid key $key");
        }
      }

      return value;
    }
  }

  AbstractState addState(AbstractState state) {
    _appState.addState(state);

    return state;
  }
}
