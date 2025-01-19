import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'webview_flutter.dart';

class WebviewFlutterProvider extends Provider {
  WebviewFlutterProvider();

  @override
  void register(Application app) {
    app.singleton(WebviewFlutterDefinition.webviewFlutter,
        () => WebviewFlutterBuilder(app));
  }
}
