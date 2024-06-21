import 'dart:convert';

import 'package:flutter/material.dart' as material;

abstract class AbstractBorderRadiusGeometry {
  material.BorderRadiusGeometry build();
}

class BorderRadiusGeometry {
  static AbstractBorderRadiusGeometry findElement(dynamic json) {
    if (json["type"] == "BorderRadius") {
      return BorderRadius.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}

class BorderRadius implements AbstractBorderRadiusGeometry {
  double? topLeft;
  double? topRight;
  double? bottomRight;
  double? bottomLeft;

  BorderRadius({
    this.topLeft,
    this.topRight,
    this.bottomRight,
    this.bottomLeft,
  });

  factory BorderRadius.fromRawJson(String str) => BorderRadius.fromJson(json.decode(str));

  factory BorderRadius.fromJson(Map<String, dynamic> json) {
    return BorderRadius(
      topLeft: json["data"]["topLeft"]?.toDouble(),
      topRight: json["data"]["topRight"]?.toDouble(),
      bottomRight: json["data"]["bottomRight"]?.toDouble(),
      bottomLeft: json["data"]["bottomLeft"]?.toDouble(),
    );
  }

  @override
  material.BorderRadiusGeometry build() {
    return material.BorderRadius.only(
      topLeft: topLeft == null ? material.Radius.zero : material.Radius.circular(topLeft!),
      topRight: topRight == null ? material.Radius.zero : material.Radius.circular(topRight!),
      bottomRight: bottomRight == null ? material.Radius.zero : material.Radius.circular(bottomRight!),
      bottomLeft: bottomLeft == null ? material.Radius.zero : material.Radius.circular(bottomLeft!),
    );
  }
}
