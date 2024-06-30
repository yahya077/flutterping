part of '../action_executor.dart';

class FunctionCallActionExecutor extends ActionExecutor {
  FunctionCallActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final callableRegistry = application
        .make<StateManager>(WireDefinition.stateManager)
        .get<CallableRegistry>(WireDefinition.stateCallableRegistryState,
            element.data["notifierId"]);

    Map<String, dynamic>? arguments = element.data["arguments"];

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
        .disposeScope(element.data["scopeId"]);

    callableRegistry.call(element.data["method"], arguments);
  }
}
