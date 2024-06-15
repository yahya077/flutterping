import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';
import 'element_builder.dart';
import 'widget_builder.dart';

class PageBuilder extends ElementBuilder<material.Page> {
  PageBuilder(Application application) : super(application);

  @override
  material.Page build(Element element) {
    return application
        .make<PageBuilder>(element.type)
        .build(Element.fromJson(element.data));
  }
}

class MaterialPageBuilder extends PageBuilder {
  MaterialPageBuilder(Application application) : super(application);

  @override
  material.Page build(Element element) {
    return material.MaterialPage(
      child: application
          .make<WidgetBuilder>(element.data["child"]["type"])
          .build(Element.fromJson(element.data["child"])),
      fullscreenDialog: element.data["fullscreenDialog"] ?? false,
    );
  }
}
