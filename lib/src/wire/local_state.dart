import 'definitions/definition.dart';
import 'state.dart';

class LocalState extends State {
  LocalState({required Map<String, dynamic> state}) : super(state: state);

  LocalState.initial() : super(state: {}) {
    hydrate({
      'id': WireDefinition.stateLocalState,
    });
  }
}
