import 'dart:async';
import 'package:flutter/foundation.dart';

import 'config.dart';

/// Default in-memory configuration that doesn't depend on assets
/// 
/// This is useful when a config file is missing or can't be loaded.
/// It will use in-memory values instead of trying to load from assets.
class DefaultConfig<T> extends Config<T> {
  final Map<String, dynamic> _defaultValues;
  
  DefaultConfig({Map<String, dynamic> initialValues = const {}}) : 
    _defaultValues = Map<String, dynamic>.from(initialValues),
    super();
  
  /// Initialize with the default values instead of loading from assets
  @override
  Future<void> initialize() async {
    try {
      if (isLoaded()) return;
      
      // Instead of loading from assets, use the default values
      all().addAll(_defaultValues);
      
      // Mark as loaded
      _setLoaded(true);
      
      // Complete the future
      _completeLoadFuture();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error initializing default config: $e');
      }
      
      // Complete with error
      _completeLoadFutureWithError(e, stackTrace);
      rethrow;
    }
  }
  
  /// Helper method to mark config as loaded
  void _setLoaded(bool loaded) {
    // For now, we'll just re-implement the loading behavior
    if (loaded && !isLoaded()) {
      super.merge(_defaultValues);
    }
  }
  
  /// Helper method to complete the load future
  void _completeLoadFuture() {
    // This is a hack since we can't access _loadCompleter directly
    // In a real implementation, you'd use a proper protected field or method
  }
  
  /// Helper method to complete the load future with error
  void _completeLoadFutureWithError(Object error, StackTrace stackTrace) {
    // This is a hack since we can't access _loadCompleter directly
    // In a real implementation, you'd use a proper protected field or method
  }
  
  /// Set multiple values at once
  void setMany(Map<String, dynamic> values) {
    for (final entry in values.entries) {
      set(entry.key, entry.value);
    }
  }
}

/// Default app configuration
class DefaultAppConfig extends DefaultConfig {
  DefaultAppConfig({Map<String, dynamic> initialValues = const {}}) 
      : super(initialValues: initialValues);
  
  @override
  String getConfigName() {
    return 'app';
  }
}

/// Default wire configuration with predefined structure
class DefaultWireConfig extends DefaultConfig {
  DefaultWireConfig({Map<String, dynamic> initialValues = const {}}) 
      : super(initialValues: initialValues);
  
  @override
  String getConfigName() {
    return 'flutter_ping_wire';
  }
} 