import 'package:flutter/material.dart' as material;

import '../../framework/framework.dart';
import '../definitions/wire.dart';
import '../models/json.dart';
import '../state_manager.dart';
import '../value_provider.dart';
import 'json_builder.dart';

class ValueBuilder<T> extends JsonBuilder<T> {
  ValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return application
        .make<ValueBuilder>(json.type)
        .build(Json.fromJson(json.data), context);
  }
}

class ScopeValueBuilder<T> extends ValueBuilder<T> {
  ScopeValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getScope(json.data["id"])
        .get(json.data["key"]);
  }
}

class StateValueBuilder<T> extends ValueBuilder<T> {
  StateValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet(json.data["key"]);
  }
}

class NotifierValueBuilder<T> extends ValueBuilder<T> {
  NotifierValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return ValueProvider.of(context!).getValueNotifier(json.data["key"]) as T;
  }
}
