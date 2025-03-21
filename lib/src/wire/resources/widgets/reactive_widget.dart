import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/value_provider.dart';
import '../../models/json.dart';
import '../../stream.dart';

class State {
  String name;
  List<Json> actions;

  State({
    required this.name,
    required this.actions,
  });

  factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json["name"],
      actions: List<Json>.from(json["actions"].map((x) => Json.fromJson(x))),
    );
  }
}

class ReactiveWidgetStateSchema {
  List<State> states;
  String initialStateName;

  ReactiveWidgetStateSchema({
    required this.states,
    required this.initialStateName,
  });

  factory ReactiveWidgetStateSchema.fromRawJson(String str) =>
      ReactiveWidgetStateSchema.fromJson(json.decode(str));

  factory ReactiveWidgetStateSchema.fromJson(Map<String, dynamic> json) {
    return ReactiveWidgetStateSchema(
      states: List<State>.from(json["states"].map((x) => State.fromJson(x))),
      initialStateName: json["initialStateName"],
    );
  }

  State getState(String state) {
    return states.firstWhere((element) => element.name == state);
  }

  State get initialState {
    return getState(initialStateName);
  }
}

class PageNotifier {
  final String notifierId;
  final dynamic defaultValue;

  PageNotifier({
    required this.notifierId,
    required this.defaultValue,
  });

  factory PageNotifier.fromJson(Map<String, dynamic> json) {
    return PageNotifier(
      notifierId: json["notifierId"],
      defaultValue: json["defaultValue"],
    );
  }

  static List<PageNotifier> listFromJson(List<dynamic> json) {
    return List<PageNotifier>.from(json.map((x) => PageNotifier.fromJson(x)));
  }

  static List<PageNotifier> listFromJsonString(String jsonString) {
    return listFromJson(json.decode(jsonString));
  }
}

class ReactiveMaterialWidget extends material.StatefulWidget {
  final ValueNotifier<material.Widget> widgetNotifier;
  final Map<String, ValueNotifier<dynamic>> pageNotifiers;
  final EventListener actionEventListener;
  final EventListener stateEventListener;
  final DisposeListener disposeListeners;
  final Function(material.BuildContext context) emitInitialState;
  final material.Widget Function(material.BuildContext context)?
      initialWidgetBuilder;

  const ReactiveMaterialWidget({
    super.key,
    required this.widgetNotifier,
    required this.actionEventListener,
    required this.stateEventListener,
    required this.disposeListeners,
    required this.emitInitialState,
    required this.pageNotifiers,
    required this.initialWidgetBuilder,
  });

  @override
  material.State<ReactiveMaterialWidget> createState() => ReactiveWidgetState();
}

class ReactiveWidgetState extends material.State<ReactiveMaterialWidget>
    with material.AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  StreamSubscription? _actionEventSubscription;
  StreamSubscription? _stateEventSubscription;
  ValueNotifierManager? _valueNotifierManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _valueNotifierManager = ValueProvider.of(context);

    _actionEventSubscription = widget.actionEventListener(context);

    _stateEventSubscription = widget.stateEventListener(context);

    widget.widgetNotifier.addListener(_updateState);

    widget.pageNotifiers.forEach((key, value) {
      value.addListener(_updateState);
    });

    if (widget.initialWidgetBuilder == null) {
      widget.emitInitialState(context);
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  material.Widget build(material.BuildContext context) {
    super.build(context);
    if (widget.initialWidgetBuilder != null) {
      return widget.initialWidgetBuilder!(context);
    } else {
      //TODO - value should material.Widget Function(material.BuildContext context) this will be fix the contextual issue
      return widget.widgetNotifier.value;
    }
  }

  @override
  void dispose() {
    _actionEventSubscription?.cancel();
    _stateEventSubscription?.cancel();

    widget.disposeListeners();

    widget.widgetNotifier.removeListener(_updateState);

    widget.pageNotifiers.forEach((key, value) {
      value.removeListener(_updateState);

      _valueNotifierManager?.disposeValueNotifier(key);
    });

    super.dispose();
  }
}
