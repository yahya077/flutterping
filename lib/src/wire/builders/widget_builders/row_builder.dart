part of '../widget_builder.dart';

class RowBuilder extends WidgetBuilder {
  RowBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.Row(
      mainAxisAlignment: json.data["mainAxisAlignment"] == null
          ? material.MainAxisAlignment.start
          : Flex.findFlex(json.data["mainAxisAlignment"]).build(),
      crossAxisAlignment: json.data["crossAxisAlignment"] == null
          ? material.CrossAxisAlignment.start
          : Flex.findFlex(json.data["crossAxisAlignment"]).build(),
      children: json.data["children"]
          .map<material.Widget>((child) => application
          .make<WidgetBuilder>(child["type"])
          .build(Json.fromJson(child)))
          .toList(),
    );
  }
}