part of '../widget_builder.dart';

class StatelessWidgetBuilder extends WidgetBuilder {
  StatelessWidgetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return StatelessWidget(
        widget: application
            .make<WidgetBuilder>(element.data["child"]["type"])
            .build(Element.fromJson(element.data["child"])),
        eventListener: (context) {
          return application
              .make<ActionEventListener>(
              WireDefinition.containerActionEventListener)
              .listen(element.data["stateId"], context);
        });
  }
}