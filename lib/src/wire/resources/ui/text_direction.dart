import 'package:flutter/material.dart' as material;

class TextDirection {
  final String value;

  const TextDirection(this.value);

  static const TextDirection ltr = TextDirection("ltr");
  static const TextDirection rtl = TextDirection("rtl");

  static TextDirection fromJson(dynamic json) {
    return TextDirection(json);
  }

  material.TextDirection build() {
    switch (value) {
      case "ltr":
        return material.TextDirection.ltr;
      case "rtl":
        return material.TextDirection.rtl;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
