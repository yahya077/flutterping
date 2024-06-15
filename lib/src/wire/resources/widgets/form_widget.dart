import 'package:flutter/material.dart' as material;

import '../../form_state.dart';

class FormWidget extends material.StatelessWidget {
  final FormState formState;
  final List<material.Widget> children;

  const FormWidget({
    material.Key? key,
    required this.formState,
    this.children = const [],
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.Form(
      key: formState.formStateKey,
      child: material.Column(
        children: children,
      ),
    );
  }
}
