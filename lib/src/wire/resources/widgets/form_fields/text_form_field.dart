import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/widgets/form.dart';

class PingTextField extends material.StatefulWidget {
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
  final material.FocusNode? focusNode;

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
    this.focusNode,
  })  : assert(controller == null || initialValue == null,
            'Cannot provide both a controller and an initialValue.'),
        super(key: key);

  @override
  _PingTextFieldState createState() => _PingTextFieldState();
}

class _PingTextFieldState extends material.State<PingTextField> {
  late final material.TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        material.TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  material.Widget build(material.BuildContext context) {
    return PingFormField(
      name: widget.name,
      validator: widget.validator,
      builder: (field) {
        // Update the controller's text if the field value changes
        if (_controller.text != field.value) {
          _controller.text = field.value ?? '';
          _controller.selection = material.TextSelection.fromPosition(
            material.TextPosition(offset: _controller.text.length),
          );
        }

        return material.TextFormField(
          controller: _controller,
          decoration: widget.decoration.copyWith(
            errorText: field.errorText,
          ),
          buildCounter: (
            material.BuildContext context, {
            required int currentLength,
            required int? maxLength,
            required bool isFocused,
          }) {
            return null;
          },
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          onChanged: (value) {
            field.didChange(value); // Update form field state
            widget.onChanged?.call(value);
          },
          onSaved: (value) {
            field.didChange(value); // Update form field state
            widget.onSaved?.call(value);
          },
          maxLength: widget.maxLength,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onEditingComplete: widget.onEditingComplete,
          focusNode: widget.focusNode,
        );
      },
    );
  }
}
