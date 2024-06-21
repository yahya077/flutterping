import 'package:flutter/material.dart' as material;

class ChangeNotifierFactory {
  static material.ChangeNotifier create(Map<String, dynamic> json) {
    switch (json["type"]) {
      case "ScrollController":
        return material.ScrollController();
      default:
        throw Exception("Invalid value $json");
    }
  }
}