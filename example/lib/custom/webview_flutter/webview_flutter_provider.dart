import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'webview_flutter.dart';

class WebviewFlutterProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  WebviewFlutterProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(WebviewFlutterDefinition.webviewFlutter,
          () => WebviewFlutterBuilder(app));
          
      if (kDebugMode) {
        print('WebviewFlutterProvider registered successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error registering WebviewFlutterProvider: $e');
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
        print('WebviewFlutterProvider booted successfully');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print('Error booting WebviewFlutterProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
