part of '../action_executor.dart';

class NetworkRequestActionExecutor extends ActionExecutor {
  NetworkRequestActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final path = application
        .make<ApiPathBuilder>(JsonDefinition.apiPathBuilder)
        .build(Json.fromJson(json.data["path"]), context);

    Object? body;

    //TODO refactor api handling
    if (json.data["body"] != null) {
      body = application
          .make<Builder>(json.data["body"]["type"])
          .build(Json.fromJson(json.data["body"]), context);
    }

    if (body is Map) {
      body = body.map((key, value) {
        if (value is State) {
          return MapEntry(key, value.dehydrate());
        }
        return MapEntry(key, value);
      });
      body = jsonEncode(body);
    } else if (body is State) {
      body = body.dehydrate();
      body = jsonEncode(body);
    } else if (body is List) {
      body = body.map((e) {
        if (e is State) {
          return e.dehydrate();
        }
        return e;
      }).toList();
      body = jsonEncode(body);
    } else if (body is Object) {
      body = jsonEncode(body);
    }
    final response = await application
        .make<Client>(json.data["client"])
        .request(path.path,
            body: body ?? "",
            method: json.data["method"] ?? "GET",
            headers: json.data["headers"] != null
                ? Map<String, String>.from(json.data["headers"])
                : {});

    Map<String, dynamic> onStatusCodeActions = json.data["onStatusCodeActions"] ?? {};

    if (onStatusCodeActions.containsKey(response.statusCode.toString())) {
      application
          .make<ActionExecutor>(onStatusCodeActions[response.statusCode.toString()]["type"])
          .execute(context, Json.fromJson(onStatusCodeActions[response.statusCode.toString()]));
    } else if (json.data["thenAction"] != null) {
      application
          .make<ActionExecutor>(json.data["thenAction"]["type"])
          .execute(context, Json.fromJson(json.data["thenAction"]));
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
