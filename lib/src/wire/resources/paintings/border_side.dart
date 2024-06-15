import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'painting.dart';
import '../ui/color.dart';

abstract class AbstractBorderSide implements Painting {
  material.BorderSide build();
}

class BorderSide implements AbstractBorderSide {
  AbstractColor? color;
  double width;

  BorderSide({
    required this.color,
    required this.width,
  });

  factory BorderSide.fromRawJson(String str) =>
      BorderSide.fromJson(json.decode(str));

  factory BorderSide.fromJson(Map<String, dynamic> json) {
    return BorderSide(
      color: json["color"] == null
          ? Color(alpha: 255, red: 0, green: 0, blue: 0)
          : Color.findColor(json["color"]),
      width:
          json["width"] == null ? 1.0 : double.parse(json["width"].toString()),
    );
  }

  static BorderSide findElement(Map<String, dynamic> json) {
    return BorderSide.fromJson(json["data"]);
  }

  @override
  material.BorderSide build() {
    return material.BorderSide(
      color: color!.build(),
      width: width,
    );
  }
}
