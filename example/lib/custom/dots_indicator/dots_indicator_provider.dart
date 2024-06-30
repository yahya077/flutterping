import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'dots_indicator.dart';

class DotsIndicatorProvider extends Provider {
  DotsIndicatorProvider();

  @override
  void register(Application app) {
    app.singleton(
        DotsIndicatorDefinition.dotsIndicator, () => DotsIndicatorBuilder(app));
  }
}
