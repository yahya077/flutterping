import 'package:flutter_ping_wire/src/framework/app.dart';

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

  void set<T>(String stateId, String key, T value) {
    _appState.getState(stateId).set(key, value);
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