import 'package:flutter/material.dart';
import 'package:flutter_ping_wire/flutter_ping_wire.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final application = Application.getInstance();


  await WireBootstrap(application).runApp("simple");
}