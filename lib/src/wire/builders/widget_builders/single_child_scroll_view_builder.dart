part of '../widget_builder.dart';

class SingleChildScrollViewBuilder extends WidgetBuilder {
  SingleChildScrollViewBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final Element? childElement = element.data["child"] == null ? null : Element.fromJson(element.data["child"]);
    return material.SingleChildScrollView(
      controller: element.data["controller"] == null
          ? null
          : application
              .make<ScrollControllerBuilder>(element.data["controller"]["type"])
              .build(Element.fromJson(element.data["controller"])),
      scrollDirection: element.data["scrollDirection"] == null
          ? material.Axis.vertical
          : BasicType.find(element.data["scrollDirection"]).build(),
      reverse: element.data["reverse"] ?? false,
      child: childElement == null ? null : application
          .make<WidgetBuilder>(childElement.type)
          .build(childElement),
    );
  }
}