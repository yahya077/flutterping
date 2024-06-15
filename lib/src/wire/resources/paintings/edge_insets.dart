import 'package:flutter/material.dart' as material;

import 'margin.dart';
import 'padding.dart';

abstract class AbstractEdgeInsets {
  material.EdgeInsets? build();
}

class EdgeInsets {
  static findElement(dynamic json) {
    switch (json["type"]) {
      case "EdgeInsetsPadding":
        return Padding.fromJson(json["data"]);
      case "EdgeInsetsMargin":
        return Margin.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}