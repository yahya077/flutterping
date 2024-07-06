part of '../widget_builder.dart';

class BottomAppBarBuilder extends WidgetBuilder {
  BottomAppBarBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.BottomAppBar(
      padding: json.data["padding"] == null
          ? null
          : Padding.fromJson(json.data["padding"]).build(),
      surfaceTintColor: json.data["surfaceTintColor"] == null
          ? null
          : Color.findColor(json.data["surfaceTintColor"]).build(),
      height: json.data["height"] == null
          ? null
          : double.parse(json.data["height"].toString()),
      notchMargin: json.data["notchMargin"] == null
          ? 4.0
          : double.parse(json.data["notchMargin"].toString()),
      shadowColor: json.data["shadowColor"] == null
          ? null
          : Color.findColor(json.data["shadowColor"]).build(),
      elevation: json.data["elevation"] == null
          ? 8.0
          : double.parse(json.data["elevation"].toString()),
      clipBehavior: json.data["clipBehavior"] == null
          ? material.Clip.none
          : Clip.fromJson(json.data["clipBehavior"]).build(),
      child: json.data["child"] == null
          ? null
          : application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"]), context),
    );
  }
}
