class NavigationPath {
  String? path;
  String? stackKey;
  int? index;
  Map<String, dynamic>? queryParameters;

  NavigationPath({this.path, this.stackKey, this.index, this.queryParameters});

  factory NavigationPath.fromJson(Map<String, dynamic> json) {
    return NavigationPath(
      path: json['path'],
      stackKey: json['stackKey'],
      index: json['index'],
      queryParameters: json['queryParameters'],
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