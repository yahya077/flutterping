part of '../widget_builder.dart';

class ReactiveWidgetBuilder extends WidgetBuilder {
  ReactiveWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final stateManager =
        application.make<StateManager>(WireDefinition.stateManager);
    final parentState =
        stateManager.getState<base_state.State>(element.data["parentStateId"]);
    final widgetNotifier =
        ReactiveWidgetProvider.of(parentState.get<material.BuildContext>('ctx'))
            .createReactiveWidgetNotifier(element.data["stateId"]);

    stateManager
        .addState(base_state.State.withId(element.data["stateId"]))
        .set("widgetNotifier", widgetNotifier);
    final stateSchema =
        ReactiveWidgetStateSchema.fromJson(element.data["state"]);
    return ReactiveMaterialWidget(
      stateId: element.data["stateId"],
      state: ReactiveWidgetStateSchema.fromJson(element.data["state"]),
      widgetNotifier: widgetNotifier,
      actionEventListener: (context) {
        return application
            .make<ActionEventListener>(
                WireDefinition.containerActionEventListener)
            .listen(element.data["stateId"], context);
      },
      stateEventListener: (context) {
        return application
            .make<StateEventListener>(WireDefinition.containerStateEventListener)
            .listen(context, stateSchema, element.data["stateId"]);
      },
      disposeListeners: () {
        application
            .make<ActionEventListener>(
                WireDefinition.containerActionEventListener)
            .dispose(element.data["stateId"]);

        application
            .make<StateEventListener>(WireDefinition.containerStateEventListener)
            .dispose(element.data["stateId"]);
      },
      emitInitialState: (context) {
        final state = ReactiveWidgetStateSchema.fromJson(element.data["state"])
            .getState(ReactiveWidgetStateSchema.fromJson(element.data["state"])
                .initialStateName);
        for (var action in state.actions) {
          application
              .make<ActionExecutor>(action.type)
              .execute(context, action);
        }
      },
    );
  }
}
