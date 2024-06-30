import 'definitions/definition.dart';
import 'state.dart';

class CallableRegistryState extends State {
  CallableRegistryState({required Map<String, dynamic> state})
      : super(state: state);

  CallableRegistryState.initial() : super(state: {}) {
    hydrate({
      'id': WireDefinition.stateCallableRegistryState,
    });
  }
}
