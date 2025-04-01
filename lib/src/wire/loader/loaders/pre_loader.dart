part of '../loader.dart';

class PreLoader extends Loader {
  PreLoader(Application application) : super(application);

  Future<T> load<T>(String loaderKey) async {
    try {
      final config_model.WireConfig config =
          application.make<WireConfig>(WireDefinition.config).allAs();

      final config_model.WireConfigLoader? loader = config.loaders[loaderKey];

      if (loader == null) {
        throw Exception("Loader not found for key: $loaderKey");
      }

      final response = await application
          .make<Client>(loader.client)
          .request(loader.endpoint, method: loader.method);

      final load = await application.make<ResponseHandler>(WireDefinition.responseHandler).handle(response, null);

      if (load == null) {
        throw Exception("Loader response is null");
      }

      return load;
    } catch (e) {
      //TODO handle exception
      rethrow;
    }
  }
}
