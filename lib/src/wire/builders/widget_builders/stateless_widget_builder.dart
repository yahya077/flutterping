part of '../widget_builder.dart';

class StatelessWidgetBuilder extends WidgetBuilder {
  StatelessWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    return StatelessWidget(
      builder: (context) {
        application
            .make<ActionEventListener>(
                WireDefinition.containerActionEventListener)
            .listen(json.data["stateId"], context);
        return application
            .make<WidgetBuilder>(json.data["child"]["type"])
            .build(Json.fromJson(json.data["child"]));
      },
    );
  }
}
