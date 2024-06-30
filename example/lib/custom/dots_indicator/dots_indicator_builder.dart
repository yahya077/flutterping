part of 'dots_indicator.dart';

class DotsIndicatorBuilder extends WidgetBuilder {
  DotsIndicatorBuilder(super.application);

  @override
  material.Widget build(Element element) {
    return StatelessWidget(builder: (context) {
      return DotsIndicator(
          dotsCount: element.data["dotsCount"],
          position: ValueProvider.of(context)
              .getValueNotifier<int>("slider_index_notifier")!,
          reversed: element.data["reversed"] ?? false,
          onTap: (index) {
            element.data["onTap"] == null
                ? null
                : application
                    .make<EventDispatcher>(WireDefinition.eventDispatcher)
                    .dispatch(Event.fromJson(element.data["onTap"]["data"]),
                        scopeContext: {
                        "index": index,
                      });
          });
    });
  }
}
