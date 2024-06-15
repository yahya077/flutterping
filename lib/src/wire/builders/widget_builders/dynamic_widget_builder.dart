part of '../widget_builder.dart';

class DynamicWidgetBuilder extends WidgetBuilder {
  DynamicWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    //TODO implement more value types then you should use element.data["value"] instead of element.data["value"]["data"]
    return application
        .make<ValueManager>(WireDefinition.valueManager)
        .getValue<material.Widget>(
            Value.fromJson(element.data["value"]["data"]));
  }
}
