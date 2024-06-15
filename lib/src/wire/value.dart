import 'dart:convert';

import 'package:flutter_ping_wire/src/framework/app.dart';

import 'definitions/wire.dart';
import 'state_manager.dart';

abstract class AbstractValueGetter {
  T getValue<T>(Value value);
}

class Value {
  String type;
  dynamic value;

  Value({
    required this.type,
    required this.value,
  });

  factory Value.fromRawJson(String str) => Value.fromJson(json.decode(str));

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        type: json["type"] ?? "value",
        value: json["value"],
      );
}

class ValueManager implements AbstractValueGetter {
  Application application;

  ValueManager(this.application);

  @override
  T getValue<T>(Value value) {
    switch (value.type) {
      case "value":
        return value.value;
      case "state":
        return application.make<StateManager>(WireDefinition.stateManager).dynamicGet(value.value);
    }

    throw Exception("Invalid type ${value.type}");
  }
}