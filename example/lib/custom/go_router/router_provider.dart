import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'router_builder.dart';
import 'router_config_builder.dart';
import 'routing_service.dart';

class GoRouteRouterProvider extends ServiceProvider {
  @override
  int get priority => 40; // Set priority level for this provider
  
  GoRouteRouterProvider();

  @override
  void register(Application app) {
    // Register router configuration and route builders
    app.singleton("GoRouteRouterConfig", () => GoRouteRouterConfigBuilder(app));
    app.singleton("GoRoute", () => GoRouteBuilder(app));
    app.singleton("StatefulShellRouteWithIndexedStack", 
        () => StatefulShellRouteWithIndexedStackBuilder(app));
    app.singleton("StatefulShellBranch", () => StatefulShellBranchBuilder(app));
    
    // Register routing service
    app.singleton(WireDefinition.routingService, () => GoRouterRoutingService(app));
  }
  
  @override
  Future<void> boot(Application app) async {
    // Add navigation state to the state manager during boot phase
    if (app.hasBinding(WireDefinition.stateManager)) {
      try {
        // Create and add navigation state if it doesn't exist
        final stateManager = app.make<StateManager>(WireDefinition.stateManager);
        await stateManager.addState(NavigationState.initial());
        
        if (kDebugMode) {
          print('Navigation state initialized');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing navigation state: $e');
        }
        // Non-fatal error, continue with boot
      }
    }
  }
}
