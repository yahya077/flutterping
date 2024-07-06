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
      formState: state,
      formFieldState: fieldState,
    );
  }
}
