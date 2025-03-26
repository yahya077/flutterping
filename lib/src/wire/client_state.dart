import 'package:flutter_ping_wire/src/framework/persistent_storage.dart';

import 'definitions/definition.dart';
import 'models/config.dart';
import 'state.dart';

class ClientState extends State {
  ClientState.initial(
    WireConfigClient client, Map<String, String> deviceInfo, {
    PersistentStorageInterface? persistentStorage,
  }) : super(
    state: {
      'id': "${WireDefinition.stateClientState}_${client.name}",
      'headers': {
        ...client.headers,
        'x-flutterping-appversion': deviceInfo['app_version'].toString(),
        'x-flutterping-appname': deviceInfo['app_name'].toString(),
        'x-flutterping-packagename': deviceInfo['package_name'].toString(),
        'x-flutterping-version': deviceInfo['version'].toString(),
        'x-flutterping-buildnumber': deviceInfo['build_number'].toString(),
        'x-flutterping-devicename': deviceInfo['device_name'].toString(),
        'x-flutterping-devicemodel': deviceInfo['device_model'].toString(),
        'x-flutterping-osversion': deviceInfo['os_version'].toString(),
        'x-flutterping-platform': deviceInfo['platform'].toString(),
        'x-flutterping-locale': deviceInfo['locale'].toString(),
        'x-flutterping-languagecode': deviceInfo['language_code'].toString(),
        'x-flutterping-countrycode': deviceInfo['country_code'].toString(),
        'x-flutterping-timezone': deviceInfo['timezone'].toString(),
        'x-flutterping-systemtheme': deviceInfo['system_theme'].toString(),
        'x-flutterping-connectiontype': deviceInfo['connection_type'].toString(),
        'x-flutterping-deeplink': deviceInfo['deep_link'].toString(),
        'x-flutterping-appinstanceid': deviceInfo['app_instance_id'].toString(),
      },
      'baseUrl': client.url,
    }, persistentStorage: persistentStorage
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
    final Map<String, String> headers = Map<String, String>.from(get('headers'));
    headers[key] = value;
    set('headers', headers);
  }

  Map<String, String> mergeHeaders(Map<String, String>? headers) {
    final Map<String, String> currentHeaders = Map<String, String>.from(get('headers'));
    if (headers != null) {
      currentHeaders.addAll(headers);
    }
    return currentHeaders;
  }

  Map<String, String> getHeaders() {
    return Map<String, String>.from(get('headers'));
  }
}
