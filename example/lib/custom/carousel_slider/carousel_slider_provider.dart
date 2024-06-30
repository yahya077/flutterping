import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'carousel_slider.dart';

class CarouselSliderProvider extends Provider {
  CarouselSliderProvider();

  @override
  void register(Application app) {
    app.singleton(CarouselSliderDefinition.carouselSlider,
        () => CarouselSliderBuilder(app));
    app.singleton(CarouselSliderDefinition.carouselController,
        () => CarouselControllerBuilder(app));
  }
}
