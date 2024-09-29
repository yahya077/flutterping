import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/builders/value_builder.dart';
import 'package:flutter_ping_wire/src/wire/models/path.dart';

import '../../../flutter_ping_wire.dart';

class ApiPathBuilder extends JsonBuilder<ApiPath> {
  ApiPathBuilder(Application application) : super(application);

  @override
  ApiPath build(Json json, material.BuildContext? context) {
    return ApiPath(
      application
          .make<StringValueBuilder>(JsonDefinition.stringValueBuilder)
          .build(json.data['path'], context: context),
      baseUrl: json.data['baseUrl'],
    );
  }
}
