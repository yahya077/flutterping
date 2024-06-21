class Double {
  final dynamic value;

  Double(this.value);

  factory Double.fromJson(Map<String, dynamic> json) {
    return Double(json["value"]);
  }

  double build() {
    return value.toDouble();
  }
}

class DoubleFactory {
  static double? fromDynamic(dynamic value) {
    if (value == null) {
      return null;
    }
    switch (value.runtimeType) {
      case int:
        return value.toDouble();
      case double:
        return value;
      case String:
        switch (value) {
          case "nan":
            return double.nan;
          case "infinity":
            return 1.0 / 0.0;
          case "negativeInfinity":
            return -1.0 / 0.0;
          case "minPositive":
            return 5e-324;
          case "maxFinite":
            return 1.7976931348623157e+308;
          default:
            throw Exception("Invalid const value $value");
        }
      default:
        throw Exception("Invalid value $value");
    }
  }
}