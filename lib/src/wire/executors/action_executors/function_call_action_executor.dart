part of '../action_executor.dart';

class FunctionCallActionExecutor extends ActionExecutor {
  FunctionCallActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final callableRegistry = application
        .make<StateManager>(WireDefinition.stateManager)
        .get<CallableRegistry>(WireDefinition.stateCallableRegistryState,
            json.data["notifierId"]);

    Map<String, dynamic>? arguments = json.data["arguments"];

    if (arguments != null) {
      arguments = arguments.map((key, value) {
        return MapEntry(
            key,
            application
                .make<ValueManager>(WireDefinition.valueManager)
                .getValue(Value.fromJson(value["data"])));
      });
    }

    application
        .make<StateManager>(WireDefinition.stateManager)
        .disposeScope(json.data["scopeId"]);

    callableRegistry.call(json.data["method"], arguments);
  }
}
