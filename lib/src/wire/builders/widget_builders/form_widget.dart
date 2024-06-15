part of '../widget_builder.dart';
class FormBuilder extends WidgetBuilder {
  FormBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final formStateKey = material.GlobalKey<material.FormState>();
    final formState = FormState.initial(
        element.data["id"], formStateKey, element.data["parentStateId"]);

    application
        .make<StateManager>(WireDefinition.stateManager)
        .addState(formState);

    return FormWidget(
      formState: formState,
      children: element.data["formWidgets"]
          .map<material.Widget>((widget) => application
              .make<WidgetBuilder>(widget["type"])
              .build(Element.fromJson(widget)))
          .toList(),
    );
  }
}
