import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'app_state.dart';

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

  void merge<T>(String stateId, String key, T value) {
    if (value is Map<String, dynamic>) {
      Map<String, dynamic>? oldMap = get<Map<String, dynamic>?>(stateId, key);

      if (oldMap != null) {
        oldMap.addAll(value as Map<String, dynamic>);
        set(stateId, key, oldMap);
      } else {
        set(stateId, key, value);
      }
    } else {
      throw Exception("Invalid value type ${value.runtimeType}");
    }
  }

  void setByKey<T>(String stateKey, T value) {
    final List<String> keys = stateKey.split(".");

    if (keys.length == 1) {
      _appState.getState(keys[0]).set(keys[0], value);
    } else {
      State state = _appState.getState(keys[0]);
      dynamic current = state;

      for (int i = 1; i < keys.length - 1; i++) {
        if (current is Map<String, dynamic>) {
          current = current[keys[i]];
        } else if (current is State) {
          current = current.get<dynamic>(keys[i]);
        } else {
          throw Exception("Invalid key ${keys[i]}");
        }
      }

      if (current is Map<String, dynamic>) {
        State parentState = _appState.getState(keys[0]);
        Map<String, dynamic> updatedMap = Map.from(current);
        updatedMap[keys.last] = value;
        parentState.set(keys[1], updatedMap);
      } else if (current is State) {
        current.set(keys.last, value);
      } else {
        throw Exception("Invalid key ${keys.last}");
      }
    }
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

  T dynamicGet<T>(String key, {T? defaultValue}) {
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
          value = value.get<dynamic>(key, defaultValue: defaultValue);
        } else {
          throw Exception("Invalid key $key");
        }
      }

      return value as T;
    }
  }

  StateInterface addState(StateInterface state) {
    _appState.addState(state);

    return state;
  }

  StateInterface addNestedState(String key, StateInterface state) {
    _appState.addNestedState(key, state);

    return state;
  }
}
