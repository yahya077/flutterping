import 'dart:convert';

abstract class AbstractState {
  String getId();

  void set<T>(String key, T value);

  void setAll(Map<String, dynamic> other);

  T get<T>(String key, {T? defaultValue});

  void dispose();

  void hydrate(Map<String, dynamic> state);

  Map<String, dynamic> dehydrate();

  Object? dehydrateAsJson();
}

class State implements AbstractState {
  final Map<String, dynamic> _state = {};

  State({required Map<String, dynamic> state}) {
    hydrate(state);
  }

  State.withId(String id) {
    hydrate({'id': id});
  }

  @override
  void set<T>(String key, T value) {
    _state[key] = value;
  }

  @override
  void setAll(Map<String, dynamic> other) {
    _state.addAll(other);
  }

  bool has(String key) {
    return _state.containsKey(key);
  }

  void remove(String key) {
    _state.remove(key);
  }

  @override
  T get<T>(String key, {T? defaultValue}) {
    final T? value = _state[key];

    if (value == null) {
      if (defaultValue != null) {
        return defaultValue;
      }
      throw Exception('State key $key not found');
    }

    return value;
  }

  void addNestedState(String key, AbstractState state) {
    final List<String> keys = key.split(".");

    if (keys.length == 1) {
      set(key, state);
    } else {
      final String firstKey = keys.removeAt(0);
      final AbstractState parent = get(firstKey);

      if (parent is State) {
        parent.addNestedState(keys.join("."), state);
      } else {
        throw Exception("Invalid key $key");
      }
    }
  }

  @override
  void hydrate(Map<String, dynamic> state) {
    _state.addAll(state);
  }

  @override
  Map<String, dynamic> dehydrate() {
    final Map<String, dynamic> result = {};
    _state.forEach((key, value) {
      if (value is AbstractState) {
        result[key] = value.dehydrate();
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  @override
  Object? dehydrateAsJson() {
    return jsonEncode(_state);
  }

  @override
  void dispose() {
    _state.clear();
  }

  T getDynamic<T>(String key) {
    return _state[key] as T;
  }

  each(Function(String key, dynamic value) callback) {
    _state.forEach((key, value) {
      callback(key, value);
    });
  }

  factory State.fromJson(Map<String, dynamic> json) => State(
        state: json,
      );

  @override
  String getId() {
    return get('id');
  }
}
