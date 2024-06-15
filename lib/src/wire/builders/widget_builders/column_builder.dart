part of '../widget_builder.dart';

class ColumnBuilder extends WidgetBuilder {
  ColumnBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Column(
      mainAxisAlignment: element.data["mainAxisAlignment"] == null
          ? material.MainAxisAlignment.start
          : Flex.findFlex(element.data["mainAxisAlignment"]).build(),
      crossAxisAlignment: element.data["crossAxisAlignment"] == null
          ? material.CrossAxisAlignment.start
          : Flex.findFlex(element.data["crossAxisAlignment"]).build(),
      children: element.data["children"]
          .map<material.Widget>((child) => application
              .make<WidgetBuilder>(child["type"])
              .build(Element.fromJson(child)))
          .toList(),
    );
  }
}
