part of '../widget_builder.dart';

class SingleChildScrollViewBuilder extends WidgetBuilder {
  SingleChildScrollViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json? childJson =
        json.data["child"] == null ? null : Json.fromJson(json.data["child"]);
    return material.SingleChildScrollView(
      controller: json.data["controller"] == null
          ? null
          : application
              .make<ScrollControllerBuilder>(json.data["controller"]["type"])
              .build(Json.fromJson(json.data["controller"]), context),
      scrollDirection: json.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(json.data["scrollDirection"]).build(),
      reverse: json.data["reverse"] ?? false,
      keyboardDismissBehavior: json.data["keyboardDismissBehavior"] == null
          ? material.ScrollViewKeyboardDismissBehavior.manual
          : ScrollViewKeyboardDismissBehavior.fromJson(
              json.data["keyboardDismissBehavior"]["data"]).build(),
      child: childJson == null
          ? null
          : application
              .make<WidgetBuilder>(childJson.type)
              .build(childJson, context),
    );
  }
}
