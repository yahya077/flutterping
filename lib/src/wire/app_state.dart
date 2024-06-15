import 'state.dart';

class AppState extends State {
  AppState({required Map<String, State> state}) : super(state: state);

  void addState(AbstractState state) {
    if (has(state.getId())) {
      remove(state.getId());
    }

    set(state.getId(), state);
  }

  //TODO: check again
  T getState<T>(String stateId) {
    return get<T>(stateId);
  }

  //TODO: check again
  void removeState(String stateId) {
    remove(stateId);
  }

  @override
  void dispose() {
    each((key, value) => value.dispose());
  }

  @override
  Map<String, dynamic> dehydrate() {
    final Map<String, dynamic> dehydrated = {};

    each((key, value) {
      dehydrated[key] = value.dehydrate();
    });

    return dehydrated;
  }
}
