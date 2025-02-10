import 'package:flutter/material.dart' as material;

class TextInputAction {
  String value;

  static const done = "done";
  static const next = "next";
  static const go = "go";
  static const search = "search";
  static const send = "send";
  static const none = "none";
  static const unspecified = "unspecified";
  static const previous = "previous";
  static const continueAction = "continueAction";
  static const join = "join";
  static const route = "route";
  static const emergencyCall = "emergencyCall";
  static const newline = "newline";

  TextInputAction(this.value);

  factory TextInputAction.fromJson(Map<String, dynamic> json) {
    return TextInputAction(json["value"]);
  }

  material.TextInputAction build() {
    switch (value) {
      case done:
        return material.TextInputAction.done;
      case next:
        return material.TextInputAction.next;
      case go:
        return material.TextInputAction.go;
      case search:
        return material.TextInputAction.search;
      case send:
        return material.TextInputAction.send;
      case none:
        return material.TextInputAction.none;
      case unspecified:
        return material.TextInputAction.unspecified;
      case previous:
        return material.TextInputAction.previous;
      case continueAction:
        return material.TextInputAction.continueAction;
      case join:
        return material.TextInputAction.join;
      case route:
        return material.TextInputAction.route;
      case emergencyCall:
        return material.TextInputAction.emergencyCall;
      case newline:
        return material.TextInputAction.newline;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
