import 'package:flutter/material.dart' as material;
import './border_radius.dart';

abstract class ShapeBorder {
  material.ShapeBorder build();
}

class ShapeBorderFactory {
  static ShapeBorder findElement(Map<String, dynamic> json) {
    if (json["type"] == "RoundedRectangleBorder") {
      return RoundedRectangleBorder.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}

class RoundedRectangleBorder implements ShapeBorder {
  final AbstractBorderRadiusGeometry borderRadius;

  RoundedRectangleBorder({required this.borderRadius});

  factory RoundedRectangleBorder.fromJson(Map<String, dynamic> json) {
    return RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.findElement(json["borderRadius"]));
  }

  @override
  material.ShapeBorder build() {
    return material.RoundedRectangleBorder(
      borderRadius: borderRadius.build(),
    );
  }
}