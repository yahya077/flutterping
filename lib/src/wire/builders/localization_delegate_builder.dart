import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import 'json_builder.dart';
import '../models/json.dart';

class LocalizationDelegateBuilder<T>
    extends JsonBuilder<material.LocalizationsDelegate<T>> {
  LocalizationDelegateBuilder(Application application) : super(application);

  @override
  material.LocalizationsDelegate<T> build(
      Json json, material.BuildContext? context) {
    throw UnimplementedError();
  }
}