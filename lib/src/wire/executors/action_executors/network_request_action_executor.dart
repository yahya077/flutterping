part of '../action_executor.dart';

class NetworkRequestActionExecutor extends ActionExecutor {
  NetworkRequestActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final path = ApiPath.fromJson(json.data["path"]["data"]);

    final response = await application
        .make<Client>(json.data["client"])
        .request(path.path,
            body: jsonEncode(json.data["body"] ?? {}),
            method: json.data["method"] ?? "GET",
            headers: json.data["headers"] != null
                ? Map<String, String>.from(json.data["headers"])
                : {});

    //TODO handle server errors
    final responseJson = Json.fromRawJson(response.body);

    final event = Event.fromJson(responseJson.data);

    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}
