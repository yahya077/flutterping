part of '../widget_builder.dart';

class SizedBoxBuilder extends WidgetBuilder {
  SizedBoxBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.SizedBox(
      width: json.data["width"] == null
          ? null
          : double.parse(json.data["width"].toString()),
      height: json.data["height"] == null
          ? null
          : double.parse(json.data["height"].toString()),
      child: json.data["child"] == null
          ? null
          : application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"])),
    );
  }
}
