import 'package:flutter/material.dart' as material;

class StatelessWidget extends material.StatelessWidget {
  final material.WidgetBuilder builder;

  const StatelessWidget({super.key, required this.builder});

  @override
  material.Widget build(material.BuildContext context) {
    return builder(context);
  }
}
