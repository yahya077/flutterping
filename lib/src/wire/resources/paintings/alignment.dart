import 'package:flutter/material.dart' as material;

class Alignment {
  final String value;

  const Alignment(this.value);

  factory Alignment.fromJson(Map<String, dynamic> json) {
    return Alignment(json["value"]);
  }

  material.Alignment build() {
    switch (value) {
      case 'topLeft':
        return material.Alignment.topLeft;
      case 'topCenter':
        return material.Alignment.topCenter;
      case 'topRight':
        return material.Alignment.topRight;
      case 'centerLeft':
        return material.Alignment.centerLeft;
      case 'center':
        return material.Alignment.center;
      case 'centerRight':
        return material.Alignment.centerRight;
      case 'bottomLeft':
        return material.Alignment.bottomLeft;
      case 'bottomCenter':
        return material.Alignment.bottomCenter;
      case 'bottomRight':
        return material.Alignment.bottomRight;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
