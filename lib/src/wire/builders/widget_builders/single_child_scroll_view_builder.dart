part of '../widget_builder.dart';

class SingleChildScrollViewBuilder extends WidgetBuilder {
  SingleChildScrollViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    final Json? childJson = json.data["child"] == null ? null : Json.fromJson(json.data["child"]);
    return material.SingleChildScrollView(
      controller: json.data["controller"] == null
          ? null
          : application
              .make<ScrollControllerBuilder>(json.data["controller"]["type"])
              .build(Json.fromJson(json.data["controller"])),
      scrollDirection: json.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(json.data["scrollDirection"]).build(),
      reverse: json.data["reverse"] ?? false,
      child: childJson == null ? null : application
          .make<WidgetBuilder>(childJson.type)
          .build(childJson),
    );
  }
}