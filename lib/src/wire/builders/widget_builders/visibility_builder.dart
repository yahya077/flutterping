part of '../widget_builder.dart';

class VisibilityBuilder extends WidgetBuilder {
  VisibilityBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);

    final value = application
        .make<ValueBuilder>(json.data["visible"]["type"])
        .build(Json.fromJson(json.data["visible"]), context);

    return material.Visibility(
      visible: value ?? false,
      child: application
          .make<WidgetBuilder>(childJson.type)
          .build(childJson, context),
    );
  }
}
