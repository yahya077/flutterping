part of 'dots_indicator.dart';

class DotsIndicatorBuilder extends WidgetBuilder {
  DotsIndicatorBuilder(super.application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return StatelessWidget(builder: (context) {
      return DotsIndicator(
          dotsCount: json.data["dotsCount"],
          position: ValueProvider.of(context)
              .getValueNotifier<int>("slider_index_notifier")!,
          reversed: json.data["reversed"] ?? false,
          onTap: (index) {
            json.data["onTap"] == null
                ? null
                : application
                    .make<EventDispatcher>(WireDefinition.eventDispatcher)
                    .dispatch(Event.fromJson(json.data["onTap"]["data"]),
                        scopeContext: {
                        "index": index,
                      });
          });
    });
  }
}
