import 'dart:convert';

import 'package:flutter/material.dart' as material;

abstract class AbstractColor {
  material.Color build();
}

class Color implements AbstractColor {
  int red;
  int green;
  int blue;
  int alpha;

  Color({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  factory Color.fromRawJson(String str) => Color.fromJson(json.decode(str));

  factory Color.fromJson(Map<String, dynamic> json) => Color(
    red: json["red"] ?? 255,
    green: json["green"] ?? 255,
    blue: json["blue"] ?? 255,
    alpha: json["alpha"] ?? 255,
  );

  static AbstractColor findColor(dynamic json) {
    if (json["type"] == "Color") {
      return Color.fromJson(json["data"]);
    }
    throw Exception("Invalid type");
  }

  @override
  material.Color build() {
    return material.Color.fromARGB(alpha, red, green, blue);
  }
}