part of '../widget_builder.dart';

class ClipRRectBuilder extends WidgetBuilder {
  ClipRRectBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);
    return material.ClipRRect(
      borderRadius: json.data["borderRadius"] == null ? material.BorderRadius.zero : BorderRadiusGeometry.findJson(json.data["borderRadius"]).build(),
      clipBehavior: json.data["clipBehavior"] == null ? material.Clip.antiAlias : Clip.fromJson(json.data["clipBehavior"]).build(),
      child: application
              .make<WidgetBuilder>(childJson.type)
              .build(childJson, context),
    );
  }
}
