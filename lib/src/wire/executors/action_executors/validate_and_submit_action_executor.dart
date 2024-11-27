part of '../action_executor.dart';

class ValidateAndSubmitActionExecutor extends ActionExecutor {
  ValidateAndSubmitActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final formState = application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet<material.GlobalKey<PingFormState>>(
            json.data["formStateId"] + ".formStateKey")
        .currentState!;

    formState.save();

    if (!formState.validate()) {
      //TODO: implement not valid
    }

    final submitAction = Json.fromJson(json.data["submitAction"]);

    //TODO: implement
    submitAction.data["body"] = {
      "type": "DynamicValue",
      "data": {
        "value": formState.values,
      },
    };

    await application
        .make<NetworkRequestActionExecutor>(submitAction.type)
        .execute(context, submitAction);
  }
}
