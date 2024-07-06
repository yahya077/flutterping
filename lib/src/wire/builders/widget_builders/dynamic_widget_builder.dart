part of '../widget_builder.dart';

class DynamicWidgetBuilder extends WidgetBuilder {
  DynamicWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    //TODO implement more value types then you should use json.data["value"] instead of json.data["value"]["data"]
    return application
        .make<ValueManager>(WireDefinition.valueManager)
        .getValue<material.Widget>(
            Value.fromJson(json.data["value"]["data"]));
  }
}
