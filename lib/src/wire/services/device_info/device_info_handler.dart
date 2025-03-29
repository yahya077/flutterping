import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A class that gathers device information without requiring any third-party packages
class DeviceInfoHandler {
  /// Get the current platform (iOS, Android, web, etc.)
  static String getPlatform() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isWindows) return 'windows';
    if (Platform.isLinux) return 'linux';
    if (Platform.isFuchsia) return 'fuchsia';
    return 'unknown';
  }

  /// Get the current build mode (debug, profile, or release)
  static String getBuildMode() {
    if (kDebugMode) return 'debug';
    if (kProfileMode) return 'profile';
    if (kReleaseMode) return 'release';
    return 'unknown';
  }

  /// Get the OS version using platform channels
  static Future<String> getOsVersion() async {
    try {
      if (kIsWeb) return 'web';
      
      final String os = Platform.operatingSystem;
      final String version = Platform.operatingSystemVersion;
      
      // Extract just the version number for cleaner output
      final RegExp versionRegex = RegExp(r'[0-9]+(\.[0-9]+)*');
      final match = versionRegex.firstMatch(version);
      if (match != null) {
        return match.group(0) ?? version;
      }
      
      return version;
    } catch (e) {
      return 'unknown';
    }
  }
  
  /// Get the current locale information
  static Map<String, String> getLocaleInfo() {
    try {
      final locale = PlatformDispatcher.instance.locale;
      
      return {
        'locale': locale.toString(),
        'languageCode': locale.languageCode,
        'countryCode': locale.countryCode ?? '',
      };
    } catch (e) {
      return {
        'locale': 'en_US',
        'languageCode': 'en',
        'countryCode': 'US',
      };
    }
  }
  
  /// Get the current timezone
  static String getTimezone() {
    try {
      return DateTime.now().timeZoneName;
    } catch (e) {
      return 'UTC';
    }
  }
  
  /// Get the current system theme (light/dark)
  static String getSystemTheme() {
    try {
      final brightness = PlatformDispatcher.instance.platformBrightness;
      return brightness == Brightness.dark ? 'dark' : 'light';
    } catch (e) {
      return 'light';
    }
  }
  
  /// Generate a pseudo device name (best effort without third-party packages)
  static String getDeviceName() {
    try {
      if (kIsWeb) return 'Web Browser';
      
      final String os = Platform.operatingSystem;
      final String arch = Platform.operatingSystemVersion;
      return '$os ($arch)';
    } catch (e) {
      return 'Unknown Device';
    }
  }
  
  /// Get basic device model information (limited without device_info_plus)
  static String getDeviceModel() {
    try {
      if (kIsWeb) return 'Web Browser';
      if (Platform.isIOS) return 'iOS Device';
      if (Platform.isAndroid) return 'Android Device';
      return Platform.operatingSystem;
    } catch (e) {
      return 'Unknown Model';
    }
  }
  
  /// Generate a unique app instance ID (persists until app uninstall)
  static String generateAppInstanceId() {
    // Create a timestamp-based ID with a random component
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'instance_$timestamp$random';
  }
  
  /// Best-effort detection of network connectivity type without plugins
  static Future<String> getConnectionType() async {
    try {
      if (kIsWeb) {
        return 'online'; // Limited info on web
      }
      
      // Basic connectivity check
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return 'online';
        }
      } catch (_) {
        return 'offline';
      }
      
      return 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }
  
  /// Get the application version from pubspec.yaml
  static Future<String> getAppVersion() async {
    try {
      if (kIsWeb) return 'web';
      
      // Use MethodChannel to access platform-specific code
      const platform = MethodChannel('flutterping/app_info');
      final String version = await platform.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      // Fallback to reading the pubspec.yaml file as a string
      try {
        final String data = await rootBundle.loadString('pubspec.yaml');
        final RegExp versionRegex = RegExp(r'version:\s+(\d+\.\d+\.\d+)');
        final Match? match = versionRegex.firstMatch(data);
        if (match != null && match.groupCount >= 1) {
          return match.group(1) ?? '';
        }
      } catch (_) {}
      return '';
    }
  }
  
  /// Get the application build number
  static Future<String> getBuildNumber() async {
    try {
      if (kIsWeb) return '';
      
      const platform = MethodChannel('flutterping/app_info');
      final String buildNumber = await platform.invokeMethod('getBuildNumber');
      return buildNumber;
    } catch (e) {
      try {
        final String data = await rootBundle.loadString('pubspec.yaml');
        final RegExp versionRegex = RegExp(r'version:.*\+(\d+)');
        final Match? match = versionRegex.firstMatch(data);
        if (match != null && match.groupCount >= 1) {
          return match.group(1) ?? '';
        }
      } catch (_) {}
      return '';
    }
  }
  
  /// Get the application package name/bundle identifier
  static Future<String> getPackageName() async {
    try {
      if (kIsWeb) return 'web-app';
      
      // Use MethodChannel to access platform-specific code
      const platform = MethodChannel('flutterping/app_info');
      try {
        final String packageName = await platform.invokeMethod('getPackageName');
        return packageName;
      } catch (e) {
        // Fallback method based on platform
        if (Platform.isAndroid) {
          // Try to use the Android context to get package name
          try {
            final result = await const MethodChannel('plugins.flutter.io/package_info').invokeMethod<Map<dynamic, dynamic>>('getAll');
            return result?['packageName'] as String? ?? '';
          } catch (_) {}
        } else if (Platform.isIOS) {
          // Try to use the iOS bundle to get bundle identifier
          try {
            final result = await const MethodChannel('plugins.flutter.io/package_info').invokeMethod<Map<dynamic, dynamic>>('getAll');
            return result?['packageName'] as String? ?? '';
          } catch (_) {}
        } else if (Platform.isMacOS) {
          // For macOS applications
          return Platform.resolvedExecutable.split('/').lastWhere((element) => element.contains('.app'), orElse: () => '').replaceAll('.app', '');
        }
        
        // For other platforms, try to extract from the executable path
        try {
          return Platform.resolvedExecutable.split(Platform.pathSeparator).last;
        } catch (_) {}
      }
      return '';
    } catch (e) {
      return '';
    }
  }
  
  /// Get full version string (version+build number)
  static Future<String> getFullVersion() async {
    final appVersion = await getAppVersion();
    final buildNumber = await getBuildNumber();
    
    if (appVersion.isNotEmpty && buildNumber.isNotEmpty) {
      return '$appVersion+$buildNumber';
    } else if (appVersion.isNotEmpty) {
      return appVersion;
    }
    return '';
  }
  
  /// Gather all device information in one call
  static Future<Map<String, String>> gatherAllDeviceInfo() async {
    final localeInfo = getLocaleInfo();
    
    return {
      'platform': getPlatform(),
      'os_version': await getOsVersion(),
      'device_name': getDeviceName(),
      'device_model': getDeviceModel(),
      'locale': localeInfo['locale'] ?? 'en_US',
      'language_code': localeInfo['languageCode'] ?? 'en',
      'country_code': localeInfo['countryCode'] ?? 'US',
      'timezone': getTimezone(),
      'system_theme': getSystemTheme(),
      'connection_type': await getConnectionType(),
      'app_instance_id': generateAppInstanceId(),
      'deep_link': '',
      'app_version': await getAppVersion(),
      'build_number': await getBuildNumber(),
      'package_name': await getPackageName(),
      'version': await getFullVersion(),
      'build_mode': getBuildMode(),
    };
  }
} 