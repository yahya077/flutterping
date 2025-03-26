import 'package:flutter_ping_wire/flutter_ping_wire.dart';

/// State class to hold device and app information
class DeviceInfoState extends State {
  DeviceInfoState() : super.withId('device_info_state');


  static DeviceInfoState initial() {
    return DeviceInfoState()
      ..set('app_version', '0.0.0')
      ..set('app_name', '')
      ..set('package_name', '')
      ..set('version', '')
      ..set('build_number', '')
      ..set('device_name', '')
      ..set('device_model', '')
      ..set('os_version', '')
      ..set('platform', '')
      ..set('locale', '')
      ..set('language_code', '')
      ..set('country_code', '')
      ..set('timezone', '')
      ..set('system_theme', '')
      ..set('connection_type', '')
      ..set('deep_link', '')
      ..set('app_instance_id', '')
      ..set('device_token', ''); // For push notifications
  }

  static DeviceInfoState initialWithValues(Map<String, dynamic> values) {
    return DeviceInfoState()
      ..set('app_version', values['app_version'] ?? '0.0.0')
      ..set('app_name', values['app_name'] ?? '')
      ..set('package_name', values['package_name'] ?? '')
      ..set('version', values['version'] ?? '')
      ..set('build_number', values['build_number'] ?? '')
      ..set('device_name', values['device_name'] ?? '')
      ..set('device_model', values['device_model'] ?? '')
      ..set('os_version', values['os_version'] ?? '')
      ..set('platform', values['platform'] ?? '')
      ..set('locale', values['locale'] ?? '')
      ..set('language_code', values['language_code'] ?? '')
      ..set('country_code', values['country_code'] ?? '')
      ..set('timezone', values['timezone'] ?? '')
      ..set('system_theme', values['system_theme'] ?? '')
      ..set('connection_type', values['connection_type'] ?? '')
      ..set('deep_link', values['deep_link'] ?? '')
      ..set('app_instance_id', values['app_instance_id'] ?? '')
      ..set('device_token', values['device_token'] ?? ''); // For push notifications
  }

  /// Retrieve app version
  String get appVersion => get<String>('app_version', defaultValue: '0.0.0');

  /// Retrieve app name
  String get appName => get<String>('app_name', defaultValue: '');

  /// Retrieve package name
  String get packageName => get<String>('package_name', defaultValue: '');

  /// Retrieve version
  String get version => get<String>('version', defaultValue: '');

  /// Retrieve build number
  String get buildNumber => get<String>('build_number', defaultValue: '');

  /// Retrieve device name
  String get deviceName => get<String>('device_name', defaultValue: '');

  /// Retrieve device model
  String get deviceModel => get<String>('device_model', defaultValue: '');

  /// Retrieve OS version
  String get osVersion => get<String>('os_version', defaultValue: '');

  /// Retrieve platform
  String get platform => get<String>('platform', defaultValue: '');

  /// Retrieve locale
  String get locale => get<String>('locale', defaultValue: '');

  /// Retrieve language code
  String get languageCode => get<String>('language_code', defaultValue: '');

  /// Retrieve country code
  String get countryCode => get<String>('country_code', defaultValue: '');

  /// Retrieve timezone
  String get timezone => get<String>('timezone', defaultValue: '');

  /// Retrieve system theme
  String get systemTheme => get<String>('system_theme', defaultValue: '');

  /// Retrieve connection type
  String get connectionType => get<String>('connection_type', defaultValue: '');

  /// Retrieve deep link
  String get deepLink => get<String>('deep_link', defaultValue: '');

  /// Retrieve app instance ID
  String get appInstanceId => get<String>('app_instance_id', defaultValue: '');

  /// Retrieve device token (for push notifications)
  String get deviceToken => get<String>('device_token', defaultValue: '');
} 