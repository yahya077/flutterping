import 'app.dart';

/// Interface for all service providers
abstract class ServiceProvider {
  /// Priority for load order (higher values load first)
  int get priority => 0;
  
  /// Whether this provider should be deferred until needed
  bool get deferred => false;
  
  /// List of services that this provider defers
  List<String> get deferredServices => const [];
  
  /// Register bindings with the container
  void register(Application app);
  
  /// Boot the provider (called after all providers are registered)
  Future<void> boot(Application app) async {}
  
  /// Get the services provided by this provider
  List<String> get provides => deferredServices;
}

/// Basic provider implementation
class Provider implements ServiceProvider {
  @override
  int get priority => 0;
  
  @override
  bool get deferred => false;
  
  @override
  List<String> get deferredServices => const [];
  
  @override
  List<String> get provides => deferredServices;
  
  @override
  void register(Application app) {
    // Default implementation - override in subclasses
  }
  
  @override
  Future<void> boot(Application app) async {
    // Default implementation - override in subclasses
  }
}

/// A provider that runs at high priority (early in the boot process)
abstract class EarlyBootProvider extends Provider {
  @override
  int get priority => 90;
}

/// A provider for core system services
abstract class CoreServiceProvider extends Provider {
  @override
  int get priority => 80;
}

/// A provider for framework features
abstract class FrameworkServiceProvider extends Provider {
  @override
  int get priority => 50;
}

/// A provider for application-specific features
abstract class ApplicationServiceProvider extends Provider {
  @override
  int get priority => 0;
}

/// A deferred provider that loads only when needed
abstract class DeferredServiceProvider extends Provider {
  @override
  bool get deferred => true;
  
  @override
  int get priority => -50;
  
  /// Deferred providers must override this to specify which services they provide
  @override
  List<String> get deferredServices;
}
