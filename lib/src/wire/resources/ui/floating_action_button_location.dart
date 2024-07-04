import 'package:flutter/material.dart' as material;

class FloatingActionButtonLocation {
  String value;
  static const centerDocked = "centerDocked";
  static const centerFloat = "centerFloat";
  static const endDocked = "endDocked";
  static const endFloat = "endFloat";
  static const miniStartTop = "miniStartTop";
  static const miniCenterTop = "miniCenterTop";
  static const miniEndTop = "miniEndTop";
  static const startTop = "startTop";
  static const centerTop = "centerTop";
  static const endTop = "endTop";

  factory FloatingActionButtonLocation.fromJson(Map<String, dynamic> json) {
    return FloatingActionButtonLocation(json["value"]);
  }

  FloatingActionButtonLocation(this.value);

  material.FloatingActionButtonLocation build() {
    switch (value) {
      case centerDocked:
        return material.FloatingActionButtonLocation.centerDocked;
      case centerFloat:
        return material.FloatingActionButtonLocation.centerFloat;
      case endDocked:
        return material.FloatingActionButtonLocation.endDocked;
      case endFloat:
        return material.FloatingActionButtonLocation.endFloat;
      case miniStartTop:
        return material.FloatingActionButtonLocation.miniStartTop;
      case miniCenterTop:
        return material.FloatingActionButtonLocation.miniCenterTop;
      case miniEndTop:
        return material.FloatingActionButtonLocation.miniEndTop;
      case startTop:
        return material.FloatingActionButtonLocation.startTop;
      case centerTop:
        return material.FloatingActionButtonLocation.centerTop;
      case endTop:
        return material.FloatingActionButtonLocation.endTop;
      default:
        return material.FloatingActionButtonLocation.centerDocked;
    }
  }
}
