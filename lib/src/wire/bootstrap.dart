import '../framework/framework.dart';
import 'provider/wire_framework_provider.dart';

class WireBootstrapper {
  final Application application;
  final List<ServiceProvider> _additionalProviders;

  WireBootstrapper(this.application, this._additionalProviders);

  void bootstrap() {
    application.register(WireFrameworkProvider());

    for (final provider in _additionalProviders) {
      application.register(provider);
    }
  }

  @override
  String toString() {
    return "WireBootstrapper";
  }
}