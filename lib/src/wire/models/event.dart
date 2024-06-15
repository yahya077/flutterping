import 'dart:convert';

abstract class AbstractEvent {
  setStateId(String stateId);

  setName(String eventName);

  setPayload(dynamic payload);
}

class EventPayload {
  dynamic payload;
  String? stateId;

  EventPayload({
    this.payload,
    this.stateId,
  });
}
//TODO use element
class Event implements AbstractEvent {
  String? name;
  String stateId;
  dynamic payload;

  Event({
    this.name,
    required this.stateId,
    this.payload,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json["name"],
      stateId: json["stateId"],
      payload: json["payload"],
    );
  }

  factory Event.fromRawJson(String str) => Event.fromJson(json.decode(str));

  @override
  setName(String name) {
    this.name = name;
  }

  @override
  setPayload(payload) {
    this.payload = payload;
  }

  @override
  setStateId(String stateId) {
    this.stateId = stateId;
  }
}
