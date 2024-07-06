part of 'animated_bottom_navigation_bar.dart';

class AnimatedBottomNavigationBarBuilder extends WidgetBuilder {
  AnimatedBottomNavigationBarBuilder(super.application);

  @override
  material.Widget build(Element element) {
    return StatelessWidget(builder: (context) {
      final activeIndexNotifier = ValueProvider.of(context)
          .registerValueNotifier<int>("active_index_notifier",
          defaultValue: 0);
      return AnimatedBottomNavigationBar(
        onTap: (index) {
          element.data["onTapEvents"] == null
              ? null
              : application
                  .make<EventDispatcher>(WireDefinition.eventDispatcher)
                  .dispatch(Event.fromJson(element.data["onTapEvents"][index]["data"]),
                      scopeContext: {
                      "index": index,
                    });
        },
        icons: List<material.IconData>.from(element.data["items"].map((x) {
          final itemElement = Element.fromJson(x);
          return material.IconData(
            itemElement.data["codePoint"],
            fontFamily: x["fontFamily"] ?? 'MaterialIcons',
          );
        })),
        activeIndex: activeIndexNotifier,
        //TODO implement the rest of the properties
      );
    });
  }
}
