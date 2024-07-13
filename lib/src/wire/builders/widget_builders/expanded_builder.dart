part of '../widget_builder.dart';

class ExpandedBuilder extends WidgetBuilder {
  ExpandedBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);
    return material.Expanded(
        flex: json.data['flex'] ?? 1,
        child: application
            .make<JsonBuilder>(childJson.type)
            .build(childJson, context));
  }
}
