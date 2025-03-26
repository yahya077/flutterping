import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';

abstract class PersistentStorageInterface {
  /// Initialize the storage with configuration
  ///
  /// This should be called before using any storage methods.
  /// Returns a Future that completes when initialization is done.
  Future<void> initialize();

  Future<void> setString(String key, String value);
  Future<String?> getString(String key);
  Future<void> setBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> setInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> setDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> setStringList(String key, List<String> value);
  Future<List<String>?> getStringList(String key);
  Future<void> remove(String key);
  Future<void> save(String key, Map<String, dynamic> data);
  Map<String, dynamic>? load(String key);
  bool exists(String key);
}

/// A hybrid implementation of [PersistentStorageInterface] that combines
/// fast in-memory cache with file-based persistence for the Flutter app.
/// 
/// This implementation doesn't rely on any external packages.
///
/// Usage example with container and automatic initialization:
/// ```dart
/// // In your provider:
/// void register(Application app) {
///   // Register the storage as an async singleton
///   // The container automatically calls initialize() on the instance
///   app.asyncSingleton<PersistentStorageInterface>(
///     WireDefinition.persistentStorage,
///     () => MemoryFileStorage() // Using the direct constructor
///   );
/// }
///
/// // In your main.dart or app initialization:
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   
///   // Get app instance and register providers
///   final app = Application.getInstance();
///   app.register(() => WireProvider());
///   // Register other providers...
///   
///   // Initialize all async services
///   await app.ensureAsyncServicesInitialized();
///   
///   // Now it's safe to run the app
///   runApp(MyApp());
/// }
///
/// // Using the storage in your code:
/// // For synchronous access (if you know it's initialized)
/// final storage = app.make<PersistentStorageInterface>(WireDefinition.persistentStorage);
/// 
/// // For guaranteed async initialization:
/// final storage = await app.makeAsync<PersistentStorageInterface>(WireDefinition.persistentStorage);
/// await storage.setString('key', 'value'); 
/// ```
class MemoryFileStorage implements PersistentStorageInterface {
  // Memory cache for fast access
  final Map<String, dynamic> _memoryCache = {};
  
  // Path where files will be stored (set during initialization)
  late final String _storageDirPath;
  
  // Flag to track initialization state
  bool _isInitialized = false;
  
  /// Constructor
  MemoryFileStorage();

  /// Creates a default storage path in the system's temp directory
  static Future<String> getDefaultStoragePath() async {
    final tempDir = Directory.systemTemp;
    final storagePath = '${tempDir.path}/flutterping_storage';
    
    // Create storage directory if it doesn't exist
    final storageDir = Directory(storagePath);
    if (!await storageDir.exists()) {
      await storageDir.create(recursive: true);
    }
    
    return storagePath;
  }
  
  /// Initialize the storage
  /// 
  /// This implementation will:
  /// 1. Get a default storage path if none is provided
  /// 2. Create the storage directory if it doesn't exist
  /// 3. Load any existing data from disk
  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Use default path if not specified
    final storagePath = await getDefaultStoragePath();
    return initializeWithPath(storagePath);
  }
  
  /// Initialize with a specific storage path
  Future<void> initializeWithPath(String storageDirPath) async {
    if (_isInitialized) return;
    
    _storageDirPath = storageDirPath;
    
    // Ensure the directory exists
    final storageDir = Directory(_storageDirPath);
    if (!await storageDir.exists()) {
      await storageDir.create(recursive: true);
    }
    
    // Load any existing data
    await _loadCacheFromDisk();
    
    _isInitialized = true;
  }
  
  /// Make sure the storage is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      throw StateError('MemoryFileStorage must be initialized before use');
    }
  }
  
  /// Get the file path for a specific key
  String _getFilePath(String key) {
    // Sanitize the key to be a valid filename
    final safeKey = key.replaceAll(RegExp(r'[^\w\s\.-]+'), '_');
    return '$_storageDirPath/$safeKey.json';
  }
  
  /// Load all cached data from disk
  Future<void> _loadCacheFromDisk() async {
    try {
      final storageDir = Directory(_storageDirPath);
      if (!await storageDir.exists()) return;
      
      await for (final fileEntity in storageDir.list()) {
        if (fileEntity is File && fileEntity.path.endsWith('.json')) {
          try {
            final content = await fileEntity.readAsString();
            final data = jsonDecode(content);
            
            // Extract key from filename (removing path and extension)
            final filename = fileEntity.path.split('/').last;
            final key = filename.substring(0, filename.length - 5); // Remove .json
            
            _memoryCache[key] = data;
          } catch (e) {
            if (kDebugMode) {
              print('Error loading file ${fileEntity.path}: $e');
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cache from disk: $e');
      }
    }
  }
  
  /// Save a value to disk
  Future<void> _persistToDisk(String key, dynamic value) async {
    try {
      final file = File(_getFilePath(key));
      final String jsonData = jsonEncode(value);
      await file.writeAsString(jsonData);
    } catch (e) {
      if (kDebugMode) {
        print('Error persisting data for key "$key": $e');
      }
    }
  }
  
  // Implementation of PersistentStorageInterface methods
  
  @override
  Future<void> setString(String key, String value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    await _persistToDisk(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    await _ensureInitialized();
    final value = _memoryCache[key];
    return value is String ? value : null;
  }
  
  @override
  Future<void> setBool(String key, bool value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    await _persistToDisk(key, value);
  }
  
  @override
  Future<bool?> getBool(String key) async {
    await _ensureInitialized();
    final value = _memoryCache[key];
    return value is bool ? value : null;
  }
  
  @override
  Future<void> setInt(String key, int value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    await _persistToDisk(key, value);
  }
  
  @override
  Future<int?> getInt(String key) async {
    await _ensureInitialized();
    final value = _memoryCache[key];
    return value is int ? value : null;
  }
  
  @override
  Future<void> setDouble(String key, double value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    await _persistToDisk(key, value);
  }
  
  @override
  Future<double?> getDouble(String key) async {
    await _ensureInitialized();
    final value = _memoryCache[key];
    return value is double ? value : null;
  }
  
  @override
  Future<void> setStringList(String key, List<String> value) async {
    await _ensureInitialized();
    _memoryCache[key] = value;
    await _persistToDisk(key, value);
  }
  
  @override
  Future<List<String>?> getStringList(String key) async {
    await _ensureInitialized();
    final value = _memoryCache[key];
    if (value is List) {
      return value.cast<String>();
    }
    return null;
  }
  
  @override
  Future<void> remove(String key) async {
    await _ensureInitialized();
    _memoryCache.remove(key);
    
    final file = File(_getFilePath(key));
    if (await file.exists()) {
      await file.delete();
    }
  }
  
  @override
  Future<void> save(String key, Map<String, dynamic> data) async {
    await _ensureInitialized();
    _memoryCache[key] = Map<String, dynamic>.from(data);
    await _persistToDisk(key, data);
  }
  
  @override
  Map<String, dynamic>? load(String key) {
    if (!_isInitialized) return null;
    
    final value = _memoryCache[key];
    print("loaded: $value");
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return null;
  }
  
  @override
  bool exists(String key) {
    if (!_isInitialized) return false;
    return _memoryCache.containsKey(key);
  }
  
  /// Clear all storage - both memory and disk
  Future<void> clear() async {
    await _ensureInitialized();
    _memoryCache.clear();
    
    try {
      final storageDir = Directory(_storageDirPath);
      if (await storageDir.exists()) {
        await storageDir.delete(recursive: true);
        await storageDir.create();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing storage: $e');
      }
    }
  }
  
  /// Get all stored keys
  Set<String> getKeys() {
    if (!_isInitialized) return {};
    return _memoryCache.keys.toSet();
  }
} 