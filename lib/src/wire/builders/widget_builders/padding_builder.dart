part of '../widget_builder.dart';

class PaddingBuilder extends WidgetBuilder {
  PaddingBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);
    return material.Padding(
      padding: EdgeInsets.findJson(json.data["padding"]).build(),
      child: application
              .make<WidgetBuilder>(childJson.type)
              .build(childJson, context),
    );
  }
}
