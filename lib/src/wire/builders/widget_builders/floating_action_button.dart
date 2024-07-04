part of '../widget_builder.dart';

class FloatingActionButtonBuilder extends WidgetBuilder {
  FloatingActionButtonBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.FloatingActionButton(
      disabledElevation: element.data["disabledElevation"] == null
          ? 6.0
          : double.parse(element.data["disabledElevation"].toString()),
      elevation: element.data["elevation"] == null
          ? 6.0
          : double.parse(element.data["elevation"].toString()),
      highlightElevation: element.data["highlightElevation"] == null
          ? 12.0
          : double.parse(element.data["highlightElevation"].toString()),
      hoverElevation: element.data["hoverElevation"] == null
          ? 8.0
          : double.parse(element.data["hoverElevation"].toString()),
      focusElevation: element.data["focusElevation"] == null
          ? 12.0
          : double.parse(element.data["focusElevation"].toString()),
      splashColor: element.data["splashColor"] == null
          ? null
          : Color.findColor(element.data["splashColor"]).build(),
      hoverColor: element.data["hoverColor"] == null
          ? null
          : Color.findColor(element.data["hoverColor"]).build(),
      focusColor: element.data["focusColor"] == null
          ? null
          : Color.findColor(element.data["focusColor"]).build(),
      backgroundColor: element.data["backgroundColor"] == null
          ? null
          : Color.findColor(element.data["backgroundColor"]).build(),
      onPressed: () {
        element.data["onPressed"] == null
            ? null
            : application
                .make<EventDispatcher>(WireDefinition.eventDispatcher)
                .dispatch(Event.fromJson(element.data["onPressed"]["data"]));
      },
      child: application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
    );
  }
}
