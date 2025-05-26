part of '../widget_builder.dart';

class ReactiveWidgetBuilder extends WidgetBuilder {
  ReactiveWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final stateSchema = ReactiveWidgetStateSchema.fromJson(json.data["state"]);
    final pageNotifierList =
        PageNotifier.listFromJson(json.data["pageNotifiers"] ?? []);

    return StatelessWidget(builder: (context) {
      final widgetNotifier = ValueProvider.of(context)
          .registerValueNotifier<material.Widget>(json.data["stateId"],
              defaultValue: material.Container());

      Map<String, ValueNotifier<dynamic>> pageNotifiers = {
        for (var page in pageNotifierList)
          page.notifierId: ValueProvider.of(context)
              .registerValueNotifier<dynamic>(page.notifierId,
                  defaultValue: page.defaultValue != null ? application
                      .make<ValueBuilder>(page.defaultValue["type"])
                      .build(Json.fromJson(page.defaultValue), context) : null)
      };

      return ReactiveMaterialWidget(
        widgetNotifier: widgetNotifier,
        pageNotifiers: pageNotifiers,
        actionEventListener: (context) {
          return application
              .make<ActionEventListener>(
                  WireDefinition.containerActionEventListener)
              .listen(json.data["stateId"], context);
        },
        stateEventListener: (context) {
          return application
              .make<StateEventListener>(
                  WireDefinition.containerStateEventListener)
              .listen(context, stateSchema, json.data["stateId"]);
        },
        disposeListeners: () {
          application
              .make<ActionEventListener>(
                  WireDefinition.containerActionEventListener)
              .dispose(json.data["stateId"]);

          application
              .make<StateEventListener>(
                  WireDefinition.containerStateEventListener)
              .dispose(json.data["stateId"]);
        },
        emitInitialState: (context) {
          for (var action in stateSchema.initialState.actions) {
            application
                .make<ActionExecutor>(action.type)
                .execute(context, action);
          }
        },
        initialWidgetBuilder: json.data["initialWidget"]["type"] != "Placeholder" ? (context) {
          return application
              .make<WidgetBuilder>(json.data["initialWidget"]["type"])
              .build(Json.fromJson(json.data["initialWidget"]), context);
        } : null,
      );
    });
  }
}
