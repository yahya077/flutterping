part of '../widget_builder.dart';

class GestureDetectorBuilder extends WidgetBuilder {
  GestureDetectorBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.GestureDetector(
      onTap: element.data["onTap"] == null
          ? null
          : () => application
              .make<EventDispatcher>(WireDefinition.eventDispatcher)
              .dispatch(Event.fromJson(element.data["onTap"]["data"])),
      child: application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}
