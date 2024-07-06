import 'dart:convert';

class Json {
  final String type;
  final Map<String, dynamic> data;

  Json(this.type, this.data);

  factory Json.fromJson(Map<String, dynamic> json) {
    return Json(
      json["type"],
      json["data"],
    );
  }

  factory Json.fromRawJson(String rawJson) {
    return Json.fromJson(json.decode(rawJson));
  }
}
