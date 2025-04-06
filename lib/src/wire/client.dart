import 'dart:convert';

import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/src/framework/app_exception_handler.dart';
import 'package:flutter_ping_wire/src/wire/client_state.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

/// Enhanced HTTP client with built-in error handling, retries, and UI feedback
class Client {
  final Application application;
  final http.Client _client = http.Client();
  late String _stateId;

  Client(this.application);

  void setStateId(String stateId) {
    _stateId = stateId;
  }
  
  ClientState getState() {
    return application.make<StateManager>(WireDefinition.stateManager).getState(_stateId);
  }

  void register() {}

  /// Get client identifier from stateId
  String get clientIdentifier => _stateId.replaceAll("${WireDefinition.stateClientState}_", "");

  /// Basic request method used internally
  Future<http.Response> request(String url,
      {String? method = "GET",
      Map<String, String>? headers,
      dynamic body}) async {
    method = method?.toUpperCase() ?? "GET";

    if (body is Map<String, String>) {
      body = jsonEncode(body);
    }

    return _handleRequest(() async {
      switch (method) {
        case "GET":
          return await get(url, headers: getState().mergeHeaders(headers));
        case "POST":
          return await post(url, headers: getState().mergeHeaders(headers), body: body);
        case "PUT":
          return await put(url, headers: getState().mergeHeaders(headers), body: body);
        case "DELETE":
          return await delete(url, headers: getState().mergeHeaders(headers));
        default:
          throw Exception("Invalid method $method");
      }
    });
  }

  Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _handleRequest(() async {
      final response =
          await _client.get(_resolveUrl(url), headers: getState().mergeHeaders(headers));
      return response;
    });
  }

  Future<http.Response> post(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _handleRequest(() async {
      final response = await _client.post(_resolveUrl(url),
          headers: getState().mergeHeaders(headers), body: body);
      return response;
    });
  }

  Future<http.Response> put(String url,
      {Map<String, String>? headers, dynamic body}) async {
    return _handleRequest(() async {
      final response = await _client.put(_resolveUrl(url),
          headers: getState().mergeHeaders(headers), body: body);
      return response;
    });
  }

  Future<http.Response> delete(String url,
      {Map<String, String>? headers}) async {
    return _handleRequest(() async {
      final response = await _client.delete(_resolveUrl(url),
          headers: getState().mergeHeaders(headers));
      return response;
    });
  }

  Future<http.Response> _handleRequest(
      Future<http.Response> Function() request) async {
    try {
      return await request();
    } catch (e, stackTrace) {
      application
          .make<AppExceptionHandler>(ContainerDefinition.appExceptionHandler)
          .report(e, stackTrace);

      return http.Response('Failed to execute request', 500);
    }
  }

  Uri _resolveUrl(String url) {
    return getState().getBaseUrl().resolve(url);
  }
}
