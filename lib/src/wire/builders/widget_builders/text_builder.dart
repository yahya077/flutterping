part of '../widget_builder.dart';

class TextBuilder extends WidgetBuilder {
  TextBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Text(
      element.data["text"],
      style: element.data["style"] == null || element.data["style"]["element"] == null
          ? null
          : TextStyle.fromJson(element.data["style"]["element"]).build(),
    );
  }
}
