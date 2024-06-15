import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/src/wire/models/config.dart' as config_model;
import 'package:flutter_ping_wire/src/wire/provider/element_builder_provider.dart';

import 'client.dart';
import 'config.dart';
import 'resources/widgets/reactive_widget_manager.dart';

export 'builders/widget_builder.dart';
export 'builders/element_builder.dart';
export 'builders/page_builder.dart';
export 'builders/router_config_builder.dart';
export 'provider/wire_provider.dart';
export 'models/element.dart';
export 'models/router_config_data.dart';
export 'state.dart';
export 'state_manager.dart';
export 'navigation_state.dart';
export 'routing_service.dart';

class WireBootstrap {
  Application app;
  Map<String, dynamic> registarables;

  WireBootstrap(this.app, {this.registarables = const {}}) {
    register();
  }

  void register() {
    //
  }

  WireBootstrap boot() {
    app.register(() => WireProvider());
    app.register(() => ElementBuilderProvider());
    registarables.forEach((key, value) {
      app.register(value);
    });

    return this;
  }

  Future<void> initAsync() async {
    final config =
        await app.make<WireConfig>(WireDefinition.config).ensureAllAs();

    initClients(config);
  }

  void initClients(config_model.WireConfig config) {
    config.clients.forEach((key, value) {
      app.singleton(key, () => Client(app));

      app.make<Client>(key).setBaseUrl(Uri.parse(value.url));
    });
  }

  Future<void> runApp(String loader) async {
    boot();

    await initAsync();

    material.runApp(wrap(await app
        .make<PreLoader>(WireDefinition.loaderPreLoader)
        .load<material.Widget>(loader)));
  }

  wrap(material.Widget widget) {
    return ReactiveWidgetProvider(
      manager: ReactiveWidgetNotifierManager(),
      child: widget,
    );
  }
}
