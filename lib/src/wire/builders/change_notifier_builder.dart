import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';
import 'element_builder.dart';
import 'widget_builder.dart';

class ChangeNotifierBuilder extends ElementBuilder<material.ScrollController> {
  ChangeNotifierBuilder(Application application) : super(application);

  @override
  material.ScrollController build(Element element) {
    return application
        .make<ChangeNotifierBuilder>(element.type)
        .build(Element.fromJson(element.data));
  }
}

class ScrollControllerBuilder extends ChangeNotifierBuilder {
  ScrollControllerBuilder(Application application) : super(application);

  @override
  material.ScrollController build(Element element) {
    final id = element.data["id"];

    return application.make<StateManager>(WireDefinition.stateManager)
        .get<material.ScrollController>(WireDefinition.stateChangeNotifierState, id, defaultValue: material.ScrollController());
  }
}
