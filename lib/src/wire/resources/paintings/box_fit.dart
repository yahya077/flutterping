import 'package:flutter/material.dart' as material;

class BoxFit {
  final String value;

  const BoxFit(this.value);

  factory BoxFit.fromJson(Map<String, dynamic> json) {
    return BoxFit(json["value"]);
  }

  material.BoxFit build() {
    switch (value) {
      case 'fill':
        return material.BoxFit.fill;
      case 'contain':
        return material.BoxFit.contain;
      case 'cover':
        return material.BoxFit.cover;
      case 'fitWidth':
        return material.BoxFit.fitWidth;
      case 'fitHeight':
        return material.BoxFit.fitHeight;
      case 'none':
        return material.BoxFit.none;
      case 'scaleDown':
        return material.BoxFit.scaleDown;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
