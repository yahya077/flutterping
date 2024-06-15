part of '../action_executor.dart';

class NetworkRequestActionExecutor extends ActionExecutor {
  NetworkRequestActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final path = ApiPath.fromJson(element.data["path"]["data"]);
    //TODO rewrite client implementation
    final response = await application
        .make<Client>(element.data["client"])
        .request(path.path,
            body: jsonEncode(element.data["body"] ?? {}),
            method: element.data["method"] ?? "GET",
            headers: element.data["headers"] != null
                ? Map<String, String>.from(element.data["headers"])
                : {});

    //TODO handle server errors
    final responseElement = Element.fromRawJson(response.body);

    final event = Event.fromJson(responseElement.data);

    application
        .make<EventDispatcher>(WireDefinition.eventDispatcher)
        .dispatch(event);
  }
}
