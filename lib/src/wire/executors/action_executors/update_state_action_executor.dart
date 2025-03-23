part of '../action_executor.dart';

class UpdateStateActionExecutor extends ActionExecutor {
  UpdateStateActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    var data = json.data;
    application.make<StateManager>(WireDefinition.stateManager).setByKey(
        data["key"],
        application
            .make<ValueBuilder>(data["value"]["type"])
            .build(Json.fromJson(data["value"]), context));

    if (json.data["thenAction"] != null) {
      await application
          .make<ActionExecutor>(json.data["thenAction"]["type"])
          .execute(context, Json.fromJson(json.data["thenAction"]));
    }
  }
}
