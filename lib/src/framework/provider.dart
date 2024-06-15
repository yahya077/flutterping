import 'app.dart';

abstract class AbstractProvider {
  void register(Application app);
}

class Provider implements AbstractProvider {
  @override
  void register(Application app) {
    throw UnimplementedError();
  }
}
