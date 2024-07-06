part of 'carousel_slider.dart';

class CarouselControllerBuilder extends JsonBuilder<CarouselController> {
  CarouselControllerBuilder(Application application) : super(application);

  @override
  CarouselController build(Json json) {
    final id = json.data["id"];

    return application
        .make<StateManager>(WireDefinition.stateManager)
        .get<CarouselController>(WireDefinition.stateCallableRegistryState, id,
            defaultValue:
                CarouselController(carousel_controller.CarouselController()));
  }
}

class CarouselController
    extends CallableRegistry<carousel_controller.CarouselController> {
  static const String nextPage = "nextPage";
  static const String previousPage = "previousPage";
  static const String jumpToPage = "jumpToPage";
  static const String animateToPage = "animateToPage";
  static const String startAutoPlay = "startAutoPlay";
  static const String stopAutoPlay = "stopAutoPlay";

  CarouselController(super.instance);

  @override
  initCallables() {
    callables = {
      nextPage: (_) {
        instance.nextPage();
      },
      previousPage: (_) {
        instance.previousPage();
      },
      jumpToPage: (arguments) {
        final page = arguments!["page"];
        return instance.jumpToPage(page);
      },
      animateToPage: (arguments) {
        final page = arguments!["page"];
        final duration = arguments["duration"];
        final curve = arguments["curve"];

        return instance.animateToPage(page,
            duration: duration ?? const Duration(milliseconds: 300),
            curve: curve ?? material.Curves.linear);
      },
      startAutoPlay: (_) {
        return instance.startAutoPlay();
      },
      stopAutoPlay: (_) {
        instance.stopAutoPlay();
      }
    };
  }
}
