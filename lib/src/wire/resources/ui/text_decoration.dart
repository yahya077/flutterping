import 'package:flutter/material.dart' as material;

class TextDecoration {
  String value;
  static const none = "none";
  static const underline = "underline";
  static const overline = "overline";
  static const lineThrough = "lineThrough";

  TextDecoration(this.value);

  factory TextDecoration.fromJson(Map<String, dynamic> json) {
    return TextDecoration(json["value"]);
  }

  material.TextDecoration build() {
    switch (value) {
      case none:
        return material.TextDecoration.none;
      case underline:
        return material.TextDecoration.underline;
      case overline:
        return material.TextDecoration.overline;
      case lineThrough:
        return material.TextDecoration.lineThrough;
      default:
        throw Exception("Invalid value $value");
    }
  }
}