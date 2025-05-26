import 'package:flutter/material.dart' as material;

class BasicType {
  static find(dynamic json) {
    switch (json["type"]) {
      case "Axis":
        return Axis.fromJson(json["data"]);
      default:
        throw Exception("Invalid type ${json["type"]}");
    }
  }
}

class Axis {
  String value;
  static const horizontal = 'horizontal';
  static const vertical = 'vertical';

  Axis(this.value);

  factory Axis.fromJson(Map<String, dynamic> json) {
    return Axis(json["value"]);
  }

  material.Axis build() {
    switch (value) {
      case horizontal:
        return material.Axis.horizontal;
      case vertical:
        return material.Axis.vertical;
      default:
        throw Exception("Invalid value $value");
    }
  }
}

class VerticalDirection {
  String value;
  static const up = 'up';
  static const down = 'down';

  VerticalDirection(this.value);

  factory VerticalDirection.fromJson(Map<String, dynamic> json) {
    return VerticalDirection(json["value"]);
  }

  material.VerticalDirection build() {
    switch (value) {
      case up:
        return material.VerticalDirection.up;
      case down:
        return material.VerticalDirection.down;
      default:
        throw Exception("Invalid value $value");
    }
  }
}

class ScrollViewKeyboardDismissBehavior {
  String value;
  static const onDrag = 'onDrag';
  static const manual = 'manual';

  ScrollViewKeyboardDismissBehavior(this.value);

  factory ScrollViewKeyboardDismissBehavior.fromJson(
      Map<String, dynamic> json) {
    return ScrollViewKeyboardDismissBehavior(json["value"]);
  }

  material.ScrollViewKeyboardDismissBehavior build() {
    switch (value) {
      case onDrag:
        return material.ScrollViewKeyboardDismissBehavior.onDrag;
      case manual:
        return material.ScrollViewKeyboardDismissBehavior.manual;
      default:
        return material.ScrollViewKeyboardDismissBehavior.manual;
    }
  }
}
