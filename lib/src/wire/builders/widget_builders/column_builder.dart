part of '../widget_builder.dart';

class ColumnBuilder extends WidgetBuilder {
  ColumnBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return material.Column(
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
