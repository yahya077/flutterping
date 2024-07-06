import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

class ChangeNotifierBuilder extends JsonBuilder<material.ChangeNotifier> {
  ChangeNotifierBuilder(Application application) : super(application);

  @override
  material.ChangeNotifier build(Json json) {
    return application
        .make<ChangeNotifierBuilder>(json.type)
        .build(Json.fromJson(json.data));
  }
}

class ScrollControllerBuilder extends ChangeNotifierBuilder {
  ScrollControllerBuilder(Application application) : super(application);

  @override
  material.ScrollController build(Json json) {
    final id = json.data["id"];

    return application
        .make<StateManager>(WireDefinition.stateManager)
        .get<ScrollController>(WireDefinition.stateCallableRegistryState, id,
            defaultValue: ScrollController(material.ScrollController()))
        .instance;
  }
}

class ScrollController extends CallableRegistry<material.ScrollController> {
  static const String methodJumpTo = "jumpTo";
  static const String methodAnimateTo = "animateTo";
  static const String methodDispose = "dispose";
  static const String methodAttach = "attach";

  ScrollController(super.controller);

  @override
  initCallables() {
    callables = {
      methodJumpTo: (arguments) {
        final offset = arguments!["offset"];
        return instance.jumpTo(offset);
      },
      methodAnimateTo: (arguments) {
        final offset = arguments!["offset"];
        final duration = arguments["duration"];
        final curve = arguments["curve"];
        return instance.animateTo(offset, duration: duration, curve: curve);
      },
      methodDispose: (_) {
        instance.dispose();
      },
      methodAttach: (_) {
        instance.attach(instance.position);
      }
    };
  }
}
