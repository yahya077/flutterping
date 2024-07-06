part of '../widget_builder.dart';

class FormBuilder extends WidgetBuilder {
  FormBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final formStateKey = material.GlobalKey<material.FormState>();
    final formState = FormState.initial(
        json.data["id"], formStateKey, json.data["parentStateId"]);

    application
        .make<StateManager>(WireDefinition.stateManager)
        .addState(formState);

    return FormWidget(
      formState: formState,
      children: json.data["formWidgets"]
          .map<material.Widget>((widget) => application
              .make<WidgetBuilder>(widget["type"])
              .build(Json.fromJson(widget), context))
          .toList(),
    );
  }
}
