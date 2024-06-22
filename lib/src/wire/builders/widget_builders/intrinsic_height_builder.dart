part of '../widget_builder.dart';

class IntrinsicHeightBuilder extends WidgetBuilder {
  IntrinsicHeightBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.IntrinsicHeight(
      child: element.data['child'] == null
          ? null
          : application
              .make<WidgetBuilder>(element.data['child']['type'])
              .build(Element.fromJson(element.data['child'])),
    );
  }
}
