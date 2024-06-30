import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

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
  T getValue<T>(Value value, {material.BuildContext? context}) {
    switch (value.type) {
      case "value":
        return value.value;
      case "notifier_variable":
        return ValueProvider.of(context!).getValueNotifier(value.value) as T;
      case "scope":
        final scopeValue = ScopeValue.fromJson(value.value);
        return application
            .make<StateManager>(WireDefinition.stateManager)
            .getScope(scopeValue.id)
            .get(scopeValue.key);
      case "state":
        return application
            .make<StateManager>(WireDefinition.stateManager)
            .dynamicGet(value.value);
    }

    throw Exception("Invalid type ${value.type}");
  }
}

//TODO implement these classes
class StaticValue {
  String value;

  StaticValue(this.value);
}

class StateValue {
  Application application;
  String value;

  StateValue(this.application, this.value);

  dynamic get() {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet(value);
  }
}

class ScopeValue {
  String id;
  String key;

  ScopeValue(this.id, this.key);

  factory ScopeValue.fromJson(Map<String, dynamic> json) => ScopeValue(
        json["id"],
        json["key"],
      );
}
