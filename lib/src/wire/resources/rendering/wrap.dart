import 'package:flutter/material.dart' as material;

class WrapAlignment {
  String value;
  static const start = 'start';
  static const end = 'end';
  static const center = 'center';
  static const spaceBetween = 'spaceBetween';
  static const spaceAround = 'spaceAround';
  static const spaceEvenly = 'spaceEvenly';

  WrapAlignment(this.value);

  factory WrapAlignment.fromJson(Map<String, dynamic> json) {
    return WrapAlignment(json["value"]);
  }

  material.WrapAlignment build() {
    switch (value) {
      case start:
        return material.WrapAlignment.start;
      case end:
        return material.WrapAlignment.end;
      case center:
        return material.WrapAlignment.center;
      case spaceBetween:
        return material.WrapAlignment.spaceBetween;
      case spaceAround:
        return material.WrapAlignment.spaceAround;
      case spaceEvenly:
        return material.WrapAlignment.spaceEvenly;
      default:
        throw Exception("Invalid value $value");
    }
  }
}

class WrapCrossAlignment {
  String value;
  static const start = 'start';
  static const end = 'end';
  static const center = 'center';

  static const values = [
    start,
    end,
    center,
  ];

  WrapCrossAlignment(this.value);

  factory WrapCrossAlignment.fromJson(Map<String, dynamic> json) {
    return WrapCrossAlignment(json["value"]);
  }

  material.WrapCrossAlignment build() {
    switch (value) {
      case start:
        return material.WrapCrossAlignment.start;
      case end:
        return material.WrapCrossAlignment.end;
      case center:
        return material.WrapCrossAlignment.center;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
