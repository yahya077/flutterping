import '../../framework/app.dart';
import '../../framework/provider.dart';
import '../client.dart';
import '../config.dart';
import '../definitions/wire.dart';
import '../event_listeners/action_event_listener.dart';
import '../event_listeners/state_event_listener.dart';
import '../loader/loader.dart';
import '../state_manager.dart';
import '../stream.dart';

class WireProvider extends Provider {
  WireProvider();

  @override
  void register(Application app) {
    app.singleton(WireDefinition.containerClient, () => Client(app));
    app.singleton(WireDefinition.config, () => WireConfig());
    app.singleton(WireDefinition.eventDispatcher, () => EventDispatcher(app));
    app.singleton(WireDefinition.containerActionEventListener,
        () => ActionEventListener(app));
    app.singleton(WireDefinition.containerStateEventListener,
        () => StateEventListener(app));
    app.singleton(WireDefinition.stateManager, () => StateManager(app));
    app.singleton(WireDefinition.loaderPreLoader, () => PreLoader(app));
  }
}
