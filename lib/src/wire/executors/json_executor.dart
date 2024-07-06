import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';

class JsonExecutor {
  final Application application;

  JsonExecutor(this.application);

  Future<void> execute(material.BuildContext context, Json json) {
    throw UnimplementedError();
  }
}
