class NavigationPath {
  String? navigatorKey;
  String? path;
  String? stackKey;
  int? index;
  Map<String, dynamic>? queryParameters;
  Map<String, String>? pathParameters;
  String? navigationType;

  NavigationPath({this.navigatorKey, this.path, this.stackKey, this.index, this.queryParameters, this.pathParameters, this.navigationType});

  factory NavigationPath.fromJson(Map<String, dynamic> json) {
    return NavigationPath(
      navigatorKey: json['navigatorKey'],
      path: json['path'],
      stackKey: json['stackKey'],
      index: json['index'],
      queryParameters: json['queryParameters'],
      navigationType: json['navigationType'],
      pathParameters: json['pathParameters']?.map((key, value) => MapEntry(key, value.toString()))
          .cast<String, String>(),
    );
  }
}

class ApiPath {
  String path;
  String? baseUrl;

  ApiPath(this.path, {this.baseUrl});

  factory ApiPath.fromJson(Map<String, dynamic> json) =>
      ApiPath(
        json['path'],
        baseUrl: json['baseUrl'],
      );
}