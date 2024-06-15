import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';

class ElementExecutor {
  final Application application;

  ElementExecutor(this.application);

  Future<void> execute(material.BuildContext context, Element element) {
    throw UnimplementedError();
  }
}
