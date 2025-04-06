class Container {
  static Container? _instance;

  // Map to store bindings
  final Map<String, dynamic> _bindings = {};

  // Map to store singletons
  final Map<String, dynamic> _singletons = {};

  factory Container() {
    _instance ??= Container.newContainer();
    return _instance!;
  }

  Container.newContainer();

  void bind(String abstract, Function concrete, [bool shared = false]) {
    if (_bindings.containsKey(abstract)) {
      throw Exception("Binding already exists for $abstract");
    }

    _bindings[abstract] = {'concrete': concrete, 'shared': shared};
  }

  T make<T>(String abstract, [List<dynamic> parameters = const []]) {
    if (_bindings.containsKey(abstract)) {
      if (_bindings[abstract]['shared']) {
        if (_singletons.containsKey(abstract)) {
          return _singletons[abstract];
        } else {
          return _singletons[abstract] =
              call(_bindings[abstract]['concrete'], parameters);
        }
      } else {
        return call(_bindings[abstract]['concrete'], parameters);
      }
    } else {
      throw Exception("No binding found for $abstract");
    }
  }

  T call<T>(Function callback, [List<dynamic> parameters = const []]) {
    return Function.apply(callback, parameters);
  }

  singleton<T>(String abstract, T Function() concrete) {
    return bind(abstract, concrete, true);
  }
  
  /// Get a list of all registered bindings
  List<String> getRegisteredBindings() {
    return _bindings.keys.toList();
  }
  
  /// Check if a binding exists
  bool hasBinding(String abstract) {
    return _bindings.containsKey(abstract);
  }
  
  /// Remove a binding from the container
  void remove(String abstract) {
    _bindings.remove(abstract);
    _singletons.remove(abstract);
  }
}
