import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/paintings/border_radius.dart';

import '../core/double.dart';
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
        right:
            json["right"] == null ? null : BorderSide.findJson(json["right"]),
        bottom:
            json["bottom"] == null ? null : BorderSide.findJson(json["bottom"]),
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

abstract class InputBorder {
  material.InputBorder build();
}

class OutlineInputBorder extends InputBorder {
  BorderSide? borderSide;
  AbstractBorderRadiusGeometry? borderRadius;
  Double? gapPadding;

  OutlineInputBorder({
    this.borderSide,
    this.borderRadius,
    this.gapPadding,
  });

  factory OutlineInputBorder.fromRawJson(String str) =>
      OutlineInputBorder.fromJson(json.decode(str));

  factory OutlineInputBorder.fromJson(Map<String, dynamic> json) =>
      OutlineInputBorder(
        borderSide: json["borderSide"] == null
            ? null
            : BorderSide.findJson(json["borderSide"]),
        borderRadius: json["borderRadius"] == null
            ? null
            : BorderRadiusGeometry.findJson(json["borderRadius"]),
        gapPadding: json["gapPadding"] == null
            ? Double(0)
            : Double.fromJson(json["gapPadding"]),
      );

  @override
  material.InputBorder build() {
    return material.OutlineInputBorder(
      borderSide: borderSide?.build() ?? material.BorderSide.none,
      borderRadius: borderRadius?.build() ?? material.BorderRadius.zero,
      gapPadding: gapPadding!.build(),
    );
  }
}
