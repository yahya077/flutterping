import 'package:flutter/material.dart' as material;

class ValueNotifierManager extends material.ChangeNotifier {
  final Map<String, ValueNotifier> _values = {};

  ValueNotifier<T> registerValueNotifier<T>(String id, {T? defaultValue}) {
    if (_values.containsKey(id)) {
      return _values[id]! as ValueNotifier<T>;
    }

    final valueNotifier = ValueNotifier<T>(defaultValue);

    _values[id] = valueNotifier;

    return valueNotifier;
  }

  ValueNotifier<T>? getValueNotifier<T>(String id) {
    return _values[id] as ValueNotifier<T>?;
  }

  //TODO: add dispose value notifier
  List<String> get keys => _values.keys.toList();
}

class ValueNotifier<T> extends material.ChangeNotifier {
  T? _value;

  T? get value => _value;

  ValueNotifier(T? value) {
    _value = value;
  }

  void updateValue(T value) {
    _value = value;
    notifyListeners();
  }
}

class ValueProvider extends material.InheritedNotifier<ValueNotifierManager> {
  final ValueNotifierManager manager;

  const ValueProvider({
    material.Key? key,
    required this.manager,
    required material.Widget child,
  }) : super(key: key, child: child);

  static ValueNotifierManager of(material.BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ValueProvider>()!.manager;
  }

  @override
  bool updateShouldNotify(ValueProvider oldWidget) {
    return oldWidget.manager != manager;
  }
}

abstract class NeedsValueNotifierState<T extends material.StatefulWidget>
    extends material.State<T> {
  late final List<ValueNotifier> notifiers;

  void registerNotifiers();

  @override
  void initState() {
    super.initState();
    registerNotifiers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    for (var notifier in notifiers) {
      notifier.addListener(_updateState);
    }
  }

  void _updateState() {
    setState(() {});
  }

  void _disposeNotifiers() {
    for (var notifier in notifiers) {
      notifier.dispose();
    }
  }

  @override
  void dispose() {
    _disposeNotifiers();
    super.dispose();
  }
}
