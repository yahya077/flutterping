part of '../widget_builder.dart';

class ListViewBuilder extends WidgetBuilder {
  ListViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.ListView(
      controller: element.data["controller"] == null
          ? null
          : application
              .make<ScrollControllerBuilder>(element.data["controller"]["type"])
              .build(Element.fromJson(element.data["controller"])),
      scrollDirection: element.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(element.data["scrollDirection"]).build(),
      reverse: element.data["reverse"] ?? false,
      shrinkWrap: element.data["shrinkWrap"] ?? false,
      children: element.data["items"]
          .map<material.Widget>((child) => application
              .make<WidgetBuilder>(child["type"])
              .build(Element.fromJson(child)))
          .toList(),
    );
  }
}
