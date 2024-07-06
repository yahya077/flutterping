part of '../loader.dart';

class PreLoader extends Loader {
  PreLoader(Application application) : super(application);

  Future<T> load<T>(String loaderKey) async {
    final config_model.WireConfig config =
        application.make<WireConfig>(WireDefinition.config).allAs();

    final config_model.WireConfigLoader? loader = config.loaders[loaderKey];

    if (loader == null) {
      throw Exception("Loader not found for key: $loaderKey");
    }

    final response = await application
        .make<Client>(loader.client)
        .request(loader.endpoint, method: loader.method);

    if (response.statusCode != 200) {
      throw Exception("Failed to load element: ${response.body}");
    }

    final element = Json.fromRawJson(response.body);

    return application.make<JsonBuilder>(element.type).build(element);
  }
}
