import 'dart:async';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/definitions/containers.dart';
import 'package:flutter_ping_wire/src/framework/dispatcher.dart';

import 'models/event.dart';

typedef EventListener = StreamSubscription Function(material.BuildContext context);

typedef DisposeListener = void Function();

class EventDispatcher {
  final Application application;

  EventDispatcher(this.application);

  dispatch(Event event) {
    application.make<Dispatcher>(ContainerDefinition.Events).dispatch(
        "${event.stateId}_${event.name}",
        EventPayload(
          payload: event.payload,
          stateId: event.stateId,
        ));
  }
}