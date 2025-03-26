import '../app.dart';
import '../persistent_storage.dart';
import '../provider.dart';

/// Definition constants for storage bindings
class StorageDefinition {
  static const String persistentStorage = 'PersistentStorage';
}

/// Service provider responsible for managing persistent storage services
class PersistentStorageProvider extends CoreServiceProvider {
  @override
  int get priority => 70; // Lower than config (100), higher than regular services
  
  @override
  void register(Application app) {
    // Register the storage system as a regular singleton
    // We'll initialize it in the boot method
    app.singleton<PersistentStorageInterface>(
      StorageDefinition.persistentStorage,
      () => MemoryFileStorage()
    );
  }
  
  @override
  Future<void> boot(Application app) async {
    // Get the storage instance
    final storage = app.make<PersistentStorageInterface>(
      StorageDefinition.persistentStorage
    );
    
    // Initialize the storage
    await storage.initialize();
    
    // At this point, the storage system is fully initialized
    print('Persistent storage initialized successfully');
  }
} 