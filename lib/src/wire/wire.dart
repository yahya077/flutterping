import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;

import '../framework/framework.dart';
import 'definitions/wire.dart';
import 'loader/loader.dart';
import 'value_provider.dart';

/// Wire application class with enhanced error handling and UI capabilities
class Wire {
  final Application application;

  Wire(this.application);

  /// Run the app with enhanced error handling
  Future<void> runApp({String loader = "app", Map<String, dynamic>? data}) async {
    try {
      if (kDebugMode) {
        print("Wire: Starting to load app with loader: $loader");
      }

      final rootWidget = await application
          .make<PreLoader>(WireDefinition.loaderPreLoader)
          .load<material.Widget>(loader, data: data);

      material.runApp(wrap(rootWidget));
      if (kDebugMode) {
        print("Wire: App initialized successfully");
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Wire: Error loading app: $e");
        print("Wire: Stack trace: $stackTrace");
      }
    }
  }

  /// Wrap widget with necessary providers and global overlay
  material.Widget wrap(material.Widget widget) {
    return ValueProvider(
      manager: ValueNotifierManager(),
      child: widget,
    );
  }
}
