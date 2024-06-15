import 'package:flutter/material.dart' as material;

import '../../form_state.dart';

class TextInput extends material.StatelessWidget {
  final String name;
  final FormState? formState;
  final TextFormFieldState formFieldState;

  const TextInput({
    material.Key? key,
    required this.name,
    this.formState,
    required this.formFieldState,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.TextFormField(
      controller: formFieldState.getController(),
      onSaved: (value) {
        formFieldState.onSaved(value);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onEditingComplete: () {
        formFieldState.onEditingComplete();
      },
    );
  }
}