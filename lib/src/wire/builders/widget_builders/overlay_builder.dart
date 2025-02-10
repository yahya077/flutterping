part of '../widget_builder.dart';

class OverlayBuilder extends WidgetBuilder {
  OverlayBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return GlobalOverlayWidget(
        child: application
            .make<WidgetBuilder>(json.data["child"]["type"])
            .build(Json.fromJson(json.data["child"]), context));
  }
}
