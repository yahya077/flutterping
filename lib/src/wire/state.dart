import 'dart:convert';
import 'package:flutter_ping_wire/src/framework/persistent_storage.dart';

/// Abstract interface for state management
abstract class StateInterface {
  /// Set the persistent storage implementation
  void setPersistentStorage(PersistentStorageInterface storage);

  /// Set the persistent storage implementation
  PersistentStorageInterface? getPersistentStorage();

  /// Get the unique identifier for this state
  String getId();

  /// Set a value for a specific key
  void set<T>(String key, T value);

  /// Set multiple values at once
  void setAll(Map<String, dynamic> values);

  /// Get a value by key with optional default value
  T get<T>(String key, {T? defaultValue});

  /// Clear all state resources
  void dispose();

  /// Load state from external data
  void hydrate(Map<String, dynamic> state);

  /// Load and merge state from external data
  void hydrateAndMerge(Map<String, dynamic> state);

  /// Convert state to serializable format
  Map<String, dynamic> dehydrate();

  /// Convert state to JSON format
  Object? dehydrateAsJson();

  /// Event triggered when state is set
  void onSet(String key, dynamic value);

  /// Event triggered when all state is modified
  void onSetAll(Map<String, dynamic> values);

  /// Event triggered when state is hydrated
  void onHydrate(Map<String, dynamic> state);

  /// Event triggered when state is removed
  void onRemove(String key);

  /// Event triggered before state is disposed
  void onDispose();
}

/// Implementation of state management
class State implements StateInterface {
  final Map<String, dynamic> _data = {};
  bool isPersistent = false;
  PersistentStorageInterface? persistentStorage;

  // Define which fields should be persisted using dot notation for nested fields ({'headers.Authorization','baseUrl'})
  Set<String> _persistentFields = {};

  /// Create state with initial values
  State({
    required Map<String, dynamic> state,
    this.persistentStorage,
    Set<String>? persistentFields,
  }) {
    if (persistentFields != null) {
      _persistentFields = persistentFields;
    }

    hydrate(state);

    // Load from persistent storage if available
    if (persistentStorage != null && persistentStorage!.exists(getId())) {
      try {
        final persistedData = persistentStorage!.load(getId());
        if (persistedData != null) {
          hydrateAndMerge(persistedData);
        }
      } catch (e) {
        // Silently handle loading errors
      }
    }
  }

  /// Create state with only an ID
  State.withId(
    String id, {
    this.persistentStorage,
    this.isPersistent = false,
    Set<String>? persistentFields,
  }) {
    if (persistentFields != null) {
      _persistentFields = persistentFields;
    }
    hydrate({'id': id});

    // Load from persistent storage if available
    if (persistentStorage != null && persistentStorage!.exists(getId())) {
      try {
        final persistedData = persistentStorage!.load(getId());
        if (persistedData != null) {
          hydrateAndMerge(persistedData);
        }
      } catch (e) {
        // Silently handle loading errors
      }
    }
  }

  bool getIsPersistentState() {
    return isPersistent;
  }

  void setIsPersistentState(bool value) {
    isPersistent = value;
  }

  /// Store current state to persistent storage if available
  void _persistState() {
    if (persistentStorage != null) {
      try {
        if (_persistentFields.isEmpty) {
          // If no specific fields are marked for persistence, persist entire state
          persistentStorage!.save(getId(), dehydrate());
        } else {
          // Otherwise, only persist the specified fields
          persistentStorage!.save(getId(), _dehydrateSelectedFields());
        }
      } catch (e) {
        // Silently handle persistence errors
      }
    }
  }

  /// Dehydrate only the selected fields for persistence
  Map<String, dynamic> _dehydrateSelectedFields() {
    try {
      final Map<String, dynamic> result = {};
      for (String persistentField in _persistentFields) {
        final List<String> segments = persistentField.split('.');
        if (segments.length == 1) {
          result[segments[0]] = _data[segments[0]];
        } else if (segments.length == 2) {
          final String key = segments[0];
          final String field = segments[1];
          if (!result.containsKey(key)) {
            result[key] = {};
          }

          result[key][field] = _data[key][field];
        }
      }
      return result;
    } catch (e, stackTrace) {
      throw StateException(
          'Failed to dehydrate selected fields: ${e.toString()}, with: ${stackTrace.toString()}');
    }
  }

  /// Set the fields that should be persisted
  void setPersistentFields(Set<String> fields) {
    _persistentFields = fields;
  }

  /// Get the currently configured persistent fields
  Set<String> getPersistentFields() {
    return Set.from(_persistentFields);
  }

  @override
  void setPersistentStorage(PersistentStorageInterface storage) {
    persistentStorage = storage;
  }

  @override
  PersistentStorageInterface? getPersistentStorage() {
    return persistentStorage;
  }

  @override
  void set<T>(String key, T value) {
    _data[key] = value;
    onSet(key, value);
    _persistState();
  }

  @override
  void setAll(Map<String, dynamic> values) {
    _data.addAll(values);
    onSetAll(values);
    _persistState();
  }

  /// Check if key exists in state
  bool has(String key) {
    return _data.containsKey(key);
  }

  /// Remove a key from state
  void remove(String key) {
    _data.remove(key);
    onRemove(key);
    _persistState();
  }

  @override
  T get<T>(String key, {T? defaultValue}) {
    if (!has(key)) {
      if (defaultValue != null) {
        return defaultValue;
      }
      throw StateException('Key "$key" not found in state');
    }

    final value = _data[key];
    if (value is T) {
      return value;
    } else {
      throw StateException(
          'Type mismatch for key "$key": expected ${T.toString()} but got ${value.runtimeType}');
    }
  }

  /// Add nested state at path
  void addNestedState(String path, StateInterface state) {
    final List<String> segments = path.split(".");

    if (segments.length == 1) {
      set(path, state);
    } else {
      final String firstSegment = segments.removeAt(0);

      try {
        final StateInterface parent = get(firstSegment);
        if (parent is State) {
          parent.addNestedState(segments.join("."), state);
        } else {
          throw StateException(
              "Cannot add nested state: parent at '$firstSegment' is not a State object");
        }
      } catch (e) {
        throw StateException(
            "Failed to add nested state at path '$path': ${e.toString()}");
      }
    }
    _persistState();
  }

  @override
  void hydrate(Map<String, dynamic> state) {
    _data.addAll(state);
    onHydrate(state);
    _persistState();
  }

  @override
  void hydrateAndMerge(Map<String, dynamic> state) {
    state.forEach((key, value) {
      if (value is Map<String, dynamic> && has(key)) {
        final existingValue = _data[key];

        if (existingValue is Map<String, dynamic>) {
          // If existing value is a Map, merge the maps
          final Map<String, dynamic> merged = Map.from(existingValue);
          merged.addAll(value);
          _data[key] = merged;
        } else if (existingValue is StateInterface) {
          // If existing value is a State, hydrate it with the map
          existingValue.hydrateAndMerge(value);
        } else {
          // Otherwise just set the new value
          _data[key] = value;
        }
      } else {
        // For non-map values or non-existing keys, just set the value
        _data[key] = value;
      }
    });
    onHydrate(state);
    _persistState();
  }

  @override
  Map<String, dynamic> dehydrate() {
    final Map<String, dynamic> result = {};
    _data.forEach((key, value) {
      if (value is StateInterface) {
        result[key] = value.dehydrate();
      } else if (value is Uri) {
        // Convert Uri to string for JSON serialization
        result[key] = value.toString();
      } else if (value is DateTime) {
        // Convert DateTime to ISO string for JSON serialization
        result[key] = value.toIso8601String();
      } else {
        result[key] = value;
      }
    });
    return result;
  }

  @override
  Object? dehydrateAsJson() {
    try {
      return jsonEncode(dehydrate());
    } catch (e) {
      throw StateException('Failed to convert state to JSON: ${e.toString()}');
    }
  }

  @override
  void dispose() {
    onDispose();
    if (persistentStorage != null) {
      try {
        persistentStorage!.remove(getId());
      } catch (e) {
        // Silently handle deletion errors
      }
    }
    _data.clear();
  }

  /// Get a value with dynamic typing (use with caution)
  T getDynamic<T>(String key) {
    try {
      return _data[key] as T;
    } catch (e) {
      throw StateException(
          'Failed to cast value for key "$key" to ${T.toString()}: ${e.toString()}');
    }
  }

  /// Iterate through all state entries
  void forEach(void Function(String key, dynamic value) callback) {
    _data.forEach(callback);
  }

  /// Create a state object from JSON data
  factory State.fromJson(
    Map<String, dynamic> json, {
    PersistentStorageInterface? persistentStorage,
    Set<String>? persistentFields,
  }) =>
      State(
        state: json,
        persistentStorage: persistentStorage,
        persistentFields: persistentFields,
      );

  @override
  String getId() {
    return get('id');
  }

  @override
  void onSet(String key, dynamic value) {
    // Base implementation does nothing - override in subclasses
  }

  @override
  void onSetAll(Map<String, dynamic> values) {
    // Base implementation does nothing - override in subclasses
  }

  @override
  void onHydrate(Map<String, dynamic> state) {
    // Base implementation does nothing - override in subclasses
  }

  @override
  void onRemove(String key) {
    // Base implementation does nothing - override in subclasses
  }

  @override
  void onDispose() {
    // Base implementation does nothing - override in subclasses
  }
}

/// Custom exception for state operations
class StateException implements Exception {
  final String message;

  StateException(this.message);

  @override
  String toString() => 'StateException: $message';
}
