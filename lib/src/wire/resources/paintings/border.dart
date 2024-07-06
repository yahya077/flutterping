import 'dart:convert';

import 'package:flutter/material.dart' as material;

import 'painting.dart';
import 'border_side.dart';

abstract class AbstractBorder implements Painting {
  material.Border? build();
}

class BoxBorder {
  static AbstractBorder findJson(dynamic json) {
    if (json["type"] == "Border") {
      return Border.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}

class Border extends AbstractBorder {
  BorderSide? top;
  BorderSide? right;
  BorderSide? bottom;
  BorderSide? left;

  Border({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  factory Border.fromRawJson(String str) => Border.fromJson(json.decode(str));

  factory Border.fromJson(Map<String, dynamic> json) => Border(
    top: json["top"] == null ? null : BorderSide.findJson(json["top"]),
    right: json["right"] == null ? null : BorderSide.findJson(json["right"]),
    bottom: json["bottom"] == null ? null : BorderSide.findJson(json["bottom"]),
    left: json["left"] == null ? null : BorderSide.findJson(json["left"]),
  );

  @override
  material.Border? build() {
    return material.Border(
      top: top?.build() ?? material.BorderSide.none,
      right: right?.build() ?? material.BorderSide.none,
      bottom: bottom?.build() ?? material.BorderSide.none,
      left: left?.build() ?? material.BorderSide.none,
    );
  }
}