part of '../action_executor.dart';

class ValidateAndSubmitActionExecutor extends ActionExecutor {
  ValidateAndSubmitActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final formState = application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet<material.GlobalKey<PingFormState>>(
            json.data["formStateId"] + ".formStateKey")
        .currentState!;

    formState.save();

    if (!formState.validate()) {
      return;
    }

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

    if (response.statusCode == 422) {
      final result = badRequestResponseFromJson(response.body);

      result.data.forEach((key, value) {
        formState.setFieldError(key, value.join(", "));
      });

    } else if (onStatusCodeActions.containsKey(response.statusCode.toString())) {
      final action = Json.fromJson(onStatusCodeActions[response.statusCode.toString()]);
      await application
          .make<ActionExecutor>(action.data["type"])
          .execute(context, action);
    }

    if (response.body == "" || response.body.isEmpty || response.body == "{}") {
      return;
    }

    final responseJson = Json.fromRawJson(response.body);

    final event = Event.fromJson(responseJson.data);

    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}
