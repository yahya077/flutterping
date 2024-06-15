import 'package:flutter/material.dart' as material;

import '../../stream.dart';

class StatelessWidget extends material.StatelessWidget {
  final material.Widget widget;
  final EventListener eventListener;

  const StatelessWidget(
      {super.key,
        required this.widget,
        required this.eventListener});

  @override
  material.Widget build(material.BuildContext context) {
    eventListener(context);
    return widget;
  }
}