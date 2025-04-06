import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'flutter_credit_card.dart';

class FlutterCreditCardProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  FlutterCreditCardProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(FlutterCreditCardDefinition.flutterCreditCard,
          () => FlutterCreditCardBuilder(app));
          
      if (kDebugMode) {
        print('FlutterCreditCardProvider registered successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error registering FlutterCreditCardProvider: $e');
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
        print('FlutterCreditCardProvider booted successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error booting FlutterCreditCardProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
