import 'definitions/definition.dart';
import 'state.dart';

class ScopeState extends State {
  ScopeState({required Map<String, dynamic> state}) : super(state: state);

  ScopeState.initial() : super(state: {}) {
    hydrate({
      'id': WireDefinition.stateScopeState,
    });
  }
}
