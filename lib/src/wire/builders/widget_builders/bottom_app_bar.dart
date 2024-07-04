part of '../widget_builder.dart';

class BottomAppBarBuilder extends WidgetBuilder {
  BottomAppBarBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.BottomAppBar(
      padding: element.data["padding"] == null
          ? null
          : Padding.fromJson(element.data["padding"]).build(),
      surfaceTintColor: element.data["surfaceTintColor"] == null
          ? null
          : Color.findColor(element.data["surfaceTintColor"]).build(),
      height: element.data["height"] == null
          ? null
          : double.parse(element.data["height"].toString()),
      notchMargin: element.data["notchMargin"] == null
          ? 4.0
          : double.parse(element.data["notchMargin"].toString()),
      shadowColor: element.data["shadowColor"] == null
          ? null
          : Color.findColor(element.data["shadowColor"]).build(),
      elevation: element.data["elevation"] == null
          ? 8.0
          : double.parse(element.data["elevation"].toString()),
      clipBehavior: element.data["clipBehavior"] == null
          ? material.Clip.none
          : Clip.fromJson(element.data["clipBehavior"]).build(),
      child: element.data["child"] == null
          ? null
          : application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}
