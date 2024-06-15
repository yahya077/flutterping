part of '../widget_builder.dart';

class ContainerBuilder extends WidgetBuilder {
  ContainerBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final Element? childElement = element.data["child"] == null ? null : Element.fromJson(element.data["child"]);
    return material.Container(
      color: element.data["color"] == null
          ? null
          : Color.findColor(element.data["color"]).build(),
      decoration: element.data["decoration"] == null
          ? null
          : Decoration.findElement(element.data["decoration"]).build(),
      margin: element.data["margin"] == null
          ? null
          : EdgeInsets.findElement(element.data["margin"]).build(),
      padding: element.data["padding"] == null
          ? null
          : EdgeInsets.findElement(element.data["padding"]).build(),
      width: element.data["width"] == null
          ? null
          : element.data["width"] == null
          ? null
          : double.parse(element.data["width"].toString()),
      height: element.data["height"] == null
          ? null
          : element.data["height"] == null
          ? null
          : double.parse(element.data["height"].toString()),
      child: childElement == null ? null : application
          .make<WidgetBuilder>(childElement.type)
          .build(childElement),
    );
  }
}
