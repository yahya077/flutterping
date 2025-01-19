part of '../action_executor.dart';

class AlertActionExecutor extends ActionExecutor {
  AlertActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    material.ScaffoldMessenger.of(context).showSnackBar(material.SnackBar(
      behavior: material.SnackBarBehavior.floating,
      content: application
          .make<WidgetBuilder>(json.data["content"]["type"])
          .build(Json.fromJson(json.data["content"]), context),
      backgroundColor: json.data["color"] == null
          ? null
          : Color.findColor(json.data["color"]).build(),
    ));

    if (json.data["thenAction"] != null) {
      await application.make<ActionExecutor>(json.data["thenAction"]["type"]).execute(context, Json.fromJson(json.data["thenAction"]));
    }
  }
}