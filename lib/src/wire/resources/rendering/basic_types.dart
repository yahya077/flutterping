import 'package:flutter/material.dart' as material;

class BasicType {
  static find(dynamic json) {
    switch (json["type"]) {
      case "Axis":
        return Axis.fromJson(json["data"]);
      default:
        throw Exception("Invalid type ${json["type"]}");
    }
  }
}

class Axis {
  String value;
  static const horizontal = 'horizontal';
  static const vertical = 'vertical';

  Axis(this.value);

  factory Axis.fromJson(Map<String, dynamic> json) {
    return Axis(json["value"]);
  }

  material.Axis build() {
    switch (value) {
      case horizontal:
        return material.Axis.horizontal;
      case vertical:
        return material.Axis.vertical;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
