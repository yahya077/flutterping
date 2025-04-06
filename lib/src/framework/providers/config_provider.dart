import 'dart:async';
import 'package:flutter/foundation.dart';

import '../app.dart';
import '../config.dart';
import '../definitions/config.dart';
import '../provider.dart';
import '../../wire/config.dart' as wire_config;
import '../../wire/definitions/wire.dart';

/// Service provider responsible for loading configuration with highest priority
class ConfigServiceProvider extends EarlyBootProvider {
  @override
  int get priority => 100; // Highest priority

  // Default app config values
  final Map<String, dynamic> _defaultAppConfig = {
    'app': {
      'name': 'Flutter Ping Wire',
      'version': '1.0.0',
      'debug': true,
      'environment': 'development'
    }
  };

  // Default wire config values
  final Map<String, dynamic> _defaultWireConfig = {
    'clients': {
      'default': {
        'name': 'default',
        'description': 'Default API Client',
        'url': 'https://example.com/api',
        'headers': {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }
      }
    },
    'loaders': {
      'app': {'client': 'default', 'endpoint': '/app', 'method': 'GET'}
    },
    'default_client': 'default'
  };

  @override
  void register(Application app) {
    // Register the app config
    app.singleton(ConfigDefinition.appConfig, () => AppConfig());

    // Register the wire config
    app.singleton(WireDefinition.config, () => wire_config.WireConfig());
  }

  @override
  Future<void> boot(Application app) async {
    // Ensure app config is loaded
    final config = app.make<Config>(ConfigDefinition.appConfig);

    try {
      // Wait for the async initialization
      app.make<Config>(ConfigDefinition.appConfig);

      // If config is empty, add default values
      if (config.all().isEmpty) {
        if (kDebugMode) {
          print('Adding default app config values');
        }

        config.merge(_defaultAppConfig);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading app config, using defaults: $e');
      }

      // If there was an error, try to add default values anyway
      config.merge(_defaultAppConfig);
    }

    // Handle wire config
    try {
      final wireConfig =
          app.make<wire_config.WireConfig>(WireDefinition.config);

      // If wire config is empty, add default values
      if (wireConfig.all().isEmpty) {
        if (kDebugMode) {
          print('Adding default wire config values');
        }

        wireConfig.merge(_defaultWireConfig);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error with wire config, using defaults: $e');
      }

      // If there was an error, try to create a new wire config with default values
      try {
        app.remove(WireDefinition.config);
        app.singleton(WireDefinition.config, () {
          final config = wire_config.WireConfig();
          config.merge(_defaultWireConfig);
          return config;
        });
      } catch (e2) {
        if (kDebugMode) {
          print('Failed to create default wire config: $e2');
        }
      }
    }

    if (kDebugMode) {
      print('Config loaded: ${config.getConfigName()}');
    }
  }
}
