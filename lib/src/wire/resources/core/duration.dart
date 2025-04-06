class CoreDuration {
  final int milliseconds;

  const CoreDuration({this.milliseconds = 0});

  factory CoreDuration.fromJson(Map<String, dynamic> json) {
    return CoreDuration(milliseconds: json["milliseconds"]);
  }

  Duration build() {
    return Duration(milliseconds: milliseconds);
  }
}
