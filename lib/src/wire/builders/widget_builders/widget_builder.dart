part of '../widget_builder.dart';

class WidgetBuilder extends JsonBuilder<material.Widget> {
  WidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    throw UnimplementedError();
  }
}
