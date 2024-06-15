import 'package:flutter_ping_wire/src/framework/app_exception_handler.dart';
import 'package:flutter_ping_wire/src/framework/container.dart';
import 'package:flutter_ping_wire/src/framework/definitions/containers.dart';
import 'package:http/http.dart' as http;

class Client {
  final Container container;
  final http.Client _client = http.Client();
  Uri? _baseUrl;
  Map<String, String>? _headers;

  Client(this.container);

  void setBaseUrl(Uri baseUrl) {
    _baseUrl = baseUrl;
  }

  void setHeaders(Map<String, String> headers) {
    _headers = headers;
  }

  Uri get baseUrl => _baseUrl!;

  Map<String, String>? get headers => _headers;

  void register() {}

  Future<http.Response> request(String url,
      {String method = "GET", Map<String, String>? headers, dynamic body}) async {
    return _handleRequest(() async {
      switch (method) {
        case "GET":
          return await get(url, headers: headers);
        case "POST":
          return await post(url, headers: headers, body: body);
        case "PUT":
          return await put(url, headers: headers, body: body);
        case "DELETE":
          return await delete(url, headers: headers);
        default:
          throw Exception("Invalid method $method");
      }
    });
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _handleRequest(() async {
      final response = await _client.get(_resolveUrl(url), headers: _mergeHeaders(headers));
      return response;
    });
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _handleRequest(() async {
      final response =
          await _client.post(_resolveUrl(url), headers: _mergeHeaders(headers), body: body);
      return response;
    });
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _handleRequest(() async {
      final response =
          await _client.put(_resolveUrl(url), headers: _mergeHeaders(headers), body: body);
      return response;
    });
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    return _handleRequest(() async {
      final response = await _client.delete(_resolveUrl(url), headers: _mergeHeaders(headers));
      return response;
    });
  }

  Future<http.Response> _handleRequest(
      Future<http.Response> Function() request) async {
    try {
      return await request();
    } catch (e) {
      container.make<AppExceptionHandler>(ContainerDefinition.AppExceptionHandler).report(e);

      return http.Response('Failed to execute request', 500);
    }
  }

  Uri _resolveUrl(String url) {
    if (_baseUrl == null) {
      throw Exception('Base URL is not set');
    }

    return _baseUrl!.resolve(url);
  }

  //merge headers
  Map<String, String> _mergeHeaders(Map<String, String>? headers) {
    if (_headers == null) {
      return headers ?? {};
    }

    if (headers == null) {
      return _headers!;
    }

    return {..._headers!, ...headers};
  }
}
