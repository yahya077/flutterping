part of '../widget_builder.dart';

class FlexibleBuilder extends WidgetBuilder {
  FlexibleBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);
    return material.Flexible(
        flex: json.data['flex'] ?? 1,
        fit: json.data['fit'] != null
            ? FlexFit.fromJson(json.data['fit']).build()
            : material.FlexFit.loose,
        child: application
            .make<JsonBuilder>(childJson.type)
            .build(childJson, context));
  }
}
