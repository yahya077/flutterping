part of '../action_executor.dart';

class DialogActionExecutor extends ActionExecutor {
  DialogActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final title = json.data["title"] ?? "Dialog";
    final message = json.data["message"] ?? "";
    final isDismissible = json.data["isDismissible"] ?? true;
    final defaultActionText = json.data["defaultActionText"] ?? "OK";
    final identifier = json.data["identifier"] ?? "dialog_${DateTime.now().millisecondsSinceEpoch}";
    
    final actions = <material.Widget>[];
    
    if (json.data["actions"] != null) {
      for (var action in json.data["actions"]) {
        actions.add(
          application
                    .make<WidgetBuilder>(action["type"])
                    .build(Json.fromJson(action), context)
        );
      }
    } else {
      actions.add(
        material.TextButton(
          onPressed: () {
            GlobalOverlay().hide(identifier: identifier);
          },
          child: material.Text(defaultActionText),
        ),
      );
    }
    
    // Show dialog using GlobalOverlay
    if (json.data["content"] != null) {
      // Custom content dialog
      GlobalOverlay().show(
        event: ShowDialogEvent(
          identifier: identifier,
          isDismissible: isDismissible,
          builder: (context) {
            return application
                .make<WidgetBuilder>(json.data["content"]["type"])
                .build(Json.fromJson(json.data["content"]), context);
          },
        ),
      );
    } else {
      // Standard alert dialog
      GlobalOverlay().show(
        event: ShowAlertEvent(
          identifier: identifier,
          title: title,
          message: message,
          isDismissible: isDismissible,
          actions: actions,
        ),
      );
    }

    if (json.data["thenAction"] != null) {
      final action = Json.fromJson(json.data["thenAction"]);
      await application
          .make<ActionExecutor>(action.data["type"])
          .execute(context, action);
    }
  }
}
