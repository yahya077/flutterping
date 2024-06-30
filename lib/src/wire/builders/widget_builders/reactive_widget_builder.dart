part of '../widget_builder.dart';

class ReactiveWidgetBuilder extends WidgetBuilder {
  ReactiveWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final stateSchema =
        ReactiveWidgetStateSchema.fromJson(element.data["state"]);

    return StatelessWidget(builder: (context) {
      final widgetNotifier = ValueProvider.of(context)
          .registerValueNotifier<material.Widget>(element.data["stateId"],
              defaultValue: material.Container());
      return ReactiveMaterialWidget(
        widgetNotifier: widgetNotifier,
        actionEventListener: (context) {
          return application
              .make<ActionEventListener>(
                  WireDefinition.containerActionEventListener)
              .listen(element.data["stateId"], context);
        },
        stateEventListener: (context) {
          return application
              .make<StateEventListener>(
                  WireDefinition.containerStateEventListener)
              .listen(context, stateSchema, element.data["stateId"]);
        },
        disposeListeners: () {
          application
              .make<ActionEventListener>(
                  WireDefinition.containerActionEventListener)
              .dispose(element.data["stateId"]);

          application
              .make<StateEventListener>(
                  WireDefinition.containerStateEventListener)
              .dispose(element.data["stateId"]);
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
