import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';

class ElementBuilder<T> {
  final Application application;

  ElementBuilder(this.application);

  T build(Element element) {
    throw UnimplementedError();
  }
}
