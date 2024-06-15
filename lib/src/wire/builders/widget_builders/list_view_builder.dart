part of '../widget_builder.dart';

class ListViewBuilder extends WidgetBuilder {
  ListViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.ListView(
      scrollDirection: element.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(element.data["scrollDirection"]).build(),
      children: element.data["items"]
          .map<material.Widget>((child) => application
          .make<WidgetBuilder>(child["type"])
          .build(Element.fromJson(child)))
          .toList(),
    );
  }
}