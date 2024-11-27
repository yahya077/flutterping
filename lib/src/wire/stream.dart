import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/definitions/containers.dart';
import 'package:flutter_ping_wire/src/framework/dispatcher.dart';

import 'definitions/definition.dart';
import 'models/event.dart';
import 'state_manager.dart';

typedef EventListener = StreamSubscription Function(
    material.BuildContext context);

typedef DisposeListener = void Function();

class EventDispatcher {
  final Application application;

  EventDispatcher(this.application);

  //TODO merge event.scope.context with arguments
  scopedEventDispatch(Event event,Map<String, dynamic> arguments) {
    if (event.scope != null) {
      event.scope!.context.addAll(arguments);
    }

    dispatch(event);
  }

  dispatch(Event event) {
    if (event.scope != null) {
      application
          .make<StateManager>(WireDefinition.stateManager)
          .bindScope(event.scope!.id, event.scope!.context);
    }

    application.make<Dispatcher>(ContainerDefinition.events).dispatch(
        "${event.stateId}_${event.name}",
        EventPayload(
          payload: event.payload,
          stateId: event.stateId,
        ));
  }
}
