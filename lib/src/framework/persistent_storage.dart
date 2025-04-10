import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '../wire/utils/file_logger.dart';
import 'package:flutter/widgets.dart'
    show AppLifecycleState, WidgetsBindingObserver, WidgetsBinding;

/// A persistent storage interface that defines methods for storing and retrieving data.
///
/// This interface provides a contract for implementing persistent storage solutions
/// that can store various data types and handle app lifecycle changes.
abstract class PersistentStorageInterface {
  /// Initializes the storage with configuration.
  ///
  /// Must be called before using any storage methods.
  /// Returns a Future that completes when initialization is done.
  Future<void> initialize();

  /// Stores a string value with the given key.
  Future<void> setString(String key, String value);

  /// Retrieves a string value for the given key.
  /// Returns null if the key doesn't exist.
  Future<String?> getString(String key);

  /// Stores a boolean value with the given key.
  Future<void> setBool(String key, bool value);

  /// Retrieves a boolean value for the given key.
  /// Returns null if the key doesn't exist.
  Future<bool?> getBool(String key);

  /// Stores an integer value with the given key.
  Future<void> setInt(String key, int value);

  /// Retrieves an integer value for the given key.
  /// Returns null if the key doesn't exist.
  Future<int?> getInt(String key);

  /// Stores a double value with the given key.
  Future<void> setDouble(String key, double value);

  /// Retrieves a double value for the given key.
  /// Returns null if the key doesn't exist.
  Future<double?> getDouble(String key);

  /// Stores a list of strings with the given key.
  Future<void> setStringList(String key, List<String> value);

  /// Retrieves a list of strings for the given key.
  /// Returns null if the key doesn't exist.
  Future<List<String>?> getStringList(String key);

  /// Removes a value from storage for the given key.
  Future<void> remove(String key);

  /// Saves a map of data with the given key.
  Future<void> save(String key, Map<String, dynamic> data);

  /// Loads a map of data for the given key.
  /// Returns null if the key doesn't exist.
  Map<String, dynamic>? load(String key);

  /// Checks if a key exists in storage.
  bool exists(String key);
}

/// Custom lifecycle observer that only handles storage-related events
class _StorageLifecycleObserver with WidgetsBindingObserver {
  final Function(AppLifecycleState) onStateChange;

  _StorageLifecycleObserver(this.onStateChange) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onStateChange(state);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

/// A reliable persistent storage implementation that combines in-memory cache with file-based persistence.
///
/// This implementation is designed to prevent data loss during rapid app exit cycles
/// by prioritizing critical data writes and managing background operations.
class MemoryFileStorage implements PersistentStorageInterface {
  // Memory cache for fast access
  final Map<String, dynamic> _memoryCache = {};

  // Path where files will be stored
  late final String _storagePath;

  // Initialization state
  bool _isInitialized = false;

  // Operation queues with different priorities
  final _criticalQueue = _OperationQueue(highPriority: true);
  final _regularQueue = _OperationQueue();

  // App state tracking
  bool _isInBackground = false;
  bool _isTerminating = false;
  Timer? _flushTimer;
  _StorageLifecycleObserver? _lifecycleObserver;

  /// Creates a new instance of MemoryFileStorage.
  ///
  /// Sets up app lifecycle monitoring to manage data persistence during app state changes.
  MemoryFileStorage() {
    _lifecycleObserver = _StorageLifecycleObserver(_handleLifecycleChange);
  }

  /// Gets the default storage path in the system's temp directory.
  ///
  /// Creates the directory if it doesn't exist.
  static Future<String> getDefaultStoragePath() async {
    final tempDir = Directory.systemTemp;
    final storagePath = '${tempDir.path}/flutterping_storage';

    final dir = Directory(storagePath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return storagePath;
  }

  /// Gets the current storage path.
  ///
  /// Throws a [StateError] if called before initialization.
  String getStoragePath() {
    if (!_isInitialized) {
      throw StateError('Storage must be initialized before getting path');
    }
    return _storagePath;
  }

  @override
  Future<void> initialize() async {
    if (_isInitialized) {
      await FileLogger.log('Storage already initialized');
      return;
    }

    try {
      _storagePath = await getDefaultStoragePath();
      await FileLogger.log('Initializing storage at $_storagePath');

      // Load existing keys (in the background)
      _preloadKeys();

      // Start background flush timer
      _startFlushTimer();

      _isInitialized = true;
      await FileLogger.log('Storage initialized successfully');
      await logCacheStatus();
    } catch (e) {
      await FileLogger.log('Error initializing storage: $e');
      rethrow;
    }
  }

  /// Starts a timer to periodically flush data to disk.
  void _startFlushTimer() {
    _flushTimer?.cancel();
    _flushTimer = Timer.periodic(Duration(milliseconds: 500), (_) {
      if (!_isTerminating) {
        _backgroundFlush();
      }
    });
  }

  /// Performs a background flush with timeout to prevent blocking.
  Future<void> _backgroundFlush() async {
    if (!_isInitialized) return;

    // Skip if already flushing or no operations are pending
    if (_criticalQueue.isEmpty && _regularQueue.isEmpty) return;

    try {
      // Use a timeout to avoid blocking the app
      await _criticalQueue.flushWithTimeout(Duration(milliseconds: 200));

      // Only flush regular queue if app is in foreground
      if (!_isInBackground) {
        await _regularQueue.flushWithTimeout(Duration(milliseconds: 100));
      }
    } catch (e) {
      await FileLogger.log('Background flush error: $e');
    }
  }

  /// Preloads existing keys from storage without blocking the main thread.
  void _preloadKeys() {
    Future<void> doPreload() async {
      try {
        final dir = Directory(_storagePath);
        if (!await dir.exists()) {
          await dir.create(recursive: true);
          return;
        }

        final files = await dir
            .list()
            .where((entity) => entity is File && entity.path.endsWith('.json'))
            .toList();

        await FileLogger.log(
            'Found ${files.length} files in storage directory');

        // Preload up to 5 files for immediate access
        final filesToPreload = files.take(5).map((f) => f.path).toList();

        for (final path in filesToPreload) {
          final key = path.split('/').last.replaceAll('.json', '');
          _loadFromDisk(key);
        }
      } catch (e) {
        FileLogger.log('Error preloading keys: $e');
      }
    }

    // Run preloading in the background
    unawaited(doPreload());
  }

  /// Handles app lifecycle changes to manage data persistence.
  void _handleLifecycleChange(AppLifecycleState state) {
    FileLogger.log('App lifecycle state changed to: $state');

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _isInBackground = true;

      if (state == AppLifecycleState.detached) {
        _isTerminating = true;

        // Cancel timer to avoid watchdog triggers
        _flushTimer?.cancel();

        // Final critical flush with short timeout
        _criticalQueue.flushWithTimeout(Duration(milliseconds: 50));
      } else {
        // Flush critical data in background
        unawaited(_criticalQueue.flushWithTimeout(Duration(milliseconds: 500)));
      }
    } else if (state == AppLifecycleState.resumed) {
      _isInBackground = false;
      _isTerminating = false;

      // Restart flush timer if needed
      if (_flushTimer == null || !_flushTimer!.isActive) {
        _startFlushTimer();
      }
    }
  }

  /// Loads a value from disk asynchronously.
  Future<dynamic> _loadFromDisk(String key) async {
    if (_isTerminating) return null;

    final file = File('$_storagePath/$key.json');

    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        final data = jsonDecode(content);

        // Update memory cache
        _memoryCache[key] = data;

        return data;
      } catch (e) {
        await FileLogger.log('Error loading $key from disk: $e');
      }
    }

    return null;
  }

  /// Saves a value to disk using an atomic operation to prevent data corruption.
  Future<void> _saveToDisk(String key, dynamic value) async {
    if (_isTerminating) {
      await FileLogger.log('Skipping disk write during app termination');
      return;
    }

    try {
      final content = jsonEncode(value);

      final file = File('$_storagePath/$key.json');
      final tempFile = File('$_storagePath/$key.json.tmp');

      final dir = Directory(_storagePath);
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      // Write to temp file first
      await tempFile.writeAsString(content, flush: true);

      // Atomically replace the original file
      if (await file.exists()) {
        await file.delete();
      }

      await tempFile.rename(file.path);
    } catch (e) {
      await FileLogger.log('Error saving $key to disk: $e');
    }
  }

  /// Ensures the storage is initialized before any operation.
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw StateError('Storage must be initialized before use');
    }
  }

  @override
  Future<void> setString(String key, String value) async {
    _ensureInitialized();

    // Update memory cache immediately
    _memoryCache[key] = value;

    // Queue disk operation if not terminating
    if (!_isTerminating) {
      _regularQueue.enqueue(() => _saveToDisk(key, value));
    }

    return Future.value();
  }

  @override
  Future<String?> getString(String key) async {
    _ensureInitialized();

    // Check memory cache first
    if (_memoryCache.containsKey(key)) {
      final value = _memoryCache[key];
      return value is String ? value : null;
    }

    // Load from disk if not in memory and not terminating
    if (!_isTerminating) {
      final value = await _loadFromDisk(key);
      return value is String ? value : null;
    }

    return null;
  }

  @override
  Future<void> setBool(String key, bool value) async {
    _ensureInitialized();

    _memoryCache[key] = value;

    if (!_isTerminating) {
      _regularQueue.enqueue(() => _saveToDisk(key, value));
    }

    return Future.value();
  }

  @override
  Future<bool?> getBool(String key) async {
    _ensureInitialized();

    if (_memoryCache.containsKey(key)) {
      final value = _memoryCache[key];
      return value is bool ? value : null;
    }

    if (!_isTerminating) {
      final value = await _loadFromDisk(key);
      return value is bool ? value : null;
    }

    return null;
  }

  @override
  Future<void> setInt(String key, int value) async {
    _ensureInitialized();

    _memoryCache[key] = value;

    if (!_isTerminating) {
      _regularQueue.enqueue(() => _saveToDisk(key, value));
    }

    return Future.value();
  }

  @override
  Future<int?> getInt(String key) async {
    _ensureInitialized();

    if (_memoryCache.containsKey(key)) {
      final value = _memoryCache[key];
      return value is int ? value : null;
    }

    if (!_isTerminating) {
      final value = await _loadFromDisk(key);
      return value is int ? value : null;
    }

    return null;
  }

  @override
  Future<void> setDouble(String key, double value) async {
    _ensureInitialized();

    _memoryCache[key] = value;

    if (!_isTerminating) {
      _regularQueue.enqueue(() => _saveToDisk(key, value));
    }

    return Future.value();
  }

  @override
  Future<double?> getDouble(String key) async {
    _ensureInitialized();

    if (_memoryCache.containsKey(key)) {
      final value = _memoryCache[key];
      return value is double ? value : null;
    }

    if (!_isTerminating) {
      final value = await _loadFromDisk(key);
      return value is double ? value : null;
    }

    return null;
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    _ensureInitialized();

    _memoryCache[key] = value;

    if (!_isTerminating) {
      _regularQueue.enqueue(() => _saveToDisk(key, value));
    }

    return Future.value();
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    _ensureInitialized();

    if (_memoryCache.containsKey(key)) {
      final value = _memoryCache[key];
      if (value is List) {
        return value.cast<String>();
      }
      return null;
    }

    if (!_isTerminating) {
      final value = await _loadFromDisk(key);
      if (value is List) {
        return value.cast<String>();
      }
    }

    return null;
  }

  @override
  Future<void> remove(String key) async {
    _ensureInitialized();

    _memoryCache.remove(key);

    if (!_isTerminating) {
      _regularQueue.enqueue(() async {
        final file = File('$_storagePath/$key.json');
        if (await file.exists()) {
          await file.delete();
        }
      });
    }

    return Future.value();
  }

  @override
  Future<void> save(String key, Map<String, dynamic> data) async {
    _ensureInitialized();

    // Check for auth token
    bool isAuthToken = false;
    if (data.containsKey('headers') &&
        data['headers'] is Map &&
        (data['headers'] as Map).containsKey('Authorization')) {
      await FileLogger.log('Saving auth token for key: $key');
      isAuthToken = true;
    }

    _memoryCache[key] = Map<String, dynamic>.from(data);

    if (!_isTerminating) {
      if (isAuthToken) {
        // Critical data - use critical queue
        _criticalQueue.enqueue(() => _saveToDisk(key, data));
      } else {
        // Regular data
        _regularQueue.enqueue(() => _saveToDisk(key, data));
      }
    }

    return Future.value();
  }

  @override
  Map<String, dynamic>? load(String key) {
    _ensureInitialized();

    // Only return if already in memory (synchronous operation)
    final value = _memoryCache[key];
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    // Trigger async load for future access if not terminating
    if (!_isTerminating && !_memoryCache.containsKey(key)) {
      unawaited(_loadFromDisk(key));
    }

    return null;
  }

  @override
  bool exists(String key) {
    _ensureInitialized();

    // Only check memory cache
    return _memoryCache.containsKey(key);
  }

  /// Gets all stored keys in the memory cache.
  Set<String> getKeys() {
    _ensureInitialized();
    return _memoryCache.keys.toSet();
  }

  /// Logs the current status of the memory cache.
  Future<void> logCacheStatus() async {
    final keys = _memoryCache.keys.toList();
    await FileLogger.log(
        'Memory cache contains ${keys.length} keys: ${keys.join(', ')}');
  }

  /// Forces immediate sync to disk for critical data.
  ///
  /// Returns true if the sync was successful, false otherwise.
  Future<bool> forceSyncToDisk(String key) async {
    _ensureInitialized();

    await FileLogger.log('Force syncing key: $key');

    if (!_memoryCache.containsKey(key)) {
      await FileLogger.log('Cannot force sync - key not in memory cache');
      return false;
    }

    try {
      if (!_isTerminating) {
        final data = _memoryCache[key];

        final completer = Completer<void>();

        // Set a safety timeout
        final timeout = Timer(Duration(milliseconds: 200), () {
          if (!completer.isCompleted) {
            completer.complete();
            FileLogger.log('Force sync timeout - continuing without waiting');
          }
        });

        // Start the save operation
        final saveOperation = _saveToDisk(key, data);

        // Complete when save is done or timeout occurs
        unawaited(saveOperation.then((_) {
          if (!completer.isCompleted) {
            completer.complete();
            FileLogger.log('Force sync completed for $key');
          }
          timeout.cancel();
        }, onError: (e) {
          if (!completer.isCompleted) {
            completer.completeError(e);
            FileLogger.log('Force sync failed for $key: $e');
          }
          timeout.cancel();
        }));

        // Wait for completion or timeout
        await completer.future;
      }

      return true;
    } catch (e) {
      await FileLogger.log('Error during force sync: $e');
      return false;
    }
  }

  /// Flushes all pending operations to disk.
  Future<void> flush() async {
    _ensureInitialized();

    if (_isTerminating) {
      await FileLogger.log('Skipping flush during app termination');
      return;
    }

    await FileLogger.log('Flushing pending operations');

    try {
      await _criticalQueue.flushWithTimeout(Duration(milliseconds: 200));

      if (!_isTerminating) {
        await _regularQueue.flushWithTimeout(Duration(milliseconds: 500));
      }

      await FileLogger.log('Flush completed');
    } catch (e) {
      await FileLogger.log('Error during flush: $e');
    }
  }

  /// Cleans up resources used by the storage.
  void dispose() {
    _lifecycleObserver?.dispose();
    _flushTimer?.cancel();
    FileLogger.log('Storage disposed');
  }
}

/// Queue for managing storage operations with priority.
class _OperationQueue {
  final Queue<_Operation> _queue = Queue();
  bool _processing = false;
  bool _flushing = false;
  final bool highPriority;

  _OperationQueue({this.highPriority = false});

  /// Checks if queue is empty.
  bool get isEmpty => _queue.isEmpty && !_processing;

  /// Adds an operation to the queue.
  Future<void> enqueue(Future<void> Function() operation) {
    final completer = Completer<void>();
    final op = _Operation(operation, completer);

    _queue.add(op);
    _processQueue();

    // For non-critical operations, complete immediately to avoid blocking
    if (!highPriority) {
      completer.complete();
    }

    return completer.future;
  }

  /// Processes the operation queue sequentially.
  void _processQueue() {
    if (_processing || _queue.isEmpty) return;

    _processing = true;

    Future<void> processNext() async {
      if (_queue.isEmpty) {
        _processing = false;
        return;
      }

      final operation = _queue.removeFirst();

      try {
        await operation.function();
        if (!operation.completer.isCompleted && highPriority) {
          operation.completer.complete();
        }
      } catch (e, stack) {
        if (!operation.completer.isCompleted && highPriority) {
          operation.completer.completeError(e, stack);
        } else {
          FileLogger.log('Operation error: $e\n$stack');
        }
      } finally {
        await processNext();
      }
    }

    unawaited(processNext());
  }

  /// Flushes queue with timeout to prevent blocking.
  Future<void> flushWithTimeout(Duration timeout) async {
    if (_queue.isEmpty && !_processing) {
      return;
    }

    if (_flushing) {
      return; // Already flushing
    }

    _flushing = true;

    try {
      final completer = Completer<void>();

      // Set timeout for safety
      final timer = Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.complete();
          FileLogger.log('Flush timeout - continuing without waiting');
        }
      });

      // Add marker operation
      final markerOp = _Operation(() async {
        if (!completer.isCompleted) {
          completer.complete();
          timer.cancel();
        }
      }, Completer<void>());

      _queue.add(markerOp);
      _processQueue();

      // Wait until either marker is processed or timeout occurs
      await completer.future;
    } finally {
      _flushing = false;
    }
  }
}

/// Operation to be queued for execution.
class _Operation {
  final Future<void> Function() function;
  final Completer<void> completer;

  _Operation(this.function, this.completer);
}

/// Simple queue implementation for operation management.
class Queue<T> {
  final List<T> _list = [];

  void add(T item) {
    _list.add(item);
  }

  T removeFirst() {
    if (_list.isEmpty) {
      throw StateError('Cannot remove from empty queue');
    }
    return _list.removeAt(0);
  }

  bool get isEmpty => _list.isEmpty;
}

/// Marks a future as not needing to be awaited.
///
/// Used to prevent blocking when waiting for non-critical operations.
void unawaited(Future<void> future) {
  future.catchError((e, stack) {
    FileLogger.log('Unhandled error in unawaited future: $e\n$stack');
    return null;
  });
}
