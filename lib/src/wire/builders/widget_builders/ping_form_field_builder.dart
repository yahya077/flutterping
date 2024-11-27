part of '../widget_builder.dart';

class PingFormFieldBuilder extends WidgetBuilder {
  PingFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    String stateId = json.data["stateId"] ?? json.data["name"];
    return PingFormField(
        name: json.data["name"],
        builder: (field) {
          //TODO make disposable stateCallableRegistryState
          application.make<StateManager>(WireDefinition.stateManager).set(
              WireDefinition.stateCallableRegistryState,
              stateId,
              PingFieldCallableRegistry(field));
          application
              .make<StateManager>(WireDefinition.stateManager)
              .bindScope(json.data["name"], {
            "fieldValue": field.value ?? 0,
          });
          return application
              .make<WidgetBuilder>(json.data["field"]["type"])
              .build(Json.fromJson(json.data["field"]), context);
        });
  }
}

class PingFieldCallableRegistry<T>
    extends CallableRegistry<material.FormFieldState<T>> {
  static const String getValue = "getValue";
  static const String getError = "getError";
  static const String hasError = "hasError";
  static const String hasInteractedByUser = "hasInteractedByUser";
  static const String isValid = "isValid";
  static const String didChange = "didChange";

  PingFieldCallableRegistry(super.instance);

  @override
  initCallables() {
    callables = {
      getValue: (_) {
        instance.value;
      },
      getError: (_) {
        return instance.errorText;
      },
      hasError: (_) {
        return instance.hasError;
      },
      hasInteractedByUser: (_) {
        return instance.hasInteractedByUser;
      },
      isValid: (_) {
        return instance.isValid;
      },
      didChange: (arguments) {
        final value = arguments!["value"];
        instance.didChange(value);
      }
    };
  }
}
