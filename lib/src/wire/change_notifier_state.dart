import 'definitions/definition.dart';
import 'state.dart';

class ChangeNotifierState extends State {
  ChangeNotifierState({required Map<String, dynamic> state}) : super(state: state);

  ChangeNotifierState.initial() : super(state: {}) {
    hydrate({
      'id': WireDefinition.stateChangeNotifierState,
    });
  }
}
