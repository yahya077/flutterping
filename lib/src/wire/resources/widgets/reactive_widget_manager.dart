import 'package:flutter/material.dart' as material;

class ReactiveWidgetNotifierManager extends material.ChangeNotifier {
  final Map<String, ReactiveWidgetNotifier> _reactiveWidgets = {};

  ReactiveWidgetNotifier createReactiveWidgetNotifier(String id) {
    final reactiveWidget = ReactiveWidgetNotifier();
    _reactiveWidgets[id] = reactiveWidget;

    return reactiveWidget;
  }

  ReactiveWidgetNotifier? getReactiveWidget(String id) {
    return _reactiveWidgets[id];
  }

  void removeReactiveWidget(String id) {
    _reactiveWidgets.remove(id);
    notifyListeners();
  }

  List<String> get keys => _reactiveWidgets.keys.toList();
}

class ReactiveWidgetNotifier extends material.ChangeNotifier {
  material.Widget _widget = material.Container();

  material.Widget get widget => _widget;

  void updateWidget(material.Widget newWidget) {
    _widget = newWidget;
    notifyListeners();
  }
}

class ReactiveWidgetProvider
    extends material.InheritedNotifier<ReactiveWidgetNotifierManager> {
  final ReactiveWidgetNotifierManager manager;

  const ReactiveWidgetProvider({
    material.Key? key,
    required this.manager,
    required material.Widget child,
  }) : super(key: key, child: child);

  static ReactiveWidgetNotifierManager of(material.BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ReactiveWidgetProvider>()!
        .manager;
  }

  @override
  bool updateShouldNotify(ReactiveWidgetProvider oldWidget) {
    return oldWidget.manager != manager;
  }
}