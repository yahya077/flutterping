part of '../action_executor.dart';

class ValidateAndSubmitActionExecutor extends ActionExecutor {
  ValidateAndSubmitActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<FormState>(json.data["formStateId"]!);

    final submitAction = Json.fromJson(json.data["submitAction"]);

    submitAction.data["body"] = state.getValues();

    await application
        .make<NetworkRequestActionExecutor>(submitAction.type)
        .execute(context, submitAction);
  }
}