part of '../widget_builder.dart';

class ContainerBuilder extends WidgetBuilder {
  ContainerBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json? childJson =
        json.data["child"] == null ? null : Json.fromJson(json.data["child"]);
    return material.Container(
      color: json.data["color"] == null
          ? null
          : Color.findColor(json.data["color"]).build(),
      decoration: json.data["decoration"] == null
          ? null
          : Decoration.findJson(json.data["decoration"]).build(),
      margin: json.data["margin"] == null
          ? null
          : EdgeInsets.findJson(json.data["margin"]).build(),
      padding: json.data["padding"] == null
          ? null
          : EdgeInsets.findJson(json.data["padding"]).build(),
      width: json.data["width"] == null
          ? null
          : json.data["width"] == null
              ? null
              : double.parse(json.data["width"].toString()),
      height: json.data["height"] == null
          ? null
          : json.data["height"] == null
              ? null
              : double.parse(json.data["height"].toString()),
      child: childJson == null
          ? null
          : application
              .make<WidgetBuilder>(childJson.type)
              .build(childJson, context),
    );
  }
}
