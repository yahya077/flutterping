import 'package:flutter/material.dart' as material;

class TextDecorationStyle {
  String value;
  static const solid = "solid";
  static const double = "double";
  static const dotted = "dotted";
  static const dashed = "dashed";
  static const wavy = "wavy";

  TextDecorationStyle(this.value);

  factory TextDecorationStyle.fromJson(Map<String, dynamic> json) {
    return TextDecorationStyle(json["value"]);
  }

  material.TextDecorationStyle build() {
    switch (value) {
      case solid:
        return material.TextDecorationStyle.solid;
      case double:
        return material.TextDecorationStyle.double;
      case dotted:
        return material.TextDecorationStyle.dotted;
      case dashed:
        return material.TextDecorationStyle.dashed;
      case wavy:
        return material.TextDecorationStyle.wavy;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
