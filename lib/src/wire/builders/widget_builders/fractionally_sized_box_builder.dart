part of '../widget_builder.dart';

class FractionallySizedBoxBuilder extends WidgetBuilder {
  FractionallySizedBoxBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.FractionallySizedBox(
      widthFactor: json.data["widthFactor"] == null
          ? null
          : double.parse(json.data["widthFactor"].toString()),
      heightFactor: json.data["heightFactor"] == null
          ? null
          : double.parse(json.data["heightFactor"].toString()),
      child: json.data["child"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
