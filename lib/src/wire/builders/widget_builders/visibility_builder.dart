part of '../widget_builder.dart';

class VisibilityBuilder extends WidgetBuilder {
  VisibilityBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);
    return material.Visibility(
      visible: json.data["visible"] ?? true,
      child: application
          .make<WidgetBuilder>(childJson.type)
          .build(childJson, context),
    );
  }
}
