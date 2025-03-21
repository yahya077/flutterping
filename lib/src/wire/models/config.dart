class WireConfigLoader {
  final String client;
  final String endpoint;
  final String method;

  WireConfigLoader({
    required this.client,
    required this.endpoint,
    required this.method,
  });

  factory WireConfigLoader.fromMap(Map<String, dynamic> map) {
    return WireConfigLoader(
      client: map['client'],
      endpoint: map['endpoint'],
      method: map['method'],
    );
  }
}

class WireConfigClient {
  final String name;
  final String description;
  final String url;
  final Map<String, String> headers;

  WireConfigClient({
    required this.name,
    required this.description,
    required this.url,
    required this.headers,
  });

  factory WireConfigClient.fromMap(Map<String, dynamic> map) {
    return WireConfigClient(
      name: map['name'],
      description: map['description'],
      url: map['url'],
      headers: Map<String, String>.from(map['headers']),
    );
  }
}

class WireConfig {
  final Map<String, WireConfigClient> clients;
  final Map<String, WireConfigLoader> loaders;

  WireConfig({
    required this.clients,
    required this.loaders,
  });

  factory WireConfig.fromMap(Map<String, dynamic> map) {
    final Map<String, WireConfigClient> clients = {};
    map['clients'].forEach((key, value) {
      clients[key] = WireConfigClient.fromMap(value);
    });
    final Map<String, WireConfigLoader> loaders = {};

    map['loaders'].forEach((key, value) {
      loaders[key] = WireConfigLoader.fromMap(value);
    });

    return WireConfig(
      clients: clients,
      loaders: loaders,
    );
  }
}
