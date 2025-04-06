import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'dots_indicator.dart';

class DotsIndicatorProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  DotsIndicatorProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(
          DotsIndicatorDefinition.dotsIndicator, () => DotsIndicatorBuilder(app));
          
      if (kDebugMode) {
        print('DotsIndicatorProvider registered successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error registering DotsIndicatorProvider: $e');
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
        print('DotsIndicatorProvider booted successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error booting DotsIndicatorProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
