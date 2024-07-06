part of '../widget_builder.dart';

class ReactiveWidgetBuilder extends WidgetBuilder {
  ReactiveWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final stateSchema = ReactiveWidgetStateSchema.fromJson(json.data["state"]);

    return StatelessWidget(builder: (context) {
      final widgetNotifier = ValueProvider.of(context)
          .registerValueNotifier<material.Widget>(json.data["stateId"],
              defaultValue: material.Container());
      return ReactiveMaterialWidget(
        widgetNotifier: widgetNotifier,
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
      );
    });
  }
}
