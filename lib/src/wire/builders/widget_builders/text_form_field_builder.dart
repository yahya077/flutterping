part of '../widget_builder.dart';

class TextFormFieldBuilder extends WidgetBuilder {
  TextFormFieldBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<FormState>(element.data["formId"]);
    final fieldState = TextFormField(element.data["name"]);

    state.addFormField(fieldState);

    return TextInput(
      name: element.data["name"],
      formState: state,
      formFieldState: fieldState,
    );
  }
}
