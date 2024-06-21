part of '../widget_builder.dart';

class CardBuilder extends WidgetBuilder {
  CardBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Card(
      color: element.data["color"] == null
          ? null
          : Color.findColor(element.data["color"]).build(),
      elevation: element.data["elevation"] == null
          ? 1.0
          : double.parse(element.data["elevation"].toString()),
      shadowColor: element.data["shadowColor"] == null
          ? null
          : Color.findColor(element.data["shadowColor"]).build(),
      surfaceTintColor: element.data["surfaceTintColor"] == null
          ? null
          : Color.findColor(element.data["surfaceTintColor"]).build(),
      clipBehavior: element.data["clipBehavior"] != null ? Clip.fromJson(element.data["clipBehavior"]).build() : null,
      semanticContainer: element.data["semanticContainer"] ?? false,
      borderOnForeground: element.data["borderOnForeground"] ?? true,
      margin: element.data["margin"] == null
          ? null
          : EdgeInsets.findElement(element.data["margin"]).build(),
      shape: element.data["shape"] == null
          ? null
          : ShapeBorderFactory.findElement(element.data["shape"]).build(),
      child: element.data["child"] == null
          ? null
          : application.make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}