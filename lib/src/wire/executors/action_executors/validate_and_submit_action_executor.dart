part of '../action_executor.dart';

class ValidateAndSubmitActionExecutor extends ActionExecutor {
  ValidateAndSubmitActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final state = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<FormState>(element.data["formStateId"]!);

    final submitAction = Element.fromJson(element.data["submitAction"]);

    submitAction.data["body"] = state.getValues();

    await application
        .make<NetworkRequestActionExecutor>(submitAction.type)
        .execute(context, submitAction);
  }
}