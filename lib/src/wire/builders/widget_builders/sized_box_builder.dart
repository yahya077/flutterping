part of '../widget_builder.dart';

class SizedBoxBuilder extends WidgetBuilder {
  SizedBoxBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.SizedBox(
      width: element.data["width"] == null
          ? null
          : double.parse(element.data["width"].toString()),
      height: element.data["height"] == null
          ? null
          : double.parse(element.data["height"].toString()),
      child: element.data["child"] == null
          ? null
          : application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}
