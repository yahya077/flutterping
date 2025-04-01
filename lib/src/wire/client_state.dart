import 'package:flutter_ping_wire/src/framework/persistent_storage.dart';

import 'definitions/definition.dart';
import 'models/config.dart';
import 'state.dart';

class ClientState extends State {
  static final Set<String> _persistentFields = {'headers.Authorization'};

  ClientState.initial(
    WireConfigClient client,
    Map<String, String> deviceInfo, {
    PersistentStorageInterface? persistentStorage,
  }) : super(
          state: {
            'id': "${WireDefinition.stateClientState}_${client.name}",
            'headers': {
              ...client.headers,
              'x-flutterping-appversion': deviceInfo['app_version'] ?? '',
              'x-flutterping-appname': deviceInfo['app_name'] ?? '',
              'x-flutterping-packagename': deviceInfo['package_name'] ?? '',
              'x-flutterping-version': deviceInfo['version'] ?? '',
              'x-flutterping-buildnumber': deviceInfo['build_number'] ?? '',
              'x-flutterping-devicename': deviceInfo['device_name'] ?? '',
              'x-flutterping-devicemodel': deviceInfo['device_model'] ?? '',
              'x-flutterping-osversion': deviceInfo['os_version'] ?? '',
              'x-flutterping-platform': deviceInfo['platform'] ?? '',
              'x-flutterping-locale': deviceInfo['locale'] ?? '',
              'x-flutterping-languagecode': deviceInfo['language_code'] ?? '',
              'x-flutterping-countrycode': deviceInfo['country_code'] ?? '',
              'x-flutterping-timezone': deviceInfo['timezone'] ?? '',
              'x-flutterping-systemtheme': deviceInfo['system_theme'] ?? '',
              'x-flutterping-connectiontype':
                  deviceInfo['connection_type'] ?? '',
              'x-flutterping-deeplink': deviceInfo['deep_link'] ?? '',
              'x-flutterping-appinstanceid':
                  deviceInfo['app_instance_id'] ?? '',
            },
            'baseUrl': client.url,
          },
          persistentStorage: persistentStorage,
          persistentFields: _persistentFields,
        );

  @override
  void hydrate(Map<String, dynamic> state) {
    if (state.containsKey('headers')) {
      state['headers'] = Map<String, String>.from(state['headers']);
    }
    super.hydrate(state);
  }

  void setBaseUrl(Uri baseUrl) {
    set('baseUrl', baseUrl.toString());
  }

  Uri getBaseUrl() {
    return Uri.parse(get<String>('baseUrl'));
  }

  void setHeaders(Map<String, String> headers) {
    set('headers', Map<String, String>.from(headers));
  }

  void addHeader(String key, String value) {
    final Map<String, String> headers =
        Map<String, String>.from(get('headers'));
    headers[key] = value;
    set('headers', headers);
  }

  Map<String, String> mergeHeaders(Map<String, String>? headers) {
    final Map<String, String> currentHeaders =
        Map<String, dynamic>.from(get('headers'))
            .map<String, String>((key, value) => MapEntry(key, value ?? ''));
    if (headers != null) {
      currentHeaders.addAll(headers);
    }
    return currentHeaders;
  }

  Map<String, String> getHeaders() {
    return Map<String, String>.from(get('headers'));
  }
}
