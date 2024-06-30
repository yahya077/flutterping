import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/element.dart';
import 'element_builder.dart';
import 'widget_builder.dart';
import '../resources/ui/color.dart';

class PreferredSizeWidgetBuilder
    extends ElementBuilder<material.PreferredSizeWidget> {
  PreferredSizeWidgetBuilder(Application application) : super(application);

  @override
  material.PreferredSizeWidget build(Element element) {
    return application
        .make<PreferredSizeWidgetBuilder>(element.type)
        .build(Element.fromJson(element.data));
  }
}

class AppBarBuilder extends PreferredSizeWidgetBuilder {
  AppBarBuilder(Application application) : super(application);

  @override
  material.AppBar build(Element element) {
    return material.AppBar(
      title: element.data["title"] == null
          ? null
          : application
              .make<WidgetBuilder>(element.data["title"]["type"])
              .build(Element.fromJson(element.data["title"])),
      leading: element.data["leading"] == null
          ? null
          : application
              .make<WidgetBuilder>(element.data["leading"]["type"])
              .build(Element.fromJson(element.data["leading"])),
      actions: element.data["actions"] == null
          ? null
          : List<material.Widget>.from(element.data["actions"].map((x) =>
              application
                  .make<WidgetBuilder>(element.type)
                  .build(Element.fromJson(x)))),
      elevation: element.data["elevation"]?.toDouble(),
      backgroundColor: element.data["backgroundColor"] == null
          ? null
          : Color.findColor(element.data["backgroundColor"]).build(),
      centerTitle: element.data["centerTitle"] ?? false,
    );
  }
}
