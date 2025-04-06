import '../../framework/framework.dart';
import '../change_notifier_state.dart';
import '../client.dart';
import '../client_state.dart';
import '../config.dart';
import '../definitions/wire.dart';
import '../local_state.dart';
import '../services/device_info/device_info_handler.dart';
import '../services/device_info/device_info_state.dart';
import '../state_manager.dart';
import 'json_builder_provider.dart';
import 'wire_provider.dart';

class WireFrameworkProvider extends FrameworkServiceProvider {
  @override
  int get priority => 60; // Higher than individual providers

  final Map<String, ServiceProvider> _additionalProviders;

  WireFrameworkProvider({Map<String, ServiceProvider>? additionalProviders})
      : _additionalProviders = additionalProviders ?? {};

  @override
  void register(Application app) {
    // Register Wire core providers
    app.register(WireProvider());
    app.register(JsonBuilderProvider());

    // Register additional providers
    for (final provider in _additionalProviders.values) {
      app.register(provider);
    }
  }

  @override
  Future<void> boot(Application app) async {
    // Add initial states
    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(CallableRegistryState.initial());

    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(LocalState.initial());

    final deviceInfo = await DeviceInfoHandler.gatherAllDeviceInfo();
    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(DeviceInfoState.initialWithValues(deviceInfo));

    // Load and register clients from config
    final config =
        await app.make<WireConfig>(WireDefinition.config).ensureAllAs();

    config.clients.forEach((key, value) {
      app
          .make<StateManager>(WireDefinition.stateManager)
          .addState(ClientState.initial(value, deviceInfo,
              persistentStorage: app.make<PersistentStorageInterface>(
                WireDefinition.persistentStorage,
              )));

      // Register client
      app.singleton(key, () => Client(app));

      // Set state ID
      app
          .make<Client>(key)
          .setStateId("${WireDefinition.stateClientState}_$key");
    });
  }
}
