import 'package:flutter/material.dart' as material;

class FontWeight {
  String value;
  static const normal = "normal";
  static const bold = "bold";
  static const w100 = "w100";
  static const w200 = "w200";
  static const w300 = "w300";
  static const w400 = "w400";
  static const w500 = "w500";
  static const w600 = "w600";
  static const w700 = "w700";
  static const w800 = "w800";
  static const w900 = "w900";

  FontWeight(this.value);

  factory FontWeight.fromJson(Map<String, dynamic> json) {
    return FontWeight(json["value"]);
  }

  material.FontWeight build() {
    switch (value) {
      case normal:
        return material.FontWeight.normal;
      case bold:
        return material.FontWeight.bold;
      case w100:
        return material.FontWeight.w100;
      case w200:
        return material.FontWeight.w200;
      case w300:
        return material.FontWeight.w300;
      case w400:
        return material.FontWeight.w400;
      case w500:
        return material.FontWeight.w500;
      case w600:
        return material.FontWeight.w600;
      case w700:
        return material.FontWeight.w700;
      case w800:
        return material.FontWeight.w800;
      case w900:
        return material.FontWeight.w900;
      default:
        throw Exception("Invalid value $value");
    }
  }
}