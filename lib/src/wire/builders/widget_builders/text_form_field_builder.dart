part of '../widget_builder.dart';

class TextFormFieldBuilder extends WidgetBuilder {
  TextFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<FormState>(json.data["formId"]);
    final fieldState = TextFormField(json.data["name"]);

    state.addFormField(fieldState);

    return TextInput(
      name: json.data["name"],
      decoration: json.data["decoration"] == null
          ? null
          : application
              .make<JsonBuilder<material.InputDecoration>>(
                  json.data["decoration"]["type"])
              .build(Json.fromJson(json.data["decoration"]), context),
      formState: state,
      formFieldState: fieldState,
      maxLength: json.data["maxLength"],
      maxLines: json.data["maxLines"],
      obscureText: json.data["obscureText"],
      minLines: json.data["minLines"],
    );
  }
}
