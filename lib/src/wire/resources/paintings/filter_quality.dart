import 'package:flutter/material.dart' as material;

class FilterQuality {
  final String value;

  const FilterQuality(this.value);

  factory FilterQuality.fromJson(Map<String, dynamic> json) {
    return FilterQuality(json["value"]);
  }

  material.FilterQuality build() {
    switch (value) {
      case 'none':
        return material.FilterQuality.none;
      case 'low':
        return material.FilterQuality.low;
      case 'medium':
        return material.FilterQuality.medium;
      case 'high':
        return material.FilterQuality.high;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
