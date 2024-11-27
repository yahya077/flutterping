part of '../action_executor.dart';

class UpdateStateActionExecutor extends ActionExecutor {
  UpdateStateActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    var data = json.data;
    application
        .make<StateManager>(WireDefinition.stateManager)
        .setByKey(data["key"], data["value"]);
  }
}
