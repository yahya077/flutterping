import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:shimmer/shimmer.dart' as shimmer; //TODO import shimmer package

class ShimmerAnimationProvider extends Provider {
  ShimmerAnimationProvider();

  @override
  void register(Application app) {
    app.singleton("ShimmerAnimation", () => ShimmerAnimationBuilder(app));
  }
}

class ShimmerAnimationBuilder extends WidgetBuilder {
  ShimmerAnimationBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    print(json.data["gradient"]);
    return shimmer.Shimmer(
      gradient: Gradient.fromJson(json.data["gradient"]).build(),
      child: application
          .make<WidgetBuilder>(json.data["child"]["type"])
          .build(Json.fromJson(json.data["child"]), context),
      direction: json.data["direction"] != null ? ShimmerDirection.fromJson(json.data["direction"]).build() : shimmer.ShimmerDirection.ltr,
      period: json.data["duration"] != null ? CoreDuration.fromJson(json.data["duration"]).build() : const Duration(milliseconds: 1500),
      loop: json.data["loop"] ?? 0,
      enabled: json.data["enabled"] ?? true,
    );
  }
}

class ShimmerDirection {
  final String value;

  const ShimmerDirection(this.value);

  factory ShimmerDirection.fromJson(Map<String, dynamic> json) {
    return ShimmerDirection(json["value"]);
  }

  shimmer.ShimmerDirection build() {
    switch (value) {
      case 'ltr':
        return shimmer.ShimmerDirection.ltr;
      case 'rtl':
        return shimmer.ShimmerDirection.rtl;
      case 'ttb':
        return shimmer.ShimmerDirection.ttb;
      case 'btt':
        return shimmer.ShimmerDirection.btt;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
