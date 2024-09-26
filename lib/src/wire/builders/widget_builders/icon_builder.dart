part of '../widget_builder.dart';

class IconBuilder extends WidgetBuilder {
  IconBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Icon(
      application
          .make<JsonBuilder<material.IconData>>(json.data["icon"]["type"])
          .build(Json.fromJson(json.data["icon"]), context),
      size: json.data["size"]?.toDouble(),
      fill: json.data["fill"]?.toDouble(),
      grade: json.data["grade"]?.toDouble(),
      opticalSize: json.data["opticalSize"]?.toDouble(),
      applyTextScaling: json.data["applyTextScaling"]?.toDouble(),
      weight: json.data["weight"]?.toDouble(),
      color: json.data["color"] == null
          ? null
          : Color.findColor(json.data["color"]).build(),
      semanticLabel: json.data["semanticLabel"],
      textDirection: json.data["textDirection"] == null
          ? null
          : TextDirection.fromJson(json.data["textDirection"]).build(),
    );
  }
}
