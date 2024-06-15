import 'dart:convert';

import 'package:flutter/material.dart' as material;
import '../ui/color.dart';

abstract class AbstractTextStyle {
  material.TextStyle build();
}

class TextStyle implements AbstractTextStyle {
  bool inherit;
  AbstractColor? color;

  TextStyle({
    required this.inherit,
    required this.color,
  });

  factory TextStyle.fromRawJson(String str) => TextStyle.fromJson(json.decode(str));

  factory TextStyle.fromJson(Map<String, dynamic> json) => TextStyle(
    inherit: json["inherit"] ?? true,
    color: json["color"] == null ? null : Color.findColor(json["color"]),
  );

  @override
  material.TextStyle build() {
    return material.TextStyle(
      inherit: inherit,
      color: color?.build(),
    );
  }
}