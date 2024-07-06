import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';

abstract class Builder<T> {
  T build(Json json);
}

class JsonBuilder<T> extends Builder<T> {
  final Application application;

  JsonBuilder(this.application);

  @override
  T build(Json json) {
    throw UnimplementedError();
  }
}
