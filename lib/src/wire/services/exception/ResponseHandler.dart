import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/src/framework/config.dart';
import 'package:flutter_ping_wire/src/wire/resources/widgets/overlay.dart';
import 'package:http/http.dart';

class ResponseHandler {
  final Application application;

  ResponseHandler(this.application);

  Future<dynamic> handle(Response response, Object? requestBody,
      {material.BuildContext? context}) async {
    final responseData = jsonDecode(response.body);

    if (context != null) {
      if (responseData.containsKey("type") &&
          responseData["type"] == "ActionEvent") {
        responseData["data"]["stateId"] = responseData["data"]["stateId"] ??
            application
                .make<Config>(WireDefinition.config)
                .get("base_state_id");

        application
            .make<EventDispatcher>(WireDefinition.eventDispatcher)
            .dispatch(Event.fromJson(responseData["data"]));
      } else if (responseData.containsKey("exception")) {
        _alertOverlay(response, requestBody);
      } else if (responseData.containsKey("type")) {
        final element = Json.fromRawJson(response.body);

        return application
            .make<JsonBuilder>(element.type)
            .build(element, context);
      } else {
        _alertOverlay(response, requestBody);
      }
    } else {
      if (responseData.containsKey("type")) {
        final element = Json.fromRawJson(response.body);

        return application.make<JsonBuilder>(element.type).build(element, null);
      } else if (responseData.containsKey("exception")) {
        material.runApp(material.MaterialApp(
          debugShowCheckedModeBanner: true,
          theme: material.ThemeData(
            primarySwatch: material.Colors.red,
          ),
          home: material.Scaffold(
            body: material.SafeArea(
              child: PingErrorView(
                error: responseData,
                stackTrace: null,
                appInfo: application
                    .make<StateManager>(WireDefinition.stateManager)
                    .getState<DeviceInfoState>('device_info_state')
                    .dehydrate(),
                requestInfo: {
                  'url': response.request?.url.toString(),
                  'method': response.request?.method,
                  'headers': response.request?.headers,
                  'body': requestBody,
                  'statusCode': response.statusCode,
                },
                showFullDetails: true,
                debugMode: true,
              ),
            ),
          ),
        ));
      } else {
        _alertOverlay(response, requestBody);
      }
    }
  }

  void _alertOverlay(Response response, Object? requestBody) {
    final responseData = jsonDecode(response.body);

    final errorMessage = responseData["message"] ?? "Something went wrong";
    GlobalOverlay().show(
      event: ShowAlertEvent(
        title: 'Error',
        message: errorMessage,
        actions: [
          material.TextButton(
            onPressed: () => GlobalOverlay().hide(identifier: 'ping_error'),
            child: const material.Text('Close'),
          ),
        ],
        builder: (title, message, actions) => PingErrorView(
          error: responseData,
          stackTrace: null,
          appInfo: application
              .make<StateManager>(WireDefinition.stateManager)
              .getState<DeviceInfoState>('device_info_state')
              .dehydrate(),
          requestInfo: {
            'url': response.request?.url.toString(),
            'method': response.request?.method,
            'headers': response.request?.headers,
            'body': requestBody,
            'statusCode': response.statusCode,
          },
          showFullDetails: true,
          debugMode: true,
        ),
        identifier: 'ping_error',
      ),
    );
  }
}
