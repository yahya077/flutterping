import 'app_exception_handler.dart';
import 'config.dart';
import 'container.dart';
import 'definitions/config.dart';
import 'definitions/containers.dart';
import 'definitions/logger.dart';
import 'dispatcher.dart';
import 'log_manager.dart';
import 'provider.dart';

class Application extends Container {
  final List<AbstractProvider> _registeredProviders = [];
  static Application? _instance;

  bool test = false;

  Application._() : super.newContainer() {
    registerBaseContainers();
  }

  static Application getInstance() {
    _instance ??= Application._();
    return _instance!;
  }

  void registerBaseContainers() async {
    singleton(ConfigDefinition.AppConfig, () => AppConfig());

    singleton(ContainerDefinition.AppExceptionHandler,
        () => AppExceptionHandler(this));

    singleton(ContainerDefinition.Events, () => Dispatcher());

    final logManager = LogManager({
      LogDefinition.ChannelFramework: FrameworkLogAdapter(),
    });

    singleton(ContainerDefinition.Logger, () => logManager);
  }

  void dispatch(String event) {
    make<Dispatcher>(ContainerDefinition.Events).dispatch(event);
  }

  register(Function implementation) {
    final provider = implementation();

    if (_registeredProviders
        .any((p) => p.runtimeType == provider.runtimeType)) {
      throw Exception("Provider already exists for ${provider.runtimeType}");
    }

    provider.register(this);

    _registeredProviders.add(provider);
  }
}
