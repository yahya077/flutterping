import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/ui/border_style.dart';
import 'painting.dart';
import '../ui/color.dart';

abstract class AbstractBorderSide implements Painting {
  material.BorderSide build();
}

class BorderSide implements AbstractBorderSide {
  AbstractColor? color;
  double width;
  BorderStyle? style;

  BorderSide({
    required this.color,
    required this.width,
    this.style,
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
      style: json["style"] == null ? null : BorderStyle.fromJson(json["style"]),
    );
  }

  static BorderSide findJson(Map<String, dynamic> json) {
    return BorderSide.fromJson(json["data"]);
  }

  @override
  material.BorderSide build() {
    return material.BorderSide(
      color: color!.build(),
      width: width,
      style: style == null ? material.BorderStyle.solid : style!.build(),
    );
  }
}
