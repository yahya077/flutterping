import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import '../wire/resources/widgets/overlay.dart';
import 'container.dart';

class ExceptionHandler {
  final Container container;

  ExceptionHandler(this.container) {
    register();
  }

  void register() {}

  void report(e, stackTrace) {
    print("ExceptionHandler exception: $e, stackTrace: $stackTrace");
    throw e;
  }
}
