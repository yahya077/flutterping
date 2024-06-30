import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/definitions/containers.dart';
import 'package:flutter_ping_wire/src/framework/dispatcher.dart';

import '../definitions/event.dart';
import '../executors/action_executor.dart';
import '../resources/widgets/reactive_widget.dart';

class StateEventListener {
  final Application application;

  StateEventListener(this.application);

  StreamSubscription listen(material.BuildContext context,
      ReactiveWidgetStateSchema reactiveWidgetState, String stateId) {
    return application
        .make<Dispatcher>(ContainerDefinition.events)
        .on("${stateId}_${EventDefinition.stateEventName}")
        .listen((eventPayload) {
      final State state = reactiveWidgetState.getState(eventPayload.payload);

      for (var action in state.actions) {
        application.make<ActionExecutor>(action.type).execute(context, action);
      }
    });
  }

  void dispose(String key) {
    application
        .make<Dispatcher>(ContainerDefinition.events)
        .dispose("${key}_${EventDefinition.stateEventName}");
  }
}
