import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:go_router/go_router.dart' as go_router;

import 'router_builder.dart';

class GoRouteRouterConfigBuilder extends RouterConfigBuilder {
  GoRouteRouterConfigBuilder(Application application) : super(application);

  @override
  material.RouterConfig<Object> build(Element element) {
    RouterConfigData data = RouterConfigData.fromJson(element.data);

    application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState)
        .setInitialLocation(data.initialRoutePath);

    return go_router.GoRouter(
      initialLocation: data.initialRoutePath,
      navigatorKey: application
          .make<StateManager>(WireDefinition.stateManager)
          .getState<NavigationState>(WireDefinition.stateNavigationState)
          .getMainNavigatorKey(),
      routes: data.routes.map((route) {
        final el = Element.fromJson(route);
        return application.make<RouteBaseBuilder>(el.type).build(el);
      }).toList(),
    );
  }
}
