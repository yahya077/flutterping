import 'package:flutter/material.dart' as material;

class KeyboardType {
  String value;

  static const text = "text";
  static const multiline = "multiline";
  static const number = "number";
  static const phone = "phone";
  static const datetime = "datetime";
  static const emailAddress = "emailAddress";
  static const url = "url";
  static const visiblePassword = "visiblePassword";
  static const name = "name";
  static const address = "address";
  static const streetAddress = "streetAddress";
  static const none = "none";

  KeyboardType(this.value);

  factory KeyboardType.fromJson(Map<String, dynamic> json) {
    return KeyboardType(json["value"]);
  }

  material.TextInputType build() {
    switch (value) {
      case text:
        return material.TextInputType.text;
      case multiline:
        return material.TextInputType.multiline;
      case number:
        return material.TextInputType.number;
      case phone:
        return material.TextInputType.phone;
      case datetime:
        return material.TextInputType.datetime;
      case emailAddress:
        return material.TextInputType.emailAddress;
      case url:
        return material.TextInputType.url;
      case visiblePassword:
        return material.TextInputType.visiblePassword;
      case name:
        return material.TextInputType.name;
      case streetAddress:
        return material.TextInputType.streetAddress;
      case none:
        return material.TextInputType.none;
      default:
        throw Exception("Invalid value $value");
    }
  }
}
