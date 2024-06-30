part of '../widget_builder.dart';

class StatelessWidgetBuilder extends WidgetBuilder {
  StatelessWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return StatelessWidget(
      builder: (context) {
        final String? stateId = element.data["stateId"];

        if (stateId != null) {
          application
              .make<StateManager>(WireDefinition.stateManager)
              .addState(base_state.State(state: {
                "id": stateId,
                //TODO : implement this
                /*"widgetNotifier": ReactiveWidgetProvider.of(context)
                    .createReactiveWidgetNotifier(stateId),*/
                "ctx": context,
              }));
        }
        application
            .make<ActionEventListener>(
                WireDefinition.containerActionEventListener)
            .listen(element.data["stateId"], context);
        return application
            .make<WidgetBuilder>(element.data["child"]["type"])
            .build(Element.fromJson(element.data["child"]));
      },
    );
  }
}
