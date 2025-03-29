part of '../action_executor.dart';

/// Action executor for network requests that uses the enhanced Client class
class NetworkRequestActionExecutor extends ActionExecutor {
  NetworkRequestActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    try {
      final path = application
          .make<ApiPathBuilder>(JsonDefinition.apiPathBuilder)
          .build(Json.fromJson(json.data["path"]), context);

      dynamic body;

      if (json.data["body"] != null) {
      body = application
          .make<ValueBuilder>(json.data["body"]["type"])
          .build(Json.fromJson(json.data["body"]), context);
      }

      final headers = json.data["headers"];

      final method = json.data["method"];

      final response = await application
          .make<Client>(json.data["client"])
          .request(
        path.path,
        method: method,
        body: body,
        headers: headers,
      );

      Map<String, dynamic> onStatusCodeActions = json.data["onStatusCodeActions"] ?? {};

      if (onStatusCodeActions.containsKey(response.statusCode.toString())) {
        application
            .make<ActionExecutor>(onStatusCodeActions[response.statusCode.toString()]["type"])
            .execute(context, Json.fromJson(onStatusCodeActions[response.statusCode.toString()]));
        return;
      } else if (json.data["thenAction"] != null && response.statusCode >= 200 && response.statusCode < 300) {
        await application
            .make<ActionExecutor>(json.data["thenAction"]["type"])
            .execute(context, Json.fromJson(json.data["thenAction"]));
        return;
      } else {
        application
            .make<ResponseHandler>(WireDefinition.responseHandler)
            .handle(response, body, context: context);
      }
    }
    catch (e, stackTrace) {
      application.make<ExceptionHandler>(ContainerDefinition.appExceptionHandler).report(e, stackTrace);
    }
  }
}
