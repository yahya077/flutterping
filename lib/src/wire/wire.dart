import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as material;
import 'dart:convert';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/src/framework/persistent_storage.dart';
import 'package:flutter_ping_wire/src/wire/change_notifier_state.dart';
import 'package:flutter_ping_wire/src/wire/client_state.dart';
import 'package:flutter_ping_wire/src/wire/local_state.dart';
import 'package:flutter_ping_wire/src/wire/provider/json_builder_provider.dart';
import 'package:flutter_ping_wire/src/wire/services/device_info/device_info_module.dart';

import 'package:flutter_ping_wire/src/wire/value_provider.dart';

import '../framework/app.dart';
import '../framework/environment.dart';
import '../framework/maintenance/maintenance_mode.dart';
import '../framework/provider.dart';
import 'builders/json_builder.dart';
import 'builders/widget_builder.dart';
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
export 'resources/core/duration.dart';
export 'resources/paintings/alignment.dart';
export 'resources/paintings/box_fit.dart';
export 'resources/paintings/text_style.dart';
export 'resources/paintings/border.dart';
export 'resources/paintings/border_radius.dart';
export 'scope_state.dart';
export 'services/device_info/device_info_module.dart';
export 'resources/paintings/gradient.dart';
export 'package:flutter_ping_wire/bootstrap.dart';

/// Core Wire framework service provider for the JSON-to-widget converter
class WireFrameworkProvider extends FrameworkServiceProvider {
  @override
  int get priority => 60; // Higher than individual providers

  final Map<String, ServiceProvider> _additionalProviders;

  WireFrameworkProvider({Map<String, ServiceProvider>? additionalProviders})
      : _additionalProviders = additionalProviders ?? {};

  @override
  void register(Application app) {
    // Register Wire core providers
    app.register(WireProvider());
    app.register(JsonBuilderProvider());

    // Register maintenance mode if not already registered
    if (!app.hasBinding('maintenance.mode')) {
      app.singleton('maintenance.mode', () => FileMaintenanceMode(app));
    }

    // Register additional providers
    for (final provider in _additionalProviders.values) {
      app.register(provider);
    }
  }

  @override
  Future<void> boot(Application app) async {
    // Add initial states
    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(CallableRegistryState.initial());

    app
        .make<StateManager>(WireDefinition.stateManager)
        .addState(LocalState.initial());

    final deviceInfo = await DeviceInfoHandler.gatherAllDeviceInfo();
    app.make<StateManager>(WireDefinition.stateManager).addState(
        DeviceInfoState.initialWithValues(deviceInfo));

    // Load and register clients from config
    final config =
        await app.make<WireConfig>(WireDefinition.config).ensureAllAs();

    config.clients.forEach((key, value) {
      app
          .make<StateManager>(WireDefinition.stateManager)
          .addState(ClientState.initial(value, deviceInfo, persistentStorage: app.make<PersistentStorageInterface>(
        WireDefinition.persistentStorage,
      )));

      // Register client
      app.singleton(key, () => Client(app));

      // Set state ID
      app
          .make<Client>(key)
          .setStateId("${WireDefinition.stateClientState}_$key");
    });

    if (kDebugMode) {
      print(
          'Wire UI framework initialized in ${Environment.current()} environment');
    }
  }
}

class WireBootstrapper {
  final Application application;
  final List<ServiceProvider> _additionalProviders;

  WireBootstrapper(this.application, this._additionalProviders);

  void bootstrap() {
    application.register(WireFrameworkProvider());

    for (final provider in _additionalProviders) {
      application.register(provider);
    }
  }

  @override
  String toString() {
    return "WireBootstrapper";
  }
}

class Wire {
  final Application application;

  Wire(this.application);

  Future<void> runApp({String loader = "app"}) async {
    material.runApp(wrap(await application
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
