part of '../widget_builder.dart';

class FormBuilder extends WidgetBuilder {
  FormBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final formStateKey = json.data["key"];
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .addNestedState(formStateKey, FormState.initial(formStateKey));

    return PingForm(
      key: state.get<material.GlobalKey<PingFormState>>('formStateKey'),
      child: json.data["child"] != null
          ? application
              .make<Builder>(json.data["child"]["type"])
              .build(Json.fromJson(json.data["child"]), context)
          : material.Container(),
    );
  }
}
