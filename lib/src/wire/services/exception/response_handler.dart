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
    final deviceInfo = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<DeviceInfoState>('device_info_state')
        .dehydrate();
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
                appInfo: deviceInfo,
                requestInfo: {
                  'url': response.request?.url.toString(),
                  'method': response.request?.method,
                  'headers': response.request?.headers,
                  'body': requestBody,
                  'statusCode': response.statusCode,
                },
                showFullDetails: deviceInfo["build_mode"] == 'debug',
                debugMode: deviceInfo["build_mode"] == 'debug',
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
    GlobalOverlay().hide(identifier: "global_loading");

    final responseData = jsonDecode(response.body);
    final errorMessage = responseData["message"] ?? "Something went wrong";
    final deviceInfo = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<DeviceInfoState>('device_info_state')
        .dehydrate();

    // Actions for the error view
    final actions = [
      material.TextButton(
        onPressed: () => GlobalOverlay().hide(identifier: 'ping_error'),
        child: const material.Text('Close', style: material.TextStyle(color: material.Colors.red)),
      ),
    ];

    GlobalOverlay().show(
      event: ShowAlertEvent(
        title: 'Error',
        message: errorMessage,
        identifier: 'ping_error',
        isDismissible: true,
        builder: (title, message, _) => PingErrorView(
          error: responseData,
          stackTrace: null,
          appInfo: deviceInfo,
          requestInfo: {
            'url': response.request?.url.toString(),
            'method': response.request?.method,
            'headers': response.request?.headers,
            'body': requestBody,
            'statusCode': response.statusCode,
          },
          showFullDetails: deviceInfo["build_mode"] == 'debug',
          debugMode: deviceInfo["build_mode"] == 'debug',
          actions: actions, // Pass actions directly to PingErrorView
        ),
      ),
    );
  }
}
