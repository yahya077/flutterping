part of '../widget_builder.dart';

class VisibilityBuilder extends WidgetBuilder {
  VisibilityBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);

    final value = application
        .make<ValueBuilder>(json.data["visible"]["type"])
        .build(Json.fromJson(json.data["visible"]), context);

    if((value == false || value == null) && json.data["elseChild"] != null) {
      final Json elseChildJson = Json.fromJson(json.data["elseChild"]);
      return application
          .make<WidgetBuilder>(elseChildJson.type)
          .build(elseChildJson, context);
    }

    return material.Visibility(
      visible: value ?? false,
      child: application
          .make<WidgetBuilder>(childJson.type)
          .build(childJson, context),
    );
  }
}
