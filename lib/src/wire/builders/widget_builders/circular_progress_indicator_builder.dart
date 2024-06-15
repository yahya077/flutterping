part of '../widget_builder.dart';

class CircularProgressIndicatorBuilder extends WidgetBuilder {
  CircularProgressIndicatorBuilder(Application application)
      : super(application);

  @override
  material.Widget build(Element element) {
    return const material.CircularProgressIndicator();
  }
}