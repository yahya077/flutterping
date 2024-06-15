import 'dart:convert';

import 'package:flutter/material.dart' as material;

import 'edge_insets.dart';

class Margin extends AbstractEdgeInsets  {
  double left;
  double top;
  double right;
  double bottom;

  Margin({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  factory Margin.fromRawJson(String str) => Margin.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Margin.fromJson(Map<String, dynamic> json) => Margin(
    left: json["left"] == null ? 0.0 : double.parse(json["left"].toString()),
    top: json["top"] == null ? 0.0 : double.parse(json["top"].toString()),
    right: json["right"] == null ? 0.0 : double.parse(json["right"].toString()),
    bottom: json["bottom"] == null ? 0.0 : double.parse(json["bottom"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "left": left,
    "top": top,
    "right": right,
    "bottom": bottom,
  };

  @override
  material.EdgeInsets? build() {
    return material.EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}