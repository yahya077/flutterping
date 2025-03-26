import 'package:flutter/material.dart' as material;

class TileMode {
  final String value;

  const TileMode(this.value);

  factory TileMode.fromJson(Map<String, dynamic> json) {
    return TileMode(json["value"]);
  }

  material.TileMode build() {
    switch (value) {
      case 'clamp':
        return material.TileMode.clamp;
      case 'repeated':
        return material.TileMode.repeated;
      case 'mirror':
        return material.TileMode.mirror;
      case 'decal':
        return material.TileMode.decal;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
