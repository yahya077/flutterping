import 'dart:convert';
import 'dart:io';

import '../app.dart';

/// Interface for maintenance mode implementations
abstract class MaintenanceMode {
  /// Check if maintenance mode is active
  bool isActive();
  
  /// Activate maintenance mode with a given message
  Future<void> activate({String? message, int? retryAfter, String? secret});
  
  /// Deactivate maintenance mode
  Future<void> deactivate();
  
  /// Get maintenance mode data
  MaintenanceModeData? data();
}

/// Data stored during maintenance mode
class MaintenanceModeData {
  final DateTime time;
  final String? message;
  final int? retryAfter;
  final String? secret;
  
  MaintenanceModeData({
    required this.time,
    this.message,
    this.retryAfter,
    this.secret,
  });
  
  /// Convert to JSON format
  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      if (message != null) 'message': message,
      if (retryAfter != null) 'retry_after': retryAfter,
      if (secret != null) 'secret': secret,
    };
  }
  
  /// Create from JSON data
  factory MaintenanceModeData.fromJson(Map<String, dynamic> json) {
    return MaintenanceModeData(
      time: DateTime.parse(json['time']),
      message: json['message'],
      retryAfter: json['retry_after'],
      secret: json['secret'],
    );
  }
}

/// File-based implementation of maintenance mode
class FileMaintenanceMode implements MaintenanceMode {
  final Application app;
  final String _filePath;
  MaintenanceModeData? _cachedData;
  
  FileMaintenanceMode(this.app) : _filePath = app.storagePath('framework/down');
  
  @override
  bool isActive() {
    final file = File(_filePath);
    return file.existsSync();
  }
  
  @override
  Future<void> activate({
    String? message,
    int? retryAfter,
    String? secret,
  }) async {
    final data = MaintenanceModeData(
      time: DateTime.now(),
      message: message,
      retryAfter: retryAfter,
      secret: secret,
    );
    
    final file = File(_filePath);
    
    // Create the directory if it doesn't exist
    final dir = Directory(file.parent.path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    
    // Write the data to the file
    await file.writeAsString(jsonEncode(data.toJson()));
    
    // Update the cached data
    _cachedData = data;
  }
  
  @override
  Future<void> deactivate() async {
    final file = File(_filePath);
    
    if (await file.exists()) {
      await file.delete();
    }
    
    _cachedData = null;
  }
  
  @override
  MaintenanceModeData? data() {
    if (_cachedData != null) {
      return _cachedData;
    }
    
    final file = File(_filePath);
    
    if (!file.existsSync()) {
      return null;
    }
    
    try {
      final content = file.readAsStringSync();
      final json = jsonDecode(content) as Map<String, dynamic>;
      
      _cachedData = MaintenanceModeData.fromJson(json);
      return _cachedData;
    } catch (e) {
      // If we can't read the file, assume we're not in maintenance mode
      return null;
    }
  }
} 