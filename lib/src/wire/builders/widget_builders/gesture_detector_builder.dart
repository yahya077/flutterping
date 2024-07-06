part of '../widget_builder.dart';

class GestureDetectorBuilder extends WidgetBuilder {
  GestureDetectorBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.GestureDetector(
      onTap: json.data["onTap"] == null
          ? null
          : () => application
              .make<EventDispatcher>(WireDefinition.eventDispatcher)
              .dispatch(Event.fromJson(json.data["onTap"]["data"])),
      child: application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"])),
    );
  }
}
