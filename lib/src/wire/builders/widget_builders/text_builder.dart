part of '../widget_builder.dart';

class TextBuilder extends WidgetBuilder {
  TextBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Text(
      application
          .make<StringValueBuilder>(JsonDefinition.stringValueBuilder)
          .build(json.data["text"], context: context),
      style: json.data["style"] == null
          ? null
          : TextStyle.fromJson(json.data["style"]).build(),
      textAlign: json.data["textAlign"] == null
          ? null
          : TextAlign.fromJson(json.data["textAlign"]).build(),
      textDirection: json.data["textDirection"] == null
          ? null
          : TextDirection.fromJson(json.data["textDirection"]).build(),
      softWrap: json.data["softWrap"] ?? false,
      overflow: json.data["overflow"] == null
          ? null
          : TextOverflow.fromJson(json.data["overflow"]).build(),
      maxLines: json.data["maxLines"],
      textScaler: json.data["textScaleFactor"]?.toDouble(),
      textWidthBasis: json.data["textWidthBasis"] == null
          ? null
          : TextWidthBasis.fromJson(json.data["textWidthBasis"]).build(),
    );
  }
}
