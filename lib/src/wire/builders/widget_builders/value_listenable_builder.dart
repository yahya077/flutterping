part of '../widget_builder.dart';

class ValueListenableBuilder extends WidgetBuilder {
  ValueListenableBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final Json childJson = Json.fromJson(json.data["child"]);

      return material.ValueListenableBuilder<dynamic>(
        valueListenable: application
            .make<NotifierValueBuilder>(json.data["valueListenable"]["type"])
            .build(Json.fromJson(json.data["valueListenable"]), context),
        builder: (context, value, _) {
          application
              .make<StateManager>(WireDefinition.stateManager)
              .bindScope(json.data["scopeId"], {
            "value": value ?? 0,
          });
          return application
              .make<WidgetBuilder>(childJson.type)
              .build(childJson, context);
        },
      );
  }
}
