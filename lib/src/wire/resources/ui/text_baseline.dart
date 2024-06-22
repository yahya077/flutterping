import 'package:flutter/material.dart' as material;

class TextBaseline {
  String value;
  static const alphabetic = "alphabetic";
  static const ideographic = "ideographic";

  TextBaseline(this.value);

  factory TextBaseline.fromJson(Map<String, dynamic> json) {
    return TextBaseline(json["value"]);
  }

  material.TextBaseline build() {
    switch (value) {
      case alphabetic:
        return material.TextBaseline.alphabetic;
      case ideographic:
        return material.TextBaseline.ideographic;
      default:
        throw Exception("Invalid value $value");
    }
  }
}