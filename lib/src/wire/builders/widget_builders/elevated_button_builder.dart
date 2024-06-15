part of '../widget_builder.dart';

class ElevatedButtonBuilder extends WidgetBuilder {
  ElevatedButtonBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.ElevatedButton(
      onPressed: element.data["onPressed"] == null
          ? null
          : () => application
          .make<EventDispatcher>(WireDefinition.eventDispatcher)
          .dispatch(Event.fromJson(element.data["onPressed"]["data"])),
      child: application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}