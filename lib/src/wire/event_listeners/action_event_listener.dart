import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/definitions/containers.dart';
import 'package:flutter_ping_wire/src/framework/dispatcher.dart';

import '../definitions/event.dart';
import '../executors/action_executor.dart';
import '../models/element.dart';

class ActionEventListener {
  final Application application;

  ActionEventListener(this.application);

  StreamSubscription listen(String stateId, material.BuildContext context) {
    dispose(stateId);

    return application
        .make<Dispatcher>(ContainerDefinition.Events)
        .on("${stateId}_${EventDefinition.actionEventName}")
        .listen((eventPayload) {
      final actionEl = Element.fromJson(eventPayload.payload);
      application
          .make<ActionExecutor>(actionEl.type)
          .execute(context, actionEl);
    });
  }

  void dispose(String key) {
    application
        .make<Dispatcher>(ContainerDefinition.Events)
        .dispose("${key}_${EventDefinition.actionEventName}");
  }
}
