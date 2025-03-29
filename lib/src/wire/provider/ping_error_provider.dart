import 'package:flutter_ping_wire/src/framework/app.dart';
import 'package:flutter_ping_wire/src/framework/provider.dart';
import 'package:flutter_ping_wire/src/wire/builders/widget_builder.dart';
import 'package:flutter_ping_wire/src/wire/definitions/json.dart';

/// Provider that registers the PingErrorBuilder with the framework
class PingErrorProvider extends ServiceProvider {
  @override
  void register(Application app) {
    // Register the PingErrorBuilder as a singleton with the standard JSON definition key
    app.singleton(JsonDefinition.pingErrorView, () => PingErrorBuilder(app));
  }

  @override
  Future<void> boot(Application app) async {
    // No additional boot steps needed since we used the standard JsonDefinition pattern
    // The builder will be accessible via:
    // application.make<JsonBuilder>(JsonDefinition.pingErrorView)
  }
} 