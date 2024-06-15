import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' as material;

import '../ui/color.dart';

abstract class AbstractShadow {
  ui.Shadow build();
}

abstract class AbstractBoxShadow implements AbstractShadow {
  @override
  material.BoxShadow build();
}

class BoxShadow implements AbstractBoxShadow {
  AbstractColor? color;

  BoxShadow({
    this.color,
  });

  factory BoxShadow.fromRawJson(String str) => BoxShadow.fromJson(json.decode(str));

  factory BoxShadow.fromJson(Map<String, dynamic> json) => BoxShadow(
    color: json["color"] == null ? null : Color.findColor(json["color"]),
  );

  static AbstractBoxShadow findElement(dynamic json) {
    if (json["type"] == "BoxShadow") {
      return BoxShadow.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }

  @override
  material.BoxShadow build() {
    return material.BoxShadow(
      color: color?.build() ?? material.Colors.black,
    );
  }
}
