import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/value_provider.dart';
import '../../models/element.dart';
import '../../stream.dart';

class State {
  String name;
  List<Element> actions;

  State({
    required this.name,
    required this.actions,
  });

  factory State.fromRawJson(String str) => State.fromJson(json.decode(str));

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      name: json["name"],
      actions:
          List<Element>.from(json["actions"].map((x) => Element.fromJson(x))),
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

class ReactiveMaterialWidget extends material.StatefulWidget {
  final ValueNotifier<material.Widget> widgetNotifier;
  final EventListener actionEventListener;
  final EventListener stateEventListener;
  final DisposeListener disposeListeners;
  final Function(material.BuildContext context) emitInitialState;

  const ReactiveMaterialWidget({
    super.key,
    required this.widgetNotifier,
    required this.actionEventListener,
    required this.stateEventListener,
    required this.disposeListeners,
    required this.emitInitialState,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _actionEventSubscription = widget.actionEventListener(context);

    _stateEventSubscription = widget.stateEventListener(context);

    widget.widgetNotifier.addListener(_updateState);

    widget.emitInitialState(context);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  material.Widget build(material.BuildContext context) {
    super.build(context);
    return widget.widgetNotifier.value ?? material.Container();
  }

  @override
  void dispose() {
    _actionEventSubscription?.cancel();
    _stateEventSubscription?.cancel();

    widget.disposeListeners();

    widget.widgetNotifier.removeListener(_updateState);

    super.dispose();
  }
}
