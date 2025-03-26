import 'dart:async';
import 'dart:io';

import 'app_exception_handler.dart';
import 'config.dart';
import 'container.dart';
import 'definitions/config.dart';
import 'definitions/containers.dart';
import 'definitions/logger.dart';
import 'dispatcher.dart';
import 'environment.dart';
import 'log_manager.dart';
import 'provider.dart';
import 'providers/config_provider.dart';

class Application extends Container {
  /// All registered service providers
  final List<ServiceProvider> _serviceProviders = [];
  
  /// Providers that have been booted
  final List<ServiceProvider> _bootedProviders = [];
  
  /// Deferred services and their providers
  final Map<String, String> _deferredServices = {};
  
  /// Whether the application is in testing mode
  final bool _testing;
  
  /// Indicates if application has been bootstrapped
  bool _hasBeenBootstrapped = false;
  
  /// Indicates if the application has been fully booted
  bool _initialized = false;
  
  /// Tracks if boot process is in progress
  bool _booting = false;
  
  /// Completer for the boot process
  Completer<void>? _bootCompleter;
  
  /// Application version
  static const String version = '1.0.0';
  
  /// The base path of the application
  late String _basePath;
  
  /// The storage path of the application
  String? _storagePath;
  
  /// Callbacks to be run before bootstrapping
  final Map<String, List<Function>> _beforeBootstrappingCallbacks = {};
  
  /// Callbacks to be run after bootstrapping
  final Map<String, List<Function>> _afterBootstrappingCallbacks = {};
  
  /// Callbacks to be run before booting
  final List<Function> _bootingCallbacks = [];
  
  /// Callbacks to be run after booting
  final List<Function> _bootedCallbacks = [];
  
  /// Callbacks to be run on application termination
  final List<Function> _terminatingCallbacks = [];
  
  /// Singleton instance
  static Application? _instance;

  Application._({bool testing = false, String? basePath}) 
      : _testing = testing,
        super.newContainer() {
        
    // Set base path
    if (basePath != null) {
      setBasePath(basePath);
    } else {
      // Default to current directory
      setBasePath(Directory.current.path);
    }
    
    _registerBaseBindings();
    
    // Register the config provider as an internal component
    // This ensures config is loaded before any other services
    register(ConfigServiceProvider());
    
    // Set environment to testing if in testing mode
    if (testing) {
      Environment.set('testing');
    }
  }

  static Application getInstance({bool testing = false, String? basePath}) {
    _instance ??= Application._(testing: testing, basePath: basePath);
    return _instance!;
  }
  
  /// Get the version number of the application
  String getVersion() {
    return version;
  }
  
  /// Set the base path for the application
  void setBasePath(String path) {
    _basePath = path.endsWith(Platform.pathSeparator) ? path.substring(0, path.length - 1) : path;
    _bindPathsInContainer();
  }
  
  /// Get the base path of the application
  String basePath([String? path]) {
    if (path == null || path.isEmpty) {
      return _basePath;
    }
    
    return joinPaths(_basePath, path);
  }
  
  /// Get the path to the application directory
  String appPath([String? path]) {
    return joinPaths(basePath('lib'), path);
  }
  
  /// Get the storage path for the application
  String storagePath([String? path]) {
    final storagePath = _storagePath ?? basePath('storage');
    return joinPaths(storagePath, path);
  }
  
  /// Set a custom storage path
  void useStoragePath(String path) {
    _storagePath = path;
    singleton('path.storage', () => path);
  }
  
  /// Join paths together
  String joinPaths(String basePath, String? path) {
    if (path == null || path.isEmpty) {
      return basePath;
    }
    
    // Remove any trailing slashes from base path
    if (basePath.endsWith(Platform.pathSeparator)) {
      basePath = basePath.substring(0, basePath.length - 1);
    }
    
    // Remove any leading slashes from path
    if (path.startsWith(Platform.pathSeparator)) {
      path = path.substring(1);
    }
    
    return '$basePath${Platform.pathSeparator}$path';
  }
  
  /// Bind all paths in the container
  void _bindPathsInContainer() {
    // Register path bindings
    singleton('path.base', () => _basePath);
    singleton('path.app', () => appPath());
    singleton('path.storage', () => storagePath());
  }

  void _registerBaseBindings() {
    // Register the app instance
    singleton('app', () => this);
    
    // Core exception handler
    singleton(ContainerDefinition.appExceptionHandler,
        () => AppExceptionHandler(this));

    // Event dispatcher
    singleton(ContainerDefinition.events, () => Dispatcher());

    // Logging system
    final logManager = LogManager({
      LogDefinition.channelFramework: FrameworkLogAdapter(),
    });

    singleton(ContainerDefinition.logger, () => logManager);
  }

  /// Register a service provider
  void register(ServiceProvider provider) {
    // Check if this provider type is already registered
    if (_serviceProviders.any((p) => p.runtimeType == provider.runtimeType)) {
      throw Exception("Provider already registered: ${provider.runtimeType}");
    }
    
    // Register the provider
    provider.register(this);
    _serviceProviders.add(provider);
    
    // Register any deferred services
    if (provider.deferredServices.isNotEmpty) {
      for (final service in provider.deferredServices) {
        _deferredServices[service] = provider.runtimeType.toString();
      }
    }
    
    // Sort providers by priority
    _serviceProviders.sort((a, b) => b.priority.compareTo(a.priority));
  }
  
  /// Register a provider factory method that returns a ServiceProvider
  void registerProvider(ServiceProvider Function() providerFactory) {
    final provider = providerFactory();
    register(provider);
  }

  void dispatch(String event) {
    make<Dispatcher>(ContainerDefinition.events).dispatch(event);
  }
  
  /// Run the given array of bootstrappers
  void bootstrapWith(List<Function(Application)> bootstrappers) {
    _hasBeenBootstrapped = true;

    for (final bootstrapper in bootstrappers) {
      // Fire before bootstrapping callbacks
      _fireCallbacks(_beforeBootstrappingCallbacks[bootstrapper.toString()] ?? []);

      try {
        // Bootstrap with the given bootstrapper
        final bootstrapperInstance = bootstrapper(this);
        bootstrapperInstance.bootstrap();
      } catch (e) {
        print('Error bootstrapping with ${bootstrapper.toString()}: $e');
      }

      // Fire after bootstrapping callbacks
      _fireCallbacks(_afterBootstrappingCallbacks[bootstrapper.toString()] ?? []);
    }
  }
  
  /// Register a callback to run before a bootstrapper
  void beforeBootstrapping(String bootstrapper, Function callback) {
    _beforeBootstrappingCallbacks[bootstrapper] ??= [];
    _beforeBootstrappingCallbacks[bootstrapper]!.add(callback);
  }
  
  /// Register a callback to run after a bootstrapper
  void afterBootstrapping(String bootstrapper, Function callback) {
    _afterBootstrappingCallbacks[bootstrapper] ??= [];
    _afterBootstrappingCallbacks[bootstrapper]!.add(callback);
  }
  
  /// Determine if the application has been bootstrapped
  bool hasBeenBootstrapped() {
    return _hasBeenBootstrapped;
  }
  
  /// Register a callback to be run before the application is booted
  void booting(Function callback) {
    _bootingCallbacks.add(callback);
  }
  
  /// Register a callback to be run after the application is booted
  void booted(Function callback) {
    _bootedCallbacks.add(callback);
    
    // If already booted, run the callback immediately
    if (_initialized) {
      callback(this);
    }
  }
  
  /// Boot all service providers
  Future<void> boot() async {
    // If already booting, return the existing boot operation
    if (_booting && _bootCompleter != null) {
      return _bootCompleter!.future;
    }
    
    // If already booted, just return
    if (_initialized) {
      return;
    }
    
    _booting = true;
    _bootCompleter = Completer<void>();
    
    try {
      // Fire booting callbacks
      _fireCallbacks(_bootingCallbacks);

      for (final provider in _serviceProviders) {
        if (!_bootedProviders.contains(provider) && !provider.deferred) {
          await _bootProvider(provider);
        }
      }
      
      _initialized = true;
      
      // Fire booted callbacks
      _fireCallbacks(_bootedCallbacks);
      
      _bootCompleter!.complete();
    } catch (e, stackTrace) {
      _bootCompleter!.completeError(e, stackTrace);
      rethrow;
    } finally {
      _booting = false;
    }
    
    return _bootCompleter!.future;
  }
  
  /// Boot a specific service provider
  Future<void> _bootProvider(ServiceProvider provider) async {
    if (_bootedProviders.contains(provider)) {
      return;
    }
    
    // Call the boot method on the provider
    await provider.boot(this);
    
    // Mark provider as booted
    _bootedProviders.add(provider);
  }
  
  /// Check if the application is fully booted
  bool isBooted() {
    return _initialized;
  }
  
  /// Ensure the application is booted before proceeding
  Future<void> ensureBooted() async {
    if (_initialized) return;
    return boot();
  }
  
  /// Get or check the current application environment
  dynamic environment([List<String>? environments]) {
    if (environments != null && environments.isNotEmpty) {
      return environments.contains(Environment.current());
    }
    
    return Environment.current();
  }
  
  /// Determine if the application is in the local environment
  bool isLocal() {
    return Environment.isLocal();
  }
  
  /// Determine if the application is in the production environment
  bool isProduction() {
    return Environment.isProduction();
  }
  
  /// Determine if the application is in the testing environment
  bool isTestingEnvironment() {
    return Environment.isTesting();
  }
  
  /// Access the testing state
  bool isTesting() {
    return _testing;
  }
  
  /// Register a terminating callback
  void terminating(Function callback) {
    _terminatingCallbacks.add(callback);
  }
  
  /// Terminate the application
  void terminate() {
    _fireCallbacks(_terminatingCallbacks);
  }
  
  /// Fire application callbacks
  void _fireCallbacks(List<Function> callbacks) {
    for (var i = 0; i < callbacks.length; i++) {
      callbacks[i](this);
    }
  }
  
  /// Load a deferred provider if needed
  void _loadDeferredProviderIfNeeded(String abstract) {
    if (isDeferredService(abstract) && !hasBinding(abstract)) {
      _loadDeferredProvider(abstract);
    }
  }
  
  /// Load a deferred service provider
  void _loadDeferredProvider(String service) {
    if (!isDeferredService(service)) {
      return;
    }
    
    final providerName = _deferredServices[service];
    
    // Find the provider by name
    final provider = _serviceProviders.firstWhere(
      (p) => p.runtimeType.toString() == providerName,
      orElse: () => throw Exception('Deferred provider $providerName not found')
    );
    
    // Boot the provider if not already booted
    if (!_bootedProviders.contains(provider)) {
      _bootProvider(provider);
    }
  }
  
  /// Check if the given service is deferred
  bool isDeferredService(String service) {
    return _deferredServices.containsKey(service);
  }
  
  /// Get all registered service providers
  List<ServiceProvider> getProviders() {
    return List.unmodifiable(_serviceProviders);
  }
  
  @override
  T make<T>(String abstract, [List<dynamic> parameters = const []]) {
    // Load deferred provider if needed before resolving
    _loadDeferredProviderIfNeeded(abstract);
    
    return super.make<T>(abstract, parameters);
  }
}
