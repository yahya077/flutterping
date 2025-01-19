import 'package:flutter/material.dart' as material;

import '../../../flutter_ping_wire.dart';

class InputDecorationBuilder extends JsonBuilder<material.InputDecoration> {
  InputDecorationBuilder(Application application) : super(application);

  @override
  material.InputDecoration build(Json json, material.BuildContext? context) {
    return material.InputDecoration(
      icon: json.data["icon"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["icon"]["type"])
              .build(Json.fromJson(json.data["icon"]), context),
      iconColor: json.data["color"] == null
          ? null
          : Color.fromJson(json.data["color"]).build(),
      label: json.data["label"] == null
          ? null
          : application
              .make<WidgetBuilder>(json.data["label"]["type"])
              .build(Json.fromJson(json.data["label"]), context),
      labelText: json.data["labelText"] == null
          ? null
          : json.data["labelText"].toString(),
      labelStyle: json.data["labelStyle"] == null ? null : TextStyle.fromJson(json.data["labelStyle"]).build(),
      helper: json.data["helper"] == null
          ? null
          : application
          .make<WidgetBuilder>(json.data["helper"]["type"])
          .build(Json.fromJson(json.data["helper"]), context),
      helperStyle: json.data["helperStyle"] == null ? null : TextStyle.fromJson(json.data["helperStyle"]).build(),
      helperText: json.data["helperText"],
      hintText: json.data["hintText"],
      hintStyle: json.data["hintStyle"] == null ? null : TextStyle.fromJson(json.data["hintStyle"]).build(),
      hintMaxLines: json.data["hintMaxLines"],
      error: json.data["error"] == null
          ? null
          : application
          .make<WidgetBuilder>(json.data["error"]["type"])
          .build(Json.fromJson(json.data["error"]), context),
      fillColor: json.data["fillColor"] == null
          ? null
          : Color.fromJson(json.data["fillColor"]).build(),
      filled: json.data["filled"],
      border: json.data["border"] == null
          ? null : OutlineInputBorder.fromJson(json.data["border"]["data"]).build(),
      enabledBorder:  json.data["enabledBorder"] == null
          ? null : OutlineInputBorder.fromJson(json.data["enabledBorder"]["data"]).build(),
      focusedBorder:  json.data["focusedBorder"] == null
          ? null : OutlineInputBorder.fromJson(json.data["focusedBorder"]["data"]).build(),
    );
  }
}
