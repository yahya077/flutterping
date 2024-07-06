import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';
import 'json_builder.dart';

class RouterConfigBuilder
    extends JsonBuilder<material.RouterConfig<Object>> {
  RouterConfigBuilder(Application application) : super(application);

  @override
  material.RouterConfig<Object> build(Json json) {
    return application.make<RouterConfigBuilder>(json.type).build(json);
  }
}
