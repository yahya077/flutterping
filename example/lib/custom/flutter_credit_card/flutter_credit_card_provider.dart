import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'flutter_credit_card.dart';

class FlutterCreditCardProvider extends Provider {
  FlutterCreditCardProvider();

  @override
  void register(Application app) {
    app.singleton(FlutterCreditCardDefinition.flutterCreditCard,
        () => FlutterCreditCardBuilder(app));
  }
}
