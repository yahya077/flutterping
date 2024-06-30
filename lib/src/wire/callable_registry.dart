import 'package:flutter/material.dart' as material;

mixin CallableRegistryMixin {
  Map<String, dynamic> callables = {};

  void registerCallable(
      String method, dynamic Function(Map<String, dynamic>?) callable) {
    callables[method] = callable;
  }

  dynamic call(String method, [Map<String, dynamic>? arguments]) {
    if (callables.containsKey(method)) {
      return callables[method](arguments);
    }

    throw Exception("Method $method not found");
  }

  initCallables() {
    throw Exception("initCallables not implemented");
  }
}

abstract class CallableRegistry<T> extends material.ChangeNotifier
    with CallableRegistryMixin {
  final T instance;

  CallableRegistry(this.instance) {
    initCallables();
  }

  Type getType() {
    return instance.runtimeType;
  }
}
