import 'package:flutter/material.dart' as material;

class TextAlign {
  String value;

  static const left = "left";
  static const right = "right";
  static const center = "center";
  static const justify = "justify";
  static const start = "start";
  static const end = "end";

  TextAlign(this.value);

  factory TextAlign.fromJson(Map<String, dynamic> json) {
    return TextAlign(json["value"]);
  }

  material.TextAlign build() {
    switch (value) {
      case left:
        return material.TextAlign.left;
      case right:
        return material.TextAlign.right;
      case center:
        return material.TextAlign.center;
      case justify:
        return material.TextAlign.justify;
      case start:
        return material.TextAlign.start;
      case end:
        return material.TextAlign.end;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
