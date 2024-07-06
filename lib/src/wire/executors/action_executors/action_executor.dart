part of '../action_executor.dart';

class ActionExecutor extends JsonExecutor {
  ActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    await application.make<ActionExecutor>(json.type).execute(context, json);
  }
}
