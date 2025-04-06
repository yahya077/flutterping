part of '../widget_builder.dart';

class CenterBuilder extends WidgetBuilder {
  CenterBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Center(
      widthFactor: DoubleFactory.fromDynamic(json.data["widthFactor"]),
      heightFactor: DoubleFactory.fromDynamic(json.data["heightFactor"]),
      child: json.data["child"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
