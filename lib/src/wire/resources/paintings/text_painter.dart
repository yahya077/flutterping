import 'package:flutter/material.dart' as material;

class TextOverflow {
  String value;

  static const clip = "clip";
  static const ellipsis = "ellipsis";
  static const fade = "fade";

  TextOverflow(this.value);

  factory TextOverflow.fromJson(Map<String, dynamic> json) {
    return TextOverflow(json["value"]);
  }

  material.TextOverflow build() {
    switch (value) {
      case clip:
        return material.TextOverflow.clip;
      case ellipsis:
        return material.TextOverflow.ellipsis;
      case fade:
        return material.TextOverflow.fade;
      default:
        throw Exception("Invalid value $value");
    }
  }
}

class TextWidthBasis {
  String value;

  static const parent = "parent";
  static const longestLine = "longestLine";

  TextWidthBasis(this.value);

  factory TextWidthBasis.fromJson(Map<String, dynamic> json) {
    return TextWidthBasis(json["value"]);
  }

  material.TextWidthBasis build() {
    switch (value) {
      case parent:
        return material.TextWidthBasis.parent;
      case longestLine:
        return material.TextWidthBasis.longestLine;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
