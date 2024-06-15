import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:go_router/go_router.dart' as go_router;

class RouteBaseBuilder extends ElementBuilder<go_router.RouteBase> {
  RouteBaseBuilder(Application application) : super(application);

  @override
  go_router.RouteBase build(Element element) {
    return application.make<RouteBaseBuilder>(element.type).build(element);
  }
}

class GoRouteBuilder extends RouteBaseBuilder {
  GoRouteBuilder(Application application) : super(application);

  @override
  go_router.RouteBase build(Element element) {
    return go_router.GoRoute(
        name: element.data["name"],
        path: element.data["path"],
        pageBuilder: (context, state) {
          final pageState = State(state: {
            "id": element.data["stateId"],
            "stateId": element.data["stateId"],
            "uri": state.uri,
            "extra": state.extra,
            "ctx": context,
          });

          application
              .make<StateManager>(WireDefinition.stateManager)
              .addState(pageState);

          final pageEl = Element.fromJson(element.data["page"]);
          return application.make<PageBuilder>(pageEl.type).build(pageEl);
        },
        routes: element.data["routes"]?.map<go_router.RouteBase>((route) {
              final routeEl = Element.fromJson(route);
              return application
                  .make<RouteBaseBuilder>(routeEl.type)
                  .build(routeEl);
            }).toList() ??
            []);
  }
}

class StatefulShellRouteWithIndexedStackBuilder extends RouteBaseBuilder {
  StatefulShellRouteWithIndexedStackBuilder(Application application)
      : super(application);

  @override
  go_router.RouteBase build(Element element) {
    final navigationState = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState);

    return go_router.StatefulShellRoute.indexedStack(
        branches: element.data["branches"]
            .map<go_router.StatefulShellBranch>((branch) {
              final branchEl = Element.fromJson(branch);
          return application
              .make<StatefulShellBranchBuilder>(branchEl.type)
              .build(branchEl);
        }).toList(),
        pageBuilder: (
          material.BuildContext context,
          go_router.GoRouterState state,
          go_router.StatefulNavigationShell navigationShell,
        ) {
          navigationState.addStackKey(
              element.data["stackKey"], navigationShell);

          final pageState = State(state: {
            "id": element.data["stateId"],
            "stateId": element.data["stateId"],
            "uri": state.uri,
            "extra": state.extra,
            "currentStackIndex": navigationShell.currentIndex,
            "currentStackKey": element.data["stackKey"],
            "ctx": context,
            "stackBody": navigationShell,
          });

          application
              .make<StateManager>(WireDefinition.stateManager)
              .addState(pageState);

          final wrapperPageEl = Element.fromJson(element.data["wrapperPage"]);
          return application
              .make<PageBuilder>(wrapperPageEl.type)
              .build(wrapperPageEl);
        });
  }
}

class StatefulShellBranchBuilder
    extends ElementBuilder<go_router.StatefulShellBranch> {
  StatefulShellBranchBuilder(Application application) : super(application);

  @override
  go_router.StatefulShellBranch build(Element element) {
    final navigationState = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState);
    final branchNavigatorKey = material.GlobalKey<material.NavigatorState>();
    navigationState.addNavigatorKey(
        element.data["navigatorKey"], branchNavigatorKey);
    return go_router.StatefulShellBranch(
        navigatorKey: branchNavigatorKey,
        routes: element.data["routes"].map<go_router.RouteBase>((route) {
          final routeEl = Element.fromJson(route);
          return application
              .make<RouteBaseBuilder>(routeEl.type)
              .build(routeEl);
        }).toList());
  }
}
