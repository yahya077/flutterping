import 'package:flutter/material.dart' as material;

class Flex {
  static findFlex(dynamic json) {
    switch (json["type"]) {
      case "CrossAxisAlignment":
        return CrossAxisAlignment.fromJson(json["data"]);
      case "MainAxisAlignment":
        return MainAxisAlignment.fromJson(json["data"]);
      default:
        throw Exception("Invalid type ${json["type"]}");
    }
  }
}

class MainAxisAlignment {
  String value;
  static const start = 'start';
  static const end = 'end';
  static const center = 'center';
  static const spaceBetween = 'spaceBetween';
  static const spaceAround = 'spaceAround';
  static const spaceEvenly = 'spaceEvenly';

  MainAxisAlignment(this.value);

  factory MainAxisAlignment.fromJson(Map<String, dynamic> json) {
    return MainAxisAlignment(json["value"]);
  }

  material.MainAxisAlignment build() {
    switch (value) {
      case start:
        return material.MainAxisAlignment.start;
      case end:
        return material.MainAxisAlignment.end;
      case center:
        return material.MainAxisAlignment.center;
      case spaceBetween:
        return material.MainAxisAlignment.spaceBetween;
      case spaceAround:
        return material.MainAxisAlignment.spaceAround;
      case spaceEvenly:
        return material.MainAxisAlignment.spaceEvenly;
      default:
        throw Exception("Invalid value $value");
    }
  }
}

class CrossAxisAlignment {
  String value;
  static const start = 'start';
  static const end = 'end';
  static const center = 'center';
  static const stretch = 'stretch';
  static const baseline = 'baseline';

  static const values = [
    start,
    end,
    center,
    stretch,
    baseline,
  ];

  CrossAxisAlignment(this.value);

  factory CrossAxisAlignment.fromJson(Map<String, dynamic> json) {
    return CrossAxisAlignment(json["value"]);
  }

  material.CrossAxisAlignment build() {
    switch (value) {
      case start:
        return material.CrossAxisAlignment.start;
      case end:
        return material.CrossAxisAlignment.end;
      case center:
        return material.CrossAxisAlignment.center;
      case stretch:
        return material.CrossAxisAlignment.stretch;
      case baseline:
        return material.CrossAxisAlignment.baseline;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
