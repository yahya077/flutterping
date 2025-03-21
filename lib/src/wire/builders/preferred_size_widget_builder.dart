import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';

import '../models/json.dart';
import 'json_builder.dart';
import 'widget_builder.dart';
import '../resources/ui/color.dart';

class PreferredSizeWidgetBuilder
    extends JsonBuilder<material.PreferredSizeWidget> {
  PreferredSizeWidgetBuilder(Application application) : super(application);

  @override
  material.PreferredSizeWidget build(
      Json json, material.BuildContext? context) {
    return application
        .make<PreferredSizeWidgetBuilder>(json.type)
        .build(Json.fromJson(json.data), context);
  }
}

class AppBarBuilder extends PreferredSizeWidgetBuilder {
  AppBarBuilder(Application application) : super(application);
  @override
  material.AppBar build(Json json, material.BuildContext? context) {
    return material.AppBar(
      title: json.data["title"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["title"]["type"])
              .build(Json.fromJson(json.data["title"]), context),
      leading: json.data["leading"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["leading"]["type"])
              .build(Json.fromJson(json.data["leading"]), context),
      actions: json.data["actions"] == null
          ? null
          : List<material.Widget>.from(json.data["actions"].map((x) =>
              application
                  .make<WidgetBuilder>(x["type"])
                  .build(Json.fromJson(x), context))),
      elevation: json.data["elevation"]?.toDouble(),
      backgroundColor: json.data["backgroundColor"] == null
          ? null
          : Color.findColor(json.data["backgroundColor"]).build(),
      centerTitle: json.data["centerTitle"] ?? false,
    );
  }
}
