part of '../widget_builder.dart';

class BottomNavigationBarBuilder extends WidgetBuilder {
  BottomNavigationBarBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final onTapEvents = element.data["onTapEvents"]
        .map<Event>((x) => Event.fromJson(x["data"]))
        .toList();
    return material.BottomNavigationBar(
        items: List<material.BottomNavigationBarItem>.from(element.data["items"]
            .map((x) => material.BottomNavigationBarItem(
            icon: application
                .make<WidgetBuilder>(x["data"]["icon"]["type"])
                .build(Element.fromJson(x["data"]["icon"])),
            label: x["data"]["label"]))),
        currentIndex: application.make<ValueManager>(WireDefinition.valueManager).getValue<int>(
            Value.fromJson(element.data["currentIndex"]["data"])),
        elevation: element.data["elevation"] == null
            ? null
            : element.data["elevation"].toDouble(),
        iconSize: element.data["iconSize"] == null
            ? 24.0
            : element.data["iconSize"].toDouble(),
        selectedItemColor: element.data["selectedItemColor"] == null
            ? null
            : Color.fromJson(element.data["selectedItemColor"]).build(),
        unselectedItemColor: element.data["unselectedItemColor"] == null
            ? null
            : Color.fromJson(element.data["unselectedItemColor"]).build(),
        backgroundColor: element.data["backgroundColor"] == null ? null : Color.fromJson(element.data["backgroundColor"]).build(),
        selectedFontSize: element.data["selectedFontSize"] == null ? 14.0 : element.data["selectedFontSize"].toDouble(),
        unselectedFontSize: element.data["unselectedFontSize"] == null ? 12.0 : element.data["unselectedFontSize"].toDouble(),
        selectedLabelStyle: element.data["selectedLabelStyle"] == null ? null : TextStyle.fromJson(element.data["selectedLabelStyle"]).build(),
        unselectedLabelStyle: element.data["unselectedLabelStyle"] == null ? null : TextStyle.fromJson(element.data["unselectedLabelStyle"]).build(),
        showSelectedLabels: element.data["showSelectedLabels"] == null ? null : element.data["showSelectedLabels"],
        showUnselectedLabels: element.data["showUnselectedLabels"] == null ? null : element.data["showUnselectedLabels"],
        onTap: (index) {
          application
              .make<EventDispatcher>(WireDefinition.eventDispatcher)
              .dispatch(onTapEvents[index]);
        });
  }
}