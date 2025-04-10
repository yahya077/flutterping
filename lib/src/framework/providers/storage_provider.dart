import '../app.dart';
import '../persistent_storage.dart';
import '../provider.dart';
import '../app_lifecycle.dart';
import '../../wire/utils/file_logger.dart';

/// Definition constants for storage bindings
class StorageDefinition {
  static const String persistentStorage = 'PersistentStorage';
}

/// Service provider responsible for managing persistent storage services
class PersistentStorageProvider extends CoreServiceProvider {
  @override
  int get priority =>
      70; // Lower than config (100), higher than regular services

  @override
  void register(Application app) {
    // We need to initialize the file logger early in the app's lifecycle
    // but we shouldn't create empty log files
    FileLogger.log('FlutterPing startup: Registration phase');

    // Register the storage system as a regular singleton
    app.singleton<PersistentStorageInterface>(
        StorageDefinition.persistentStorage, () => MemoryFileStorage());
  }

  @override
  Future<void> boot(Application app) async {
    await FileLogger.log('PersistentStorageProvider: Booting storage service');

    // Get the storage instance
    final storage = app
        .make<PersistentStorageInterface>(StorageDefinition.persistentStorage);

    // Initialize the storage
    await storage.initialize();

    // Register app lifecycle state to ensure data is persisted on app exit
    _registerAppLifecycleHandlers(app, storage);

    // At this point, the storage system is fully initialized
    await FileLogger.log('Persistent storage initialized successfully');
    await FileLogger.log(
        'Current memory cache: ${storage is MemoryFileStorage ? (storage as MemoryFileStorage).getKeys().length : "Unknown"} keys');

    await FileLogger.log('Log file location: ${FileLogger.getLogFilePath()}');
  }

  void _registerAppLifecycleHandlers(
      Application app, PersistentStorageInterface storage) {
    // Create the lifecycle observer but don't store it since we're not using it later
    AppLifecycleObserver(storage);
    FileLogger.log('Registered lifecycle handlers for storage sync');
  }
}
