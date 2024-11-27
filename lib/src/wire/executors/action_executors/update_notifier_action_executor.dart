part of '../action_executor.dart';

class UpdateNotifierActionExecutor extends ActionExecutor {
  UpdateNotifierActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final manager = ValueProvider.of(context);
    manager.getValueNotifier(json.data["notifierId"])?.updateValue(application
        .make<JsonBuilder>(json.data["value"]["type"])
        .build(Json.fromJson(json.data["value"]), context));
  }
}