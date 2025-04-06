import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'carousel_slider.dart';

class CarouselSliderProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  CarouselSliderProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(CarouselSliderDefinition.carouselSlider,
          () => CarouselSliderBuilder(app));
      app.singleton(CarouselSliderDefinition.carouselController,
          () => CarouselControllerBuilder(app));
          
      if (kDebugMode) {
        print('CarouselSliderProvider registered successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error registering CarouselSliderProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
  
  @override
  Future<void> boot(Application app) async {
    try {
      // Any initialization that requires other services
      if (kDebugMode) {
        print('CarouselSliderProvider booted successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error booting CarouselSliderProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
