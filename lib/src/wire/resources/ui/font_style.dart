import 'package:flutter/material.dart' as material;

class FontStyle {
  String value;
  static const normal = "normal";
  static const italic = "italic";

  FontStyle(this.value);

  factory FontStyle.fromJson(Map<String, dynamic> json) {
    return FontStyle(json["value"]);
  }

  material.FontStyle build() {
    switch (value) {
      case normal:
        return material.FontStyle.normal;
      case italic:
        return material.FontStyle.italic;
      default:
        throw Exception("Invalid value $value");
    }
  }
}