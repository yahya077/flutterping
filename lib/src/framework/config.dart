import 'dart:async';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

/// Convert a YamlMap to a regular Map<String, dynamic>
Map<String, dynamic> yamlToMap(YamlMap yamlMap) {
  final Map<String, dynamic> result = {};
  
  for (final entry in yamlMap.entries) {
    final key = entry.key.toString();
    final value = _convertYamlNode(entry.value);
    result[key] = value;
  }
  
  return result;
}

/// Convert any YAML node to its corresponding Dart type
dynamic _convertYamlNode(dynamic yaml) {
  if (yaml is YamlMap) {
    return yamlToMap(yaml);
  } else if (yaml is YamlList) {
    return yaml.map(_convertYamlNode).toList();
  } else {
    return yaml;
  }
}

abstract class AbstractConfig<T> {
  /// Get the config name used for loading the config file
  String getConfigName();
  
  /// Get a config value by key
  dynamic get(String key);
  
  /// Set a config value
  void set(String key, dynamic value);
  
  /// Get all config values as a map
  Map<String, dynamic> all();
  
  /// Ensure config is loaded and return all values
  Future<Map<String, dynamic>> ensureAll();
  
  /// Get all config values as a strongly typed object
  T allAs();
  
  /// Ensure config is loaded and return all values as a typed object
  Future<T> ensureAllAs();
  
  /// Initialize the config (load from sources)
  Future<void> initialize();
  
  /// Merge additional config values
  void merge(Map<String, dynamic> values);
  
  /// Check if config has been loaded
  bool isLoaded();
}

class Config<T> implements AbstractConfig<T> {
  final Map<String, dynamic> _config = {};
  final Completer<void> _loadCompleter = Completer<void>();
  bool _loaded = false;
  
  /// Constructor initializes config loading but doesn't block
  Config() {
    // Start loading asynchronously without awaiting
    initialize();
  }

  @override
  String getConfigName() {
    return 'default';
  }
  
  @override
  bool isLoaded() {
    return _loaded;
  }

  @override
  dynamic get(String key) {
    if (!_loaded) {
      print('Warning: Accessing config key "$key" before config is loaded');
    }
    
    final parts = key.split('.');
    Map current = _config;
    
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      
      if (i == parts.length - 1) {
        return current[part];
      }
      
      if (current[part] is! Map) {
        return null;
      }
      
      current = current[part] as Map;
    }
    
    return null;
  }

  @override
  void set(String key, dynamic value) {
    final parts = key.split('.');
    var current = _config;
    
    for (int i = 0; i < parts.length; i++) {
      final part = parts[i];
      
      if (i == parts.length - 1) {
        current[part] = value;
        return;
      }
      
      if (!current.containsKey(part) || current[part] is! Map) {
        current[part] = <String, dynamic>{};
      }
      
      current = current[part] as Map<String, dynamic>;
    }
  }

  @override
  Map<String, dynamic> all() {
    if (!_loaded) {
      print('Warning: Accessing all config values before config is loaded');
    }
    return _config;
  }

  @override
  Future<Map<String, dynamic>> ensureAll() async {
    if (!_loaded) {
      await _loadCompleter.future;
    }
    return all();
  }

  @override
  T allAs() {
    throw UnimplementedError('Subclasses should implement allAs()');
  }

  @override
  Future<T> ensureAllAs() async {
    if (!_loaded) {
      await _loadCompleter.future;
    }
    return allAs();
  }
  
  @override
  void merge(Map<String, dynamic> values) {
    _deepMerge(_config, values);
  }
  
  /// Deep merge two maps
  void _deepMerge(Map<String, dynamic> target, Map<String, dynamic> source) {
    for (final key in source.keys) {
      if (source[key] is Map<String, dynamic> && 
          target.containsKey(key) && 
          target[key] is Map<String, dynamic>) {
        // If both values are maps, merge them recursively
        _deepMerge(
          target[key] as Map<String, dynamic>,
          source[key] as Map<String, dynamic>
        );
      } else {
        // Otherwise just override
        target[key] = source[key];
      }
    }
  }
  
  /// Load config from sources
  /// This can be overridden to support different config sources
  @override
  Future<void> initialize() async {
    try {
      if (_loaded) return;
      
      await _loadFromYaml();
      
      _loaded = true;
      if (!_loadCompleter.isCompleted) {
        _loadCompleter.complete();
      }
    } catch (e, stackTrace) {
      if (!_loadCompleter.isCompleted) {
        _loadCompleter.completeError(e, stackTrace);
      }
      rethrow;
    }
  }
  
  /// Load config from YAML file
  Future<void> _loadFromYaml() async {
    try {
      final String yamlString = await rootBundle.loadString('assets/config/${getConfigName()}.yml');
      final YamlMap yamlMap = loadYaml(yamlString);
      
      // Use our utility function to convert YamlMap to Map<String, dynamic>
      final Map<String, dynamic> configMap = yamlToMap(yamlMap);
      _config.addAll(configMap);
    } catch (e) {
      print('Error loading config from YAML: $e');
      // Don't rethrow - we want to continue initialization even if config is missing
    }
  }
}

class AppConfig extends Config {
  AppConfig() : super();

  @override
  String getConfigName() {
    return 'app';
  }
}

