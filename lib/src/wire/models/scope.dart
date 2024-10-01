class Scope {
  final String id;
  final Map<String, dynamic> context;

  Scope(this.id, {this.context = const {}});

  factory Scope.fromJson(Map<String, dynamic> json) {
    return Scope(json["id"], context: json["context"] ?? {});
  }
}