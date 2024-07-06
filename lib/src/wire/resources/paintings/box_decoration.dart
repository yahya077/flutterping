import 'dart:convert';
import 'package:flutter/material.dart' as material;

import '../paintings/decoration.dart';
import 'border.dart';
import 'border_radius.dart';
import 'box_shadow.dart';
import '../ui/color.dart';

class BoxDecoration implements AbstractDecoration {
  AbstractColor? color;
  AbstractBorder? border;
  AbstractBorderRadiusGeometry? borderRadius;
  List<AbstractBoxShadow>? boxShadow;

  BoxDecoration({
    this.color,
    required this.border,
    required this.borderRadius,
    required this.boxShadow,
  });

  factory BoxDecoration.fromRawJson(String str) => BoxDecoration.fromJson(json.decode(str));

  factory BoxDecoration.fromJson(Map<String, dynamic> json) => BoxDecoration(
    color: json["color"] == null ? null : Color.findColor(json["color"]),
    border: json["border"] == null ? null : BoxBorder.findJson(json["border"]),
    borderRadius: json["borderRadius"] == null ? null : BorderRadius.fromJson(json["borderRadius"]),
    boxShadow: json["boxShadow"] == null ? null : List<AbstractBoxShadow>.from(json["boxShadow"].map((x) => BoxShadow.findJson(x))),
  );

  @override
  material.Decoration build() {
    return material.BoxDecoration(
      color: color?.build(),
      border: border?.build(),
      borderRadius: borderRadius?.build(),
      boxShadow: boxShadow?.map((e) => e.build()).toList(),
    );
  }
}