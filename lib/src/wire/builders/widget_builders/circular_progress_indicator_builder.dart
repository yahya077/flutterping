part of '../widget_builder.dart';

class CircularProgressIndicatorBuilder extends WidgetBuilder {
  CircularProgressIndicatorBuilder(Application application)
      : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return const material.CircularProgressIndicator();
  }
}
