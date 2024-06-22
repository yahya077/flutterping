part of 'animation.dart';

class Curves {
  String value;

  static const String linear = "linear";
  static const String decelerate = "decelerate";
  static const String fastOutSlowIn = "fastOutSlowIn";
  static const String easeIn = "easeIn";
  static const String easeOut = "easeOut";
  static const String easeInOut = "easeInOut";
  static const String fastLinearToSlowEaseIn = "fastLinearToSlowEaseIn";
  static const String bounceIn = "bounceIn";
  static const String bounceOut = "bounceOut";
  static const String bounceInOut = "bounceInOut";
  static const String elasticIn = "elasticIn";
  static const String elasticOut = "elasticOut";
  static const String elasticInOut = "elasticInOut";

  Curves(this.value);

  factory Curves.fromJson(Map<String, dynamic> json) {
    return Curves(json["value"]);
  }

  animation.Curve build() {
    switch (value) {
      case linear:
        return animation.Curves.linear;
      case decelerate:
        return animation.Curves.decelerate;
      case fastOutSlowIn:
        return animation.Curves.fastOutSlowIn;
      case easeIn:
        return animation.Curves.easeIn;
      case easeOut:
        return animation.Curves.easeOut;
      case easeInOut:
        return animation.Curves.easeInOut;
      case fastLinearToSlowEaseIn:
        return animation.Curves.fastLinearToSlowEaseIn;
      case bounceIn:
        return animation.Curves.bounceIn;
      case bounceOut:
        return animation.Curves.bounceOut;
      case bounceInOut:
        return animation.Curves.bounceInOut;
      case elasticIn:
        return animation.Curves.elasticIn;
      case elasticOut:
        return animation.Curves.elasticOut;
      case elasticInOut:
        return animation.Curves.elasticInOut;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
