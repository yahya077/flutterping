part of '../widget_builder.dart';

class WidgetBuilder extends ElementBuilder<material.Widget> {
  WidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return application
        .make<WidgetBuilder>(element.type)
        .build(Element.fromJson(element.data));
  }
}