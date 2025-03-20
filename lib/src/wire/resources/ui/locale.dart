import 'dart:ui' as ui;

class Locale {
  String languageCode;
  String? countryCode;

  Locale(this.languageCode, {this.countryCode});

  factory Locale.fromJson(Map<String, dynamic> json) {
    return Locale(json["languageCode"], countryCode: json["countryCode"]);
  }

  ui.Locale build() {
    return ui.Locale(languageCode, countryCode);
  }
}
