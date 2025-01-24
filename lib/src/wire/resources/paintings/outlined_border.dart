import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/paintings/border_side.dart';
import './border_radius.dart';

abstract class OutlinedBorder {
  material.OutlinedBorder build();
}

class OutlinedBorderFactory {
  static OutlinedBorder findJson(Map<String, dynamic> json) {
    if (json["type"] == "RoundedRectangleBorder") {
      return RoundedRectangleBorder.fromJson(json["data"]);
    } else if (json["type"] == "CircleBorder") {
      return CircleBorder.fromJson(json["data"]);
    } else if (json["type"] == "BeveledRectangleBorder") {
      return BeveledRectangleBorder.fromJson(json["data"]);
    }

    throw Exception("Invalid type");
  }
}

class RoundedRectangleBorder implements OutlinedBorder {
  final AbstractBorderRadiusGeometry borderRadius;

  RoundedRectangleBorder({required this.borderRadius});

  factory RoundedRectangleBorder.fromJson(Map<String, dynamic> json) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.findJson(json["borderRadius"]));
  }

  @override
  material.OutlinedBorder build() {
    return material.RoundedRectangleBorder(
      borderRadius: borderRadius.build(),
    );
  }
}

class CircleBorder implements OutlinedBorder {
  final BorderSide? side;
  final double? eccentricity;

  CircleBorder({this.side, this.eccentricity});

  factory CircleBorder.fromJson(Map<String, dynamic> json) {
    return CircleBorder(
        side: json["side"] == null ? null : BorderSide.fromJson(json["side"]),
        eccentricity: json["eccentricity"]);
  }

  @override
  material.OutlinedBorder build() {
    return material.CircleBorder(
      side: side?.build() ?? material.BorderSide.none,
      eccentricity: eccentricity ?? 0.0,
    );
  }
}

class BeveledRectangleBorder implements OutlinedBorder {
  final BorderSide? side;
  final AbstractBorderRadiusGeometry? borderRadius;

  BeveledRectangleBorder({this.side, this.borderRadius});

  factory BeveledRectangleBorder.fromJson(Map<String, dynamic> json) {
    return BeveledRectangleBorder(
        side: json["side"] == null ? null : BorderSide.fromJson(json["side"]),
        borderRadius: json["borderRadius"] == null ? null : BorderRadiusGeometry
            .findJson(json["borderRadius"]));
  }

  @override
  material.OutlinedBorder build() {
    return material.BeveledRectangleBorder(
      side: side?.build() ?? material.BorderSide.none,
      borderRadius: borderRadius?.build() ?? material.BorderRadius.zero,
    );
  }
}