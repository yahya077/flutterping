part of '../action_executor.dart';

class LoadingActionExecutor extends ActionExecutor {
  LoadingActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final isLoading = json.data["isLoading"] ?? false;
    if (isLoading) {
      GlobalOverlay().hide(identifier: "global_loading");
    } else {
      GlobalOverlay().show(
          event: ShowLoadingEvent(
            message: json.data["message"] ?? "Yükleniyor...",
            identifier: "global_loading",
            isDismissible: json.data["isDismissible"] ?? false,
            builder: json.data["content"] != null
                ? (message) {
              return application
                  .make<WidgetBuilder>(json.data["content"]["type"])
                  .build(Json.fromJson(json.data["content"]), context);
            }
                : null,
          )
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
