part of '../widget_builder.dart';

class GridViewBuilder extends WidgetBuilder {
  GridViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.GridView(
      controller: json.data["controller"] == null
          ? null
          : application
              .make<ScrollControllerBuilder>(json.data["controller"]["type"])
              .build(Json.fromJson(json.data["controller"]), context),
      scrollDirection: json.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(json.data["scrollDirection"]).build(),
      gridDelegate:
          SliverGridDelegateFactory.findJson(json.data["gridDelegate"]).build(),
      reverse: json.data["reverse"] ?? false,
      shrinkWrap: json.data["shrinkWrap"] ?? false,
      children: json.data["items"]
          .map<material.Widget>((child) => application
              .make<WidgetBuilder>(child["type"])
              .build(Json.fromJson(child), context))
          .toList(),
    );
  }
}
