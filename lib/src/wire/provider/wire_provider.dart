import 'package:flutter_ping_wire/src/wire/services/exception/response_handler.dart';

import '../../framework/app.dart';
import '../../framework/provider.dart';
import '../client.dart';
import '../definitions/wire.dart';
import '../event_listeners/action_event_listener.dart';
import '../event_listeners/state_event_listener.dart';
import '../loader/loader.dart';
import '../wire.dart';

class WireProvider extends FrameworkServiceProvider {
  @override
  int get priority => 50; // Framework level service

  WireProvider();

  @override
  void register(Application app) {
    // Register non-dependent services
    app.singleton(WireDefinition.eventDispatcher, () => EventDispatcher(app));
    app.singleton(WireDefinition.containerActionEventListener,
        () => ActionEventListener(app));
    app.singleton(WireDefinition.containerStateEventListener,
        () => StateEventListener(app));

    // Register services that depend on config
    app.singleton(WireDefinition.containerClient, () => Client(app));
    app.singleton(WireDefinition.stateManager, () => StateManager(app));
    app.singleton(WireDefinition.loaderPreLoader, () => PreLoader(app));
    app.singleton(WireDefinition.wireService, () => Wire(app));
    app.singleton(WireDefinition.responseHandler, () => ResponseHandler(app));
  }
  
  @override
  Future<void> boot(Application app) async {
    print("WireProvider boot called");
    try {

    } catch (e) {
      // Log the error but don't crash the app
    }
  }
}
