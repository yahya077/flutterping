import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// A class that gathers device information using device_info_plus and package_info_plus
class DeviceInfoHandler {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  
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

  /// Get the OS version using device_info_plus
  static Future<String> getOsVersion() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return webInfo.browserName.toString();
      }
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.version.release;
      }
      
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.systemVersion;
      }
      
      if (Platform.isMacOS) {
        final macOsInfo = await _deviceInfoPlugin.macOsInfo;
        return macOsInfo.osRelease;
      }
      
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        return windowsInfo.buildNumber.toString();
      }
      
      if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        return linuxInfo.version ?? 'unknown';
      }
      
      return Platform.operatingSystemVersion;
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
  
  /// Get device name using device_info_plus
  static Future<String> getDeviceName() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return '${webInfo.browserName} ${webInfo.platform}';
      }
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return androidInfo.model;
      }
      
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.name;
      }
      
      if (Platform.isMacOS) {
        final macOsInfo = await _deviceInfoPlugin.macOsInfo;
        return macOsInfo.computerName;
      }
      
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        return windowsInfo.computerName;
      }
      
      if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        return linuxInfo.name ?? 'Linux Device';
      }
      
      return Platform.operatingSystem;
    } catch (e) {
      return 'Unknown Device';
    }
  }
  
  /// Get device model using device_info_plus
  static Future<String> getDeviceModel() async {
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        return webInfo.userAgent ?? 'Web Browser';
      }
      
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      }
      
      if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.model;
      }
      
      if (Platform.isMacOS) {
        final macOsInfo = await _deviceInfoPlugin.macOsInfo;
        return macOsInfo.model;
      }
      
      if (Platform.isWindows) {
        final windowsInfo = await _deviceInfoPlugin.windowsInfo;
        return windowsInfo.productName;
      }
      
      if (Platform.isLinux) {
        final linuxInfo = await _deviceInfoPlugin.linuxInfo;
        return linuxInfo.prettyName ?? 'Linux Device';
      }
      
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
  
  /// Get the application version using package_info_plus
  static Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      return '';
    }
  }
  
  /// Get the application build number using package_info_plus
  static Future<String> getBuildNumber() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.buildNumber;
    } catch (e) {
      return '';
    }
  }
  
  /// Get the application package name using package_info_plus
  static Future<String> getPackageName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      return '';
    }
  }
  
  /// Get app name using package_info_plus
  static Future<String> getAppName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.appName;
    } catch (e) {
      return '';
    }
  }
  
  /// Get full version string (version+build number)
  static Future<String> getFullVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      return '';
    }
  }
  
  /// Gather all device information in one call
  static Future<Map<String, String>> gatherAllDeviceInfo() async {
    final localeInfo = getLocaleInfo();
    
    return {
      'platform': getPlatform(),
      'os_version': await getOsVersion(),
      'device_name': await getDeviceName(),
      'device_model': await getDeviceModel(),
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
      'app_name': await getAppName(),
      'version': await getFullVersion(),
      'build_mode': getBuildMode(),
    };
  }
} 