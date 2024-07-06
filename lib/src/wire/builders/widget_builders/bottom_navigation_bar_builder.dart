part of '../widget_builder.dart';

class BottomNavigationBarBuilder extends WidgetBuilder {
  BottomNavigationBarBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    final onTapEvents = json.data["onTapEvents"]
        .map<Event>((x) => Event.fromJson(x["data"]))
        .toList();
    return material.BottomNavigationBar(
        items: List<material.BottomNavigationBarItem>.from(json.data["items"]
            .map((x) => material.BottomNavigationBarItem(
            icon: application
                .make<WidgetBuilder>(x["data"]["icon"]["type"])
                .build(Json.fromJson(x["data"]["icon"])),
            label: x["data"]["label"]))),
        currentIndex: application.make<ValueManager>(WireDefinition.valueManager).getValue<int>(
            Value.fromJson(json.data["currentIndex"]["data"])),
        elevation: json.data["elevation"]?.toDouble(),
        iconSize: json.data["iconSize"] == null
            ? 24.0
            : json.data["iconSize"].toDouble(),
        selectedItemColor: json.data["selectedItemColor"] == null
            ? null
            : Color.findColor(json.data["selectedItemColor"]).build(),
        unselectedItemColor: json.data["unselectedItemColor"] == null
            ? null
            : Color.findColor(json.data["unselectedItemColor"]).build(),
        backgroundColor: json.data["backgroundColor"] == null ? null : Color.findColor(json.data["backgroundColor"]).build(),
        selectedFontSize: json.data["selectedFontSize"] == null ? 14.0 : json.data["selectedFontSize"].toDouble(),
        unselectedFontSize: json.data["unselectedFontSize"] == null ? 12.0 : json.data["unselectedFontSize"].toDouble(),
        selectedLabelStyle: json.data["selectedLabelStyle"] == null ? null : TextStyle.fromJson(json.data["selectedLabelStyle"]).build(),
        unselectedLabelStyle: json.data["unselectedLabelStyle"] == null ? null : TextStyle.fromJson(json.data["unselectedLabelStyle"]).build(),
        showSelectedLabels: json.data["showSelectedLabels"],
        showUnselectedLabels: json.data["showUnselectedLabels"],
        onTap: (index) {
          application
              .make<EventDispatcher>(WireDefinition.eventDispatcher)
              .dispatch(onTapEvents[index]);
        });
  }
}