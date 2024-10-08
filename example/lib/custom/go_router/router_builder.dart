import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:go_router/go_router.dart' as go_router;

class RouteBaseBuilder extends JsonBuilder<go_router.RouteBase> {
  RouteBaseBuilder(Application application) : super(application);

  @override
  go_router.RouteBase build(Json json, material.BuildContext? context) {
    return application.make<RouteBaseBuilder>(json.type).build(json, context);
  }
}

class GoRouteBuilder extends RouteBaseBuilder {
  GoRouteBuilder(Application application) : super(application);

  @override
  go_router.RouteBase build(Json json, material.BuildContext? context) {
    return go_router.GoRoute(
        name: json.data["name"],
        path: json.data["path"],
        pageBuilder: (context, state) {
          final pageState = State(state: {
            "id": json.data["stateId"],
            "stateId": json.data["stateId"],
            "uri": state.uri,
            "pathParameters": state.pathParameters,
            "extra": state.extra,
            "ctx": context,
          });

          application
              .make<StateManager>(WireDefinition.stateManager)
              .addState(pageState);

          final pageEl = Json.fromJson(json.data["page"]);
          return application
              .make<JsonBuilder>(pageEl.type)
              .build(pageEl, context);
        },
        routes: json.data["routes"]?.map<go_router.RouteBase>((route) {
              final routeEl = Json.fromJson(route);
              return application
                  .make<RouteBaseBuilder>(routeEl.type)
                  .build(routeEl, context);
            }).toList() ??
            []);
  }
}

class StatefulShellRouteWithIndexedStackBuilder extends RouteBaseBuilder {
  StatefulShellRouteWithIndexedStackBuilder(Application application)
      : super(application);

  @override
  go_router.RouteBase build(Json json, material.BuildContext? context) {
    final navigationState = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState);

    return go_router.StatefulShellRoute.indexedStack(
        branches:
            json.data["branches"].map<go_router.StatefulShellBranch>((branch) {
          final branchEl = Json.fromJson(branch);
          return application
              .make<StatefulShellBranchBuilder>(branchEl.type)
              .build(branchEl, context);
        }).toList(),
        pageBuilder: (
          material.BuildContext context,
          go_router.GoRouterState state,
          go_router.StatefulNavigationShell navigationShell,
        ) {
          navigationState.addStackKey(json.data["stackKey"], navigationShell);

          final pageState = State(state: {
            "id": json.data["stateId"],
            "stateId": json.data["stateId"],
            "uri": state.uri,
            "extra": state.extra,
            "pathParameters": state.pathParameters,
            "currentStackIndex": navigationShell.currentIndex,
            "currentStackKey": json.data["stackKey"],
            "ctx": context,
            "stackBody": navigationShell,
          });

          application
              .make<StateManager>(WireDefinition.stateManager)
              .addState(pageState);

          final wrapperPageEl = Json.fromJson(json.data["wrapperPage"]);
          return application
              .make<PageBuilder>(wrapperPageEl.type)
              .build(wrapperPageEl, context);
        });
  }
}

class StatefulShellBranchBuilder
    extends JsonBuilder<go_router.StatefulShellBranch> {
  StatefulShellBranchBuilder(Application application) : super(application);

  @override
  go_router.StatefulShellBranch build(
      Json json, material.BuildContext? context) {
    final navigationState = application
        .make<StateManager>(WireDefinition.stateManager)
        .getState<NavigationState>(WireDefinition.stateNavigationState);
    final branchNavigatorKey = material.GlobalKey<material.NavigatorState>();
    navigationState.addNavigatorKey(
        json.data["navigatorKey"], branchNavigatorKey);
    return go_router.StatefulShellBranch(
        navigatorKey: branchNavigatorKey,
        routes: json.data["routes"].map<go_router.RouteBase>((route) {
          final routeEl = Json.fromJson(route);
          return application
              .make<RouteBaseBuilder>(routeEl.type)
              .build(routeEl, context);
        }).toList());
  }
}
