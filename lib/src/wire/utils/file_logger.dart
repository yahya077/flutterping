import 'dart:io';
import 'package:flutter/foundation.dart';

/// A simple file logger for Flutter Ping Wire
/// 
/// This logger only writes to log files in debug mode (when kDebugMode is true).
/// In release mode, no file operations will be performed, ensuring optimal performance.
class FileLogger {
  static File? _logFile;
  static bool _initialized = false;
  static String _currentLogDate = '';

  /// Get a formatted date string for the current day
  static String _getDateString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  static Future<void> initialize() async {
    try {
      final dateString = _getDateString();

      // If we already have an initialized logger for today, return early
      if (_initialized && _currentLogDate == dateString && _logFile != null) {
        return;
      }

      final tempDir = Directory.systemTemp;
      final logPath = '${tempDir.path}/flutterping_logs';

      // Create logs directory if it doesn't exist
      final logsDir = Directory(logPath);
      if (!await logsDir.exists()) {
        await logsDir.create(recursive: true);
      }

      // Use date-based filename instead of timestamp
      _currentLogDate = dateString;
      _logFile = File('$logPath/wire_log_$_currentLogDate.txt');

      // Only write the header if the file is new
      if (!await _logFile!.exists()) {
        await _logFile
            ?.writeAsString('--- Log started at ${DateTime.now()} ---\n');
      }

      _initialized = true;
      if (kDebugMode) {
        print('FileLogger: Initialized with log file $_logFile');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize file logger: $e');
      }
    }
  }

  /// Logs a message to the log file
  /// 
  /// In debug mode, writes the message to the log file with a timestamp.
  /// In release mode, this method does nothing to ensure optimal performance.
  /// 
  /// @param message The message to log
  static Future<void> log(String message) async {
    if (kDebugMode) {
      // Check if we need to roll over to a new day
      final dateString = _getDateString();
      if (_currentLogDate != dateString) {
        _initialized = false;
        await initialize();
      }

      if (!_initialized) {
        await initialize();
      }

      try {
        final timestamp = DateTime.now().toString();
        await _logFile?.writeAsString('[$timestamp] $message\n',
            mode: FileMode.append);
        print('FileLogger: $message');
      } catch (e) {
        print('Failed to write log: $e');
      }
    }
  }

  static String getLogFilePath() {
    return _logFile?.path ?? 'Logger not initialized';
  }
}
