import 'dart:async';
import 'package:flutter/widgets.dart';
import '../wire/utils/file_logger.dart';
import 'persistent_storage.dart';

/// Observer class that handles Flutter app lifecycle events with focus on data persistence
class AppLifecycleObserver with WidgetsBindingObserver {
  final PersistentStorageInterface _storage;
  Timer? _persistenceTimer;
  bool _flushInProgress = false;
  final int _flushTimeoutMs = 1000; // 1 second timeout for flush operations

  AppLifecycleObserver(this._storage) {
    // Register with the Flutter binding
    WidgetsBinding.instance.addObserver(this);

    // Log that observer is initialized
    FileLogger.log('AppLifecycleObserver initialized');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Use non-awaited future to avoid blocking the main thread
    // This is critical to prevent watchdog termination (0x8BADF00D)
    _handleLifecycleChange(state);
  }

  // Use non-blocking operations to handle lifecycle changes
  Future<void> _handleLifecycleChange(AppLifecycleState state) async {
    await FileLogger.log('App lifecycle state changed to: $state');

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      // App is going to background or being terminated
      await FileLogger.log(
          'App leaving foreground (${state.name}), ensuring all data is persisted');

      // Cancel any existing timer
      _persistenceTimer?.cancel();

      // Log current cache state before flushing
      if (_storage is MemoryFileStorage) {
        unawaited((_storage as MemoryFileStorage).logCacheStatus());
      }

      // For any termination state, use a timeout to prevent blocking
      if (state == AppLifecycleState.detached) {
        // App is being terminated - start flush but with timeout
        unawaited(_flushWithTimeout());
      } else {
        // App going to background - use small delay and timeout
        _persistenceTimer = Timer(const Duration(milliseconds: 50), () {
          unawaited(_flushWithTimeout());
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      // App is back to foreground
      await FileLogger.log('App resumed to foreground');

      // Cancel any pending persistence timer
      _persistenceTimer?.cancel();

      // Check if memory cache matches persistent storage (non-blocking)
      if (_storage is MemoryFileStorage) {
        unawaited((_storage as MemoryFileStorage).logCacheStatus());
      }
    }
  }

  Future<void> _flushWithTimeout() async {
    if (_flushInProgress) return;

    _flushInProgress = true;
    try {
      await FileLogger.log('Starting flush with timeout');

      // Create a timeout that will complete after _flushTimeoutMs
      final timeoutCompleter = Completer<void>();
      Timer(Duration(milliseconds: _flushTimeoutMs), () {
        if (!timeoutCompleter.isCompleted) {
          timeoutCompleter.complete();
          FileLogger.log('Flush operation timed out after $_flushTimeoutMs ms');
        }
      });

      // Start the actual flush operation
      final flushFuture = _storage is MemoryFileStorage
          ? (_storage as MemoryFileStorage).flush()
          : Future.value();

      // Wait for either the flush to complete or the timeout to expire
      await Future.any([flushFuture, timeoutCompleter.future]);

      if (!timeoutCompleter.isCompleted) {
        // If we get here, the flush completed before the timeout
        timeoutCompleter.complete();
        await FileLogger.log('Flush completed successfully before timeout');

        // Log final cache state after flushing (non-blocking)
        if (_storage is MemoryFileStorage) {
          unawaited((_storage as MemoryFileStorage).logCacheStatus());
        }
      }
    } catch (e) {
      await FileLogger.log('ERROR during flush: $e');
    } finally {
      _flushInProgress = false;
    }
  }

  /// Dispose the observer when no longer needed
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _persistenceTimer?.cancel();
    FileLogger.log('AppLifecycleObserver disposed');
  }
}

/// Mark a future as not needing to be awaited
/// This is used to avoid blocking the main thread during app termination
void unawaited(Future<void> future) {
  // Explicitly handle errors to prevent unhandled exceptions
  future.catchError((e, stack) {
    FileLogger.log('Unhandled error in unawaited future: $e\n$stack');
    return null;
  });
}
