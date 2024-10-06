import 'package:flutter/material.dart' as material;

import '../../form_state.dart';

class TextInput extends material.StatelessWidget {
  final String name;
  final FormState? formState;
  final TextFormFieldState formFieldState;
  final material.InputDecoration? decoration;
  final int? maxLength;
  final int? maxLines;
  final bool? obscureText;
  final int? minLines;

  const TextInput({
    material.Key? key,
    required this.name,
    this.formState,
    this.decoration = const material.InputDecoration(),
    required this.formFieldState, this.maxLength, this.maxLines, this.obscureText, this.minLines,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return material.TextFormField(
      controller: formFieldState.getController(),
      onSaved: (value) {
        formFieldState.onSaved(value);
      },
      decoration: decoration,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onEditingComplete: () {
        formFieldState.onEditingComplete();
      },
      onChanged: (value) {
        formFieldState.onChanged(value);
      },
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: obscureText ?? false,
      minLines: minLines,
    );
  }
}