part of '../widget_builder.dart';

class CardBuilder extends WidgetBuilder {
  CardBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Card(
      color: json.data["color"] == null
          ? null
          : Color.findColor(json.data["color"]).build(),
      elevation: json.data["elevation"] == null
          ? 1.0
          : double.parse(json.data["elevation"].toString()),
      shadowColor: json.data["shadowColor"] == null
          ? null
          : Color.findColor(json.data["shadowColor"]).build(),
      surfaceTintColor: json.data["surfaceTintColor"] == null
          ? null
          : Color.findColor(json.data["surfaceTintColor"]).build(),
      clipBehavior: json.data["clipBehavior"] != null
          ? Clip.fromJson(json.data["clipBehavior"]).build()
          : null,
      semanticContainer: json.data["semanticContainer"] ?? false,
      borderOnForeground: json.data["borderOnForeground"] ?? true,
      margin: json.data["margin"] == null
          ? null
          : EdgeInsets.findJson(json.data["margin"]).build(),
      shape: json.data["shape"] == null
          ? null
          : ShapeBorderFactory.findJson(json.data["shape"]).build(),
      child: json.data["child"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
