import 'dart:ui' as material;

class Clip {
  String value;
  static const none = 'none';
  static const hardEdge = 'hardEdge';
  static const antiAlias = 'antiAlias';
  static const antiAliasWithSaveLayer = 'antiAliasWithSaveLayer';

  static const values = [
    none,
    hardEdge,
    antiAlias,
    antiAliasWithSaveLayer,
  ];

  Clip(this.value);

  factory Clip.fromJson(Map<String, dynamic> json) {
    return Clip(json["value"]);
  }

  material.Clip build() {
    switch (value) {
      case none:
        return material.Clip.none;
      case hardEdge:
        return material.Clip.hardEdge;
      case antiAlias:
        return material.Clip.antiAlias;
      case antiAliasWithSaveLayer:
        return material.Clip.antiAliasWithSaveLayer;
      default:
        throw Exception("Invalid value $value");
    }
  }
}