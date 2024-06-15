import 'dart:convert';

class RouterConfigData {
  String initialRoutePath;
  List<Map<String, dynamic>> routes;

  RouterConfigData({
    required this.initialRoutePath,
    required this.routes,
  });

  factory RouterConfigData.fromRawJson(String str) => RouterConfigData.fromJson(json.decode(str));

  factory RouterConfigData.fromJson(Map<String, dynamic> json) => RouterConfigData(
    initialRoutePath: json["initialRoutePath"],
    routes: List<Map<String, dynamic>>.from(json["routes"].map((x) => x)),
  );
}