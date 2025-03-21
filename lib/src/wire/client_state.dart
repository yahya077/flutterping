import 'definitions/definition.dart';
import 'models/config.dart';
import 'state.dart';

class ClientState extends State {
  ClientState({required Map<String, dynamic> state}) : super(state: state);

  ClientState.initial(WireConfigClient client) : super(state: {}) {
    hydrate({
      'id': "${WireDefinition.stateClientState}_${client.name}",
      'headers': client.headers,
      'baseUrl': Uri.parse(client.url)
    });
  }

  void setBaseUrl(Uri baseUrl) {
    set('baseUrl', baseUrl);
  }

  Uri getBaseUrl() {
    return get('baseUrl');
  }

  void setHeaders(Map<String, String> headers) {
    set('headers', headers);
  }

  void addHeader(String key, String value) {
    final Map<String, String> headers = get('headers');
    headers[key] = value;
    set('headers', headers);
  }

  Map<String, String> mergeHeaders(Map<String, String>? headers) {
    final Map<String, String> currentHeaders = get('headers');
    if (headers != null) {
      currentHeaders.addAll(headers);
    }
    return currentHeaders;
  }

  Map<String, String> getHeaders() {
    return get('headers');
  }
}
