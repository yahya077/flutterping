part of '../widget_builder.dart';

class TextBuilder extends WidgetBuilder {
  TextBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Text(
      element.data["text"],
      style: element.data["style"] == null
          ? null
          : TextStyle.fromJson(element.data["style"]).build(),
      textAlign: element.data["textAlign"] == null
          ? null
          : TextAlign.fromJson(element.data["textAlign"]).build(),
      textDirection: element.data["textDirection"] == null
          ? null
          : TextDirection.fromJson(element.data["textDirection"]).build(),
      softWrap: element.data["softWrap"] ?? false,
      overflow: element.data["overflow"] == null
          ? null
          : TextOverflow.fromJson(element.data["overflow"]).build(),
      maxLines: element.data["maxLines"],
      textScaleFactor: element.data["textScaleFactor"]?.toDouble(),
      textWidthBasis: element.data["textWidthBasis"] == null
          ? null
          : TextWidthBasis.fromJson(element.data["textWidthBasis"]).build(),
    );
  }
}
