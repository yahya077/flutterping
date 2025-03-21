import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/change_notifier_state.dart';
import 'package:flutter_ping_wire/src/wire/client_state.dart';
import 'package:flutter_ping_wire/src/wire/local_state.dart';
import 'package:flutter_ping_wire/src/wire/provider/json_builder_provider.dart';

import 'package:flutter_ping_wire/src/wire/value_provider.dart';

import '../framework/app.dart';
import 'client.dart';
import 'config.dart';
import 'definitions/definition.dart';
import 'loader/loader.dart';
import 'provider/wire_provider.dart';
import 'state_manager.dart';

export 'builders/widget_builder.dart';
export 'builders/json_builder.dart';
export 'builders/page_builder.dart';
export 'builders/router_config_builder.dart';
export 'builders/change_notifier_builder.dart';
export 'builders/localization_delegate_builder.dart';
export 'provider/wire_provider.dart';
export 'models/json.dart';
export 'models/event.dart';
export 'models/scope.dart';
export 'models/router_config_data.dart';
export 'state.dart';
export 'state_manager.dart';
export 'navigation_state.dart';
export 'routing_service.dart';
export 'resources/animation/animation.dart';
export 'resources/widgets/stateless_widget.dart';
export 'callable_registry.dart';
export 'stream.dart';
export 'value_provider.dart';
export 'resources/ui/color.dart';
export 'resources/core/double.dart';
export 'resources/paintings/alignment.dart';
export 'resources/paintings/box_fit.dart';
export 'resources/paintings/text_style.dart';
export 'resources/paintings/border.dart';
export 'resources/paintings/border_radius.dart';
export 'scope_state.dart';

class WireBootstrap {
  Application app;
  Map<String, dynamic> registarables;

  WireBootstrap(this.app, {this.registarables = const {}});

  Future<WireBootstrap> boot() async {
    app.register(() => WireProvider());
    app.register(() => JsonBuilderProvider());
    app.make<StateManager>(WireDefinition.stateManager)
        .addState(CallableRegistryState.initial());
    app.make<StateManager>(WireDefinition.stateManager)
        .addState(LocalState.initial());

    registarables.forEach((key, value) {
      app.register(value);
    });

    final config = await app.make<WireConfig>(WireDefinition.config).ensureAllAs();

    config.clients.forEach((key, value) {
      app.make<StateManager>(WireDefinition.stateManager)
          .addState(ClientState.initial(value));

      app.singleton(key, () => Client(app));

      app.make<Client>(key).setStateId("${WireDefinition.stateClientState}_${value.name}");
    });

    return this;
  }

  Future<void> runApp({String loader = "app"}) async {
    material.runApp(wrap(await app
        .make<PreLoader>(WireDefinition.loaderPreLoader)
        .load<material.Widget>(loader)));
  }

  wrap(material.Widget widget) {
    return ValueProvider(
      manager: ValueNotifierManager(),
      child: widget,
    );
  }
}
