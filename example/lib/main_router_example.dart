import 'package:flutter/material.dart' as material;
import 'package:flutter/foundation.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';
import 'package:flutter_ping_wire/bootstrap.dart';

import 'custom/go_router/router_provider.dart';
import 'custom/flutter_credit_card/flutter_credit_card_provider.dart';
import 'custom/carousel_slider/carousel_slider_provider.dart';
import 'custom/dots_indicator/dots_indicator_provider.dart';
import 'custom/webview_flutter/webview_flutter_provider.dart';
import 'custom/flutter_svg/flutter_svg.dart';
import 'custom/animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

void main() async {
  material.WidgetsFlutterBinding.ensureInitialized();

  try {
    final application = await Bootstrap.init(bootstrappers: [
      (Application application) {
        return WireBootstrapper(application, [
          GoRouteRouterProvider(),
          FlutterCreditCardProvider(),
          CarouselSliderProvider(),
          DotsIndicatorProvider(),
          WebviewFlutterProvider(),
          FlutterSvgProvider(),
          AnimatedBottomNavigationBarProvider(),
        ]);
      }
    ]);

    await application.make<Wire>(WireDefinition.wireService).runApp();
  } catch (e, stackTrace) {
    debugPrint('Initialization error: $e');
    debugPrint('Stack trace: $stackTrace');
    rethrow;
  }
}
