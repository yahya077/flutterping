part of '../widget_builder.dart';

class FloatingActionButtonBuilder extends WidgetBuilder {
  FloatingActionButtonBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.FloatingActionButton(
      disabledElevation: json.data["disabledElevation"] == null
          ? 6.0
          : double.parse(json.data["disabledElevation"].toString()),
      elevation: json.data["elevation"] == null
          ? 6.0
          : double.parse(json.data["elevation"].toString()),
      highlightElevation: json.data["highlightElevation"] == null
          ? 12.0
          : double.parse(json.data["highlightElevation"].toString()),
      hoverElevation: json.data["hoverElevation"] == null
          ? 8.0
          : double.parse(json.data["hoverElevation"].toString()),
      focusElevation: json.data["focusElevation"] == null
          ? 12.0
          : double.parse(json.data["focusElevation"].toString()),
      splashColor: json.data["splashColor"] == null
          ? null
          : Color.findColor(json.data["splashColor"]).build(),
      hoverColor: json.data["hoverColor"] == null
          ? null
          : Color.findColor(json.data["hoverColor"]).build(),
      focusColor: json.data["focusColor"] == null
          ? null
          : Color.findColor(json.data["focusColor"]).build(),
      backgroundColor: json.data["backgroundColor"] == null
          ? null
          : Color.findColor(json.data["backgroundColor"]).build(),
      onPressed: () {
        json.data["onPressed"] == null
            ? null
            : application
                .make<EventDispatcher>(WireDefinition.eventDispatcher)
                .dispatch(Event.fromJson(json.data["onPressed"]["data"]));
      },
      child: application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"])),
    );
  }
}
