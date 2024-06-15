import 'container.dart';

class ExceptionHandler {
  final Container container;

  ExceptionHandler(this.container) {
    register();
  }

  void register() {}

  void report(e) {
    throw e;
  }
}
