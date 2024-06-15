part of '../widget_builder.dart';

class RowBuilder extends WidgetBuilder {
  RowBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Row(
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