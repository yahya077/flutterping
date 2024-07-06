part of 'carousel_slider.dart';

class CarouselSliderBuilder extends WidgetBuilder {
  CarouselSliderBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final options = json.data["options"];
    final carouselControllerEl = Json.fromJson(json.data["controller"]);
    final carouselController = application
        .make<CarouselControllerBuilder>(carouselControllerEl.type)
        .build(carouselControllerEl, context);
    application.make<StateManager>(WireDefinition.stateManager).set(
        WireDefinition.stateCallableRegistryState,
        carouselControllerEl.data["id"],
        carouselController);

    return StatelessWidget(builder: (context) {
      final indexNotifier = ValueProvider.of(context)
          .registerValueNotifier<int>("slider_index_notifier", defaultValue: 0);
      return carousel_slider.CarouselSlider(
        carouselController: carouselController.instance,
        items: json.data["items"] == null
            ? null
            : List<material.Widget>.from(
                json.data["items"].map<material.Widget>((item) {
                final itemEl = Json.fromJson(item);
                return application
                    .make<WidgetBuilder>(itemEl.type)
                    .build(itemEl, context);
              })),
        options: carousel_slider.CarouselOptions(
          onPageChanged: (index, reason) {
            indexNotifier.updateValue(index);
          },
          height: options["height"]?.toDouble(),
          aspectRatio: options["aspectRatio"] == null
              ? 16 / 9
              : options["aspectRatio"].toDouble(),
          viewportFraction: options["viewportFraction"] == null
              ? 0.8
              : options["viewportFraction"].toDouble(),
          initialPage: options["initialPage"] ?? 0,
          enableInfiniteScroll: options["enableInfiniteScroll"] ?? false,
          animateToClosest: options["animateToClosest"] ?? false,
          reverse: options["reverse"] ?? false,
          autoPlay: options["autoPlay"] ?? false,
          autoPlayInterval: options["autoPlayInterval"] == null
              ? const Duration(seconds: 4)
              : Duration(milliseconds: options["autoPlayInterval"]),
          autoPlayAnimationDuration: options["autoPlayAnimationDuration"] ==
                  null
              ? const Duration(milliseconds: 800)
              : Duration(milliseconds: options["autoPlayAnimationDuration"]),
          autoPlayCurve: options["autoPlayCurve"] == null
              ? material.Curves.fastOutSlowIn
              : Curves.fromJson(options["autoPlayCurve"]).build(),
        ),
      );
    });
  }
}
