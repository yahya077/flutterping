part of '../widget_builder.dart';

class ElevatedButtonBuilder extends WidgetBuilder {
  ElevatedButtonBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.ElevatedButton(
      onPressed: json.data["onPressed"] == null
          ? null
          : () => application
              .make<EventDispatcher>(WireDefinition.eventDispatcher)
              .dispatch(Event.fromJson(json.data["onPressed"]["data"])),
      child: application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
