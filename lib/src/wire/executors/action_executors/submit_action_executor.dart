part of '../action_executor.dart';

class SubmitActionExecutor extends ActionExecutor {
  SubmitActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final formState = application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet<material.GlobalKey<PingFormState>>(
            json.data["formStateId"] + ".formStateKey")
        .currentState!;

    final submitAction = Json.fromJson(json.data["submitAction"]);

    final path = application
        .make<ApiPathBuilder>(JsonDefinition.apiPathBuilder)
        .build(Json.fromJson(submitAction.data["path"]), context);

    final response = await application
        .make<Client>(submitAction.data["client"])
        .request(path.path,
            body: jsonEncode(formState.values),
            method: submitAction.data["method"] ?? "GET",
            headers: submitAction.data["headers"] != null
                ? Map<String, String>.from(submitAction.data["headers"])
                : {});

    final onStatusCodeActions = submitAction.data["onStatusCodeActions"] ?? {};

    if (onStatusCodeActions
        .containsKey(response.statusCode.toString())) {
      final action =
          Json.fromJson(onStatusCodeActions[response.statusCode.toString()]);
      await application
          .make<ActionExecutor>(action.data["type"])
          .execute(context, action);
    } else if (submitAction.data["thenAction"] != null) {
      final action = Json.fromJson(submitAction.data["thenAction"]);
      await application
          .make<ActionExecutor>(action.data["type"])
          .execute(context, action);
    }

    if (response.body == "" ||
        response.body.isEmpty ||
        response.body == "{}" ||
        response.statusCode == 500) {
      return;
    }

    final responseJson = Json.fromRawJson(response.body);

    final event = Event.fromJson(responseJson.data);

    if (response.statusCode == 422) {
      final action = Json.fromJson(event.payload);
      final errors = action.data["scope"]["context"]["errors"] ?? {};
      final castedErrors = errors.map((key, value) {
        if (value is List) {
          return MapEntry(key, List<String>.from(value.map((item) => item.toString())));
        } else if (value is Map) {
          return MapEntry(key, List<String>.from(value.entries.map((entry) => '${entry.key}: ${entry.value}')));
        } else {
          return MapEntry(key, [value.toString()]);
        }
      });

      castedErrors.forEach((key, value) {
        formState.setFieldError(key, value.join(", "));
      });
    }

    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}
