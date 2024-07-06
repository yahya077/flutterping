import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'router_builder.dart';
import 'router_config_builder.dart';
import 'routing_service.dart';

class GoRouteRouterProvider extends Provider {
  GoRouteRouterProvider();

  @override
  void register(Application app) {
    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(NavigationState.initial());
    app.singleton(
        WireDefinition.routingService, () => GoRouterRoutingService(app));
    app.singleton("GoRouteRouterConfig", () => GoRouteRouterConfigBuilder(app));
    app.singleton("GoRoute", () => GoRouteBuilder(app));
    app.singleton("StatefulShellRouteWithIndexedStack",
        () => StatefulShellRouteWithIndexedStackBuilder(app));
    app.singleton("StatefulShellBranch", () => StatefulShellBranchBuilder(app));
  }
}
