class Scope {
  final String id;

  Scope(this.id);

  factory Scope.fromJson(Map<String, dynamic> json) {
    return Scope(json["id"]);
  }
}