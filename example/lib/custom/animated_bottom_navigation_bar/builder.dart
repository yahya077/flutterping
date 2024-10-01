part of 'animated_bottom_navigation_bar.dart';

class AnimatedBottomNavigationBarBuilder extends WidgetBuilder {
  AnimatedBottomNavigationBarBuilder(super.application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return StatelessWidget(builder: (context) {
      final activeIndexNotifier = ValueProvider.of(context)
          .registerValueNotifier<int>("active_index_notifier", defaultValue: 0);
      return AnimatedBottomNavigationBar(
          onTap: (index) {
            activeIndexNotifier.updateValue(index);
            json.data["onTapEvents"] == null
                ? null
                : application
                    .make<EventDispatcher>(WireDefinition.eventDispatcher)
                    .dispatch(
                        Event.fromJson(json.data["onTapEvents"][index]["data"]));
          },
          icons: List<material.IconData>.from(json.data["items"].map((x) {
            final itemElement = Json.fromJson(x);
            return material.IconData(
              itemElement.data["codePoint"],
              fontFamily: x["fontFamily"] ?? 'MaterialIcons',
            );
          })),
          activeIndex: activeIndexNotifier,
          activeColor: json.data["activeColor"] == null
              ? null
              : Color.findColor(json.data["activeColor"]).build(),
          inactiveColor: json.data["inactiveColor"] == null
              ? null
              : Color.findColor(json.data["inactiveColor"]).build()
          //TODO implement the rest of the properties
          );
    });
  }
}
