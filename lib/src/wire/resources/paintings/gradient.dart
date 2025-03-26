import 'dart:convert';

import 'package:flutter/material.dart' as material;

import '../core/double.dart';
import '../ui/color.dart';
import './alignment.dart';
import './tile_mode.dart';

class Gradient {
  static fromJson(dynamic json) {
    if (json["type"] == "LinearGradient") {
      return LinearGradient.fromJson(json);
    } else if (json["type"] == "RadialGradient") {
      return RadialGradient.fromJson(json);
    } else if (json["type"] == "SweepGradient") {
      return SweepGradient.fromJson(json);
    }

    throw Exception("Invalid type");
  }
}

class LinearGradient {
  Alignment? begin;
  Alignment? end;
  List<AbstractColor> colors;
  List<double>? stops;
  TileMode? tileMode;
  //GradientTransform? transform; TODO implement GradientTransform
  LinearGradient({
    this.begin,
    this.end,
    required this.colors,
    this.stops,
    this.tileMode,
  });

  factory LinearGradient.fromRawJson(String str) => LinearGradient.fromJson(json.decode(str));

  factory LinearGradient.fromJson(Map<String, dynamic> json) => LinearGradient(
    begin: json["begin"] == null ? null : Alignment.fromJson(json["begin"]),
    end: json["end"] == null ? null : Alignment.fromJson(json["end"]),
    colors: List<AbstractColor>.from(json["colors"].map((x) => Color.fromJson(x))),
    stops: json["stops"] == null ? null : List.from(json["stops"].map((x) => DoubleFactory.fromDynamic(x))),
    tileMode: json["tileMode"] == null ? null : TileMode.fromJson(json["tileMode"]),
  );

  material.Gradient build() {
    return material.LinearGradient(
      begin: begin?.build() ?? material.Alignment.centerLeft,
      end: end?.build() ?? material.Alignment.centerRight,
      colors: colors.map((e) => e.build()).toList(),
      stops: stops,
      tileMode: tileMode?.build() ?? material.TileMode.clamp,
      transform: null,
    );
  }
}

class RadialGradient {
  Alignment? center;
  double radius;
  List<AbstractColor> colors;
  List<double>? stops;
  TileMode? tileMode;
  //GradientTransform? transform; TODO implement GradientTransform
  RadialGradient({
    this.center,
    required this.radius,
    required this.colors,
    this.stops,
    this.tileMode,
  });

  factory RadialGradient.fromRawJson(String str) => RadialGradient.fromJson(json.decode(str));

  factory RadialGradient.fromJson(Map<String, dynamic> json) => RadialGradient(
    center: json["center"] == null ? null : Alignment.fromJson(json["center"]),
    radius: json["radius"].toDouble(),
    colors: List<AbstractColor>.from(json["colors"].map((x) => Color.fromJson(x))),
    stops: json["stops"] == null ? null : List.from(json["stops"].map((x) => DoubleFactory.fromDynamic(x))),
    tileMode: json["tileMode"] == null ? null : TileMode.fromJson(json["tileMode"]),
  );

  material.Gradient build() {
    return material.RadialGradient(
      center: center?.build() ?? material.Alignment.center,
      radius: radius,
      colors: colors.map((e) => e.build()).toList(),
      stops: stops,
      tileMode: tileMode?.build() ?? material.TileMode.clamp,
      transform: null,
    );
  }
}

class SweepGradient {
  Alignment? center;
  double startAngle;
  double endAngle;
  List<AbstractColor> colors;
  List<double>? stops;
  TileMode? tileMode;
  //GradientTransform? transform; TODO implement GradientTransform
  SweepGradient({
    this.center,
    required this.startAngle,
    required this.endAngle,
    required this.colors,
    this.stops,
    this.tileMode,
  });

  factory SweepGradient.fromRawJson(String str) => SweepGradient.fromJson(json.decode(str));

  factory SweepGradient.fromJson(Map<String, dynamic> json) => SweepGradient(
    center: json["center"] == null ? null : Alignment.fromJson(json["center"]),
    startAngle: json["startAngle"].toDouble(),
    endAngle: json["endAngle"].toDouble(),
    colors: List<AbstractColor>.from(json["colors"].map((x) => Color.fromJson(x))),
    stops: json["stops"] == null ? null : List.from(json["stops"].map((x) => DoubleFactory.fromDynamic(x))),
    tileMode: json["tileMode"] == null ? null : TileMode.fromJson(json["tileMode"]),
  );

  material.Gradient build() {
    return material.SweepGradient(
      center: center?.build() ?? material.Alignment.center,
      startAngle: startAngle,
      endAngle: endAngle,
      colors: colors.map((e) => e.build()).toList(),
      stops: stops,
      tileMode: tileMode?.build() ?? material.TileMode.clamp,
      transform: null,
    );
  }
}