import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';
import 'json_builder.dart';
import 'widget_builder.dart';

class PageBuilder extends JsonBuilder<material.Page> {
  PageBuilder(Application application) : super(application);

  @override
  material.Page build(Json json) {
    return application
        .make<PageBuilder>(json.type)
        .build(Json.fromJson(json.data));
  }
}

class MaterialPageBuilder extends PageBuilder {
  MaterialPageBuilder(Application application) : super(application);

  @override
  material.Page build(Json json) {
    return material.MaterialPage(
      child: application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"])),
      fullscreenDialog: json.data["fullscreenDialog"] ?? false,
    );
  }
}
