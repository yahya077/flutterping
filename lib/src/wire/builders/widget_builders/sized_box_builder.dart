part of '../widget_builder.dart';

class SizedBoxBuilder extends WidgetBuilder {
  SizedBoxBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.SizedBox(
      width: DoubleFactory.fromDynamic(json.data["width"]),
      height: DoubleFactory.fromDynamic(json.data["height"]),
      child: json.data["child"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
