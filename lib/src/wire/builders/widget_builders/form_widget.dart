part of '../widget_builder.dart';

class FormBuilder extends WidgetBuilder {
  FormBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final formStateKey = json.data["key"];
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .addNestedState(
            formStateKey,
            FormState.initial(formStateKey,
                formStateKey: material.GlobalKey<PingFormState>(
                    debugLabel: formStateKey)));
    return PingForm(
      key: state.get<material.GlobalKey<PingFormState>>('formStateKey'),
      autovalidateMode: json.data["autovalidateMode"] == null
          ? material.AutovalidateMode.disabled
          : AutovalidateMode.fromJson(json.data["autovalidateMode"]).build(),
      child: json.data["child"] != null
          ? application
              .make<Builder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context)
          : material.Container(),
    );
  }
}
