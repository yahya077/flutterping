part of '../action_executor.dart';

class ValidateAndSaveFormActionExecutor extends ActionExecutor {
  ValidateAndSaveFormActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final formState = application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet<material.GlobalKey<PingFormState>>(
            json.data["formStateId"] + ".formStateKey")
        .currentState;

    if (formState == null) {
      throw Exception(
          "Form state not found with id ${json.data["formStateId"]}");
    }

    formState.save();

    if (!formState.validate()) {
      return;
    }

    if (json.data["thenAction"] != null) {
      final action = Json.fromJson(json.data["thenAction"]);
      await application
          .make<ActionExecutor>(action.data["type"])
          .execute(context, action);
    }
  }
}
