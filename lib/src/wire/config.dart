import 'package:flutter_ping_wire/src/framework/config.dart';
import 'package:flutter_ping_wire/src/wire/models/config.dart' as model;

import 'definitions/wire.dart';

class WireConfig extends Config<model.WireConfig> {
  WireConfig() : super();

  @override
  String getConfigName() {
    return WireDefinition.config;
  }

  @override
  model.WireConfig allAs() {
    return model.WireConfig.fromMap(all());
  }

  @override
  Future<model.WireConfig> ensureAllAs() async {
    return model.WireConfig.fromMap(await ensureAll());
  }
}
