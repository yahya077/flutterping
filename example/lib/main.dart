import 'package:flutter/material.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

import 'custom/go_router/router_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final application = Application.getInstance();

  final providers = {
    // this is custom provider, u can implement your own providers
    "go_router": () => GoRouteRouterProvider(),
  };

  await WireBootstrap(application, registarables: providers).runApp(loader: "router");
}
