import 'dart:io';

/// Manage application environments
class Environment {
  /// Current environment
  static String? _currentEnvironment;
  
  /// Get the current application environment
  static String current() {
    if (_currentEnvironment != null) {
      return _currentEnvironment!;
    }
    
    // Check environment variables
    _currentEnvironment = _getEnvironmentFromSystem();
    
    // Default to production if not set
    return _currentEnvironment ?? 'production';
  }
  
  /// Set the application environment
  static void set(String environment) {
    _currentEnvironment = environment;
  }
  
  /// Check if current environment matches the given environment
  static bool is_(String environment) {
    return current() == environment;
  }
  
  /// Check if running in local environment
  static bool isLocal() {
    return is_('local') || is_('development');
  }
  
  /// Check if running in production environment
  static bool isProduction() {
    return is_('production');
  }
  
  /// Check if running in testing environment
  static bool isTesting() {
    return is_('testing');
  }
  
  /// Get environment from system
  static String? _getEnvironmentFromSystem() {
    // Check for explicitly set environment variable
    if (Platform.environment.containsKey('APP_ENV')) {
      return Platform.environment['APP_ENV'];
    }
    
    // Check for Flutter's mode
    if (Platform.environment.containsKey('FLUTTER_MODE')) {
      final mode = Platform.environment['FLUTTER_MODE'];
      
      if (mode == 'debug' || mode == 'development') {
        return 'local';
      } else if (mode == 'profile') {
        return 'staging';
      } else if (mode == 'release') {
        return 'production';
      }
    }
    
    return null;
  }
} 