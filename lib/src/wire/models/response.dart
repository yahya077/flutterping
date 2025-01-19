import 'dart:convert';

BadRequestResponse badRequestResponseFromJson(String str) => BadRequestResponse.fromJson(json.decode(str));

class BadRequestResponse {
  final bool success;
  final String message;
  final Map<String, List<String>> data;

  BadRequestResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BadRequestResponse.fromJson(Map<String, dynamic> json) {
    return BadRequestResponse(
      success: json['success'],
      message: json['message'],
      data: Map<String, List<String>>.from(json['data'].map((key, value) => MapEntry(key, List<String>.from(value)))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((key, value) => MapEntry(key, value)),
    };
  }
}