import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';
import 'element_builder.dart';

class RouterConfigBuilder
    extends ElementBuilder<material.RouterConfig<Object>> {
  RouterConfigBuilder(Application application) : super(application);

  @override
  material.RouterConfig<Object> build(Element element) {
    return application.make<RouterConfigBuilder>(element.type).build(element);
  }
}
