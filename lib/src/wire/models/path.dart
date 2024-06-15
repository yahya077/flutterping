class NavigationPath {
  String? path;
  String? stackKey;
  int? index;

  NavigationPath({this.path, this.stackKey, this.index});

  factory NavigationPath.fromJson(Map<String, dynamic> json) =>
      NavigationPath(
        path: json['path'],
        stackKey: json['stackKey'],
        index: json['index'],
      );
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