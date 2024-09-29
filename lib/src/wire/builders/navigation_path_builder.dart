import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/builders/value_builder.dart';
import 'package:flutter_ping_wire/src/wire/models/path.dart';

import '../../../flutter_ping_wire.dart';

class NavigationPathBuilder extends JsonBuilder<NavigationPath> {
  NavigationPathBuilder(Application application) : super(application);

  @override
  NavigationPath build(Json json, material.BuildContext? context) {
    return NavigationPath(
      navigatorKey: json.data['navigatorKey'],
      path: application
          .make<StringValueBuilder>(JsonDefinition.stringValueBuilder)
          .build(json.data['path'], context: context),
      stackKey: json.data['stackKey'],
      index: json.data['index'],
      queryParameters: json.data['queryParameters'],
      pathParameters: json.data['pathParameters']?.map((key, value) => MapEntry(key, value.toString()))
          .cast<String, String>(),
    );
  }
}
