import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';

abstract class Builder<T> {
  T build(Json json, material.BuildContext? context);
}

class JsonBuilder<T> extends Builder<T> {
  final Application application;

  JsonBuilder(this.application);

  @override
  T build(Json json, material.BuildContext? context) {
    throw UnimplementedError();
  }
}
