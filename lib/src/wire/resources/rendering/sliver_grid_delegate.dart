import 'dart:convert';

import 'package:flutter/material.dart' as material;

abstract class SliverGridDelegate {
  material.SliverGridDelegate build();
}

class SliverGridDelegateFactory {
  static SliverGridDelegate findElement(dynamic json) {
    if (json["type"] == "SliverGridDelegateWithFixedCrossAxisCount") {
      return SliverGridDelegateWithFixedCrossAxisCount.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}

class SliverGridDelegateWithFixedCrossAxisCount extends SliverGridDelegate {
  int crossAxisCount;
  double mainAxisSpacing;
  double crossAxisSpacing;
  double childAspectRatio;

  SliverGridDelegateWithFixedCrossAxisCount({
    required this.crossAxisCount,
    required this.mainAxisSpacing,
    required this.crossAxisSpacing,
    required this.childAspectRatio,
  });

  factory SliverGridDelegateWithFixedCrossAxisCount.fromRawJson(String str) => SliverGridDelegateWithFixedCrossAxisCount.fromJson(json.decode(str));

  factory SliverGridDelegateWithFixedCrossAxisCount.fromJson(Map<String, dynamic> json) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: json["crossAxisCount"],
      mainAxisSpacing: json["mainAxisSpacing"]?.toDouble() ?? 0.0,
      crossAxisSpacing: json["crossAxisSpacing"]?.toDouble() ?? 0.0,
      childAspectRatio: json["childAspectRatio"]?.toDouble() ?? 1.0,
    );
  }

  material.SliverGridDelegateWithFixedCrossAxisCount build() {
    return material.SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}