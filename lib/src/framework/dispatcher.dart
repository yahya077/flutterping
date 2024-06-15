import 'dart:async';

class Dispatcher {
  static final Dispatcher _singleton = Dispatcher._internal();

  factory Dispatcher() {
    return _singleton;
  }

  Dispatcher._internal();

  final Map<String, StreamController<dynamic>> _events = {};

  Stream<dynamic> on(String eventName) {
    _events.putIfAbsent(eventName, () => StreamController<dynamic>.broadcast());
    return _events[eventName]!.stream;
  }

  void dispatch(String eventName, [dynamic data]) {
    if (_events.containsKey(eventName)) {
      _events[eventName]!.add(data);
    }
  }

  void dispose(String eventName) {
    if (_events.containsKey(eventName)) {
      _events[eventName]!.close();
      _events.remove(eventName);
    }
  }
}