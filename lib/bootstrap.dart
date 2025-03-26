import 'package:flutter/foundation.dart';

import 'src/framework/app.dart';
import 'src/framework/environment.dart';
import 'src/framework/maintenance/maintenance_mode.dart';
import 'src/framework/providers/storage_provider.dart';

/// Bootstrap class for application initialization
class Bootstrap {
  /// Initialize the application
  static Future<Application> init({
    String? basePath,
    bool testing = false,
    List<Function(Application)>? bootstrappers,
  }) async {
    // Create a new application instance
    final Application app = Application.getInstance(
      testing: testing,
      basePath: basePath,
    );
    
    // Register maintenance mode
    app.singleton('maintenance.mode', () => FileMaintenanceMode(app));

    // Register core service providers
    app.register(PersistentStorageProvider());
    
    // Register bootstrappers if provided
    if (bootstrappers != null && bootstrappers.isNotEmpty) {
      app.bootstrapWith(bootstrappers);
    }
    
    // Display info about environment in debug mode
    if (kDebugMode) {
      print('Bootstrapping application in ${Environment.current()} environment');
      
      // Check for maintenance mode
      final maintenanceMode = app.make<MaintenanceMode>('maintenance.mode');
      if (maintenanceMode.isActive()) {
        print('WARNING: Application is in maintenance mode');
      }
    }
    
    // Boot the application - this initializes all services
    await app.boot();
    
    if (kDebugMode) {
      print('Application bootstrapped successfully!');
      print('Version: ${app.getVersion()}');
    }
    
    // Register termination handler
    app.terminating((app) {
      if (kDebugMode) {
        print('Application terminated');
      }
    });
    
    return app;
  }
}