import 'dart:convert';

import 'package:flutter/material.dart' as material;
import '../ui/color.dart';
import '../ui/text_decoration.dart';
import '../ui/font_weight.dart';
import '../ui/font_style.dart';
import '../ui/text_baseline.dart';
import '../ui/text_decoration_style.dart';

abstract class AbstractTextStyle {
  material.TextStyle build();
}

class TextStyle implements AbstractTextStyle {
  bool? inherit;
  AbstractColor? color;
  AbstractColor? backgroundColor;
  double? fontSize;
  FontWeight? fontWeight;
  FontStyle? fontStyle;
  double? letterSpacing;
  double? wordSpacing;
  TextBaseline? textBaseline;
  AbstractColor? decorationColor;
  TextDecorationStyle? decorationStyle;
  double? decorationThickness;
  TextDecoration? decoration;
  String? fontFamily;
  List<String>? fontFamilyFallback;
  String? package;

  TextStyle({
    required this.inherit,
    required this.color,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontWeight,
    required this.fontStyle,
    required this.letterSpacing,
    required this.wordSpacing,
    required this.textBaseline,
    required this.decorationColor,
    required this.decorationStyle,
    required this.decorationThickness,
    required this.decoration,
    required this.fontFamily,
    required this.fontFamilyFallback,
    required this.package,
  });

  factory TextStyle.fromRawJson(String str) =>
      TextStyle.fromJson(json.decode(str));

  factory TextStyle.fromJson(Map<String, dynamic> json) => TextStyle(
        inherit: json["inherit"] ?? true,
        color: json["color"] == null ? null : Color.findColor(json["color"]),
        backgroundColor: json["backgroundColor"] == null
            ? null
            : Color.findColor(json["backgroundColor"]),
        fontSize: json["fontSize"]?.toDouble(),
        fontWeight: json["fontWeight"] == null
            ? null
            : FontWeight.fromJson(json["fontWeight"]),
        fontStyle: json["fontStyle"] == null
            ? null
            : FontStyle.fromJson(json["fontStyle"]),
        letterSpacing: json["letterSpacing"]?.toDouble(),
        wordSpacing: json["wordSpacing"]?.toDouble(),
        textBaseline: json["textBaseline"] == null
            ? null
            : TextBaseline.fromJson(json["textBaseline"]),
        decorationColor: json["decorationColor"] == null
            ? null
            : Color.findColor(json["decorationColor"]),
        decorationStyle: json["decorationStyle"] == null
            ? null
            : TextDecorationStyle.fromJson(json["decorationStyle"]),
        decorationThickness: json["decorationThickness"]?.toDouble(),
        decoration: json["decoration"] == null
            ? null
            : TextDecoration.fromJson(json["decoration"]),
        fontFamily: json["fontFamily"],
        fontFamilyFallback: json["fontFamilyFallback"] == null
            ? null
            : List<String>.from(json["fontFamilyFallback"].map((x) => x)),
        package: json["package"],
      );

  @override
  material.TextStyle build() {
    return material.TextStyle(
      inherit: inherit ?? false,
      color: color?.build(),
      decoration: decoration?.build(),
      decorationColor: decorationColor?.build(),
      decorationStyle: decorationStyle?.build(),
      decorationThickness: decorationThickness,
      backgroundColor: backgroundColor?.build(),
      fontSize: fontSize,
      fontWeight: fontWeight?.build(),
      fontStyle: fontStyle?.build(),
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      textBaseline: textBaseline?.build(),
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      package: package,
    );
  }
}
