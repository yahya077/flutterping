import 'package:flutter/material.dart' as material;

class BorderStyle {
  String value;
  static const none = "none";
  static const solid = "solid";

  BorderStyle(this.value);

  factory BorderStyle.fromJson(Map<String, dynamic> json) {
    return BorderStyle(json["value"]);
  }

  material.BorderStyle build() {
    switch (value) {
      case none:
        return material.BorderStyle.none;
      case solid:
        return material.BorderStyle.solid;
      default:
        throw Exception("Invalid value $value");
    }
  }
}