import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/widgets/form.dart';

class PingTextField extends material.StatelessWidget {
  final String name;
  final String? Function(dynamic)? validator;
  final material.TextEditingController? controller;
  final material.InputDecoration decoration;
  final material.TextInputType keyboardType;
  final bool obscureText;
  final String? initialValue;
  final material.ValueChanged<String>? onChanged;
  final material.ValueChanged<String?>? onSaved;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final material.VoidCallback? onEditingComplete;

  const PingTextField({
    material.Key? key,
    required this.name,
    this.validator,
    this.controller,
    this.decoration = const material.InputDecoration(),
    this.keyboardType = material.TextInputType.text,
    this.obscureText = false,
    this.initialValue,
    this.onChanged,
    this.onSaved,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  material.Widget build(material.BuildContext context) {
    return PingFormField(
      name: name,
      validator: validator,
      builder: (field) {
        return material.TextFormField(
          controller: controller,
          decoration: decoration,
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: (value) {
            field.didChange(value);
            onChanged?.call(value);
          },
          onSaved: onSaved,
          maxLength: maxLength,
          maxLines: maxLines,
          initialValue: initialValue,
          minLines: minLines,
          onEditingComplete: onEditingComplete,
        );
      },
    );
  }
}
