import 'dart:convert';

class Element {
  final String type;
  final Map<String, dynamic> data;

  Element(this.type, this.data);

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
      json["type"],
      json["data"],
    );
  }

  factory Element.fromRawJson(String rawJson) {
    return Element.fromJson(json.decode(rawJson));
  }
}
