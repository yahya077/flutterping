import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/widgets/form.dart';

class PingCheckboxField extends material.StatefulWidget {
  final String name;
  final bool initialValue;
  final material.Widget? title;
  final material.Widget? subTitle;
  final material.InputDecoration? decoration;
  final material.ValueChanged<bool?>? onChanged;
  final String? Function(dynamic)? validator;
  final bool tristate;
  final material.MouseCursor? mouseCursor;
  final material.Color? activeColor;
  final material.WidgetStateProperty<material.Color?>? fillColor;
  final material.Color? checkColor;
  final material.Color? focusColor;
  final material.Color? hoverColor;
  final material.WidgetStateProperty<material.Color?>? overlayColor;
  final double? splashRadius;
  final material.MaterialTapTargetSize? materialTapTargetSize;
  final material.VisualDensity? visualDensity;
  final material.FocusNode? focusNode;
  final bool autofocus;
  final material.OutlinedBorder? shape;
  final material.BorderSide? side;
  final bool isError;
  final String? semanticLabel;
  final material.EdgeInsetsGeometry? contentPadding;

  const PingCheckboxField({
    material.Key? key,
    required this.name,
    this.initialValue = false,
    this.decoration,
    this.onChanged,
    this.validator,
    this.tristate = false,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
    this.isError = false,
    this.semanticLabel,
    this.title,
    this.subTitle, this.contentPadding,
  }) : super(key: key);

  @override
  _PingCheckboxFieldState createState() => _PingCheckboxFieldState();
}

class _PingCheckboxFieldState extends material.State<PingCheckboxField> {
  bool? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  material.InputDecoration getDefaultDecoration(
      material.InputDecoration? decoration) {
    return decoration?.copyWith(
          border: decoration.border ?? material.InputBorder.none,
          focusedBorder: decoration.focusedBorder ?? material.InputBorder.none,
          enabledBorder: decoration.enabledBorder ?? material.InputBorder.none,
          errorBorder: decoration.errorBorder ?? material.InputBorder.none,
          disabledBorder:
              decoration.disabledBorder ?? material.InputBorder.none,
        ) ??
        const material.InputDecoration(
          border: material.InputBorder.none,
          focusedBorder: material.InputBorder.none,
          enabledBorder: material.InputBorder.none,
          errorBorder: material.InputBorder.none,
          disabledBorder: material.InputBorder.none,
        );
  }

  @override
  material.Widget build(material.BuildContext context) {
    return PingFormField(
      name: widget.name,
      validator: widget.validator,
      builder: (field) {
        return material.InputDecorator(
          decoration: getDefaultDecoration(widget.decoration).copyWith(
            errorText: field.errorText,
            errorStyle: const material.TextStyle(

            )
          ),
          child: material.Align(
            alignment: material.Alignment.center,
            child: material.CheckboxListTile(
              dense: true,
              isThreeLine: false,
              title: widget.title,
              subtitle: widget.subTitle,
              value: field.value ?? _value,
              tristate: widget.tristate,
              onChanged: (value) {
                field.didChange(value);
                widget.onChanged?.call(value);
              },
              contentPadding: widget.contentPadding ?? material.EdgeInsets.zero,
              mouseCursor: widget.mouseCursor,
              activeColor: widget.activeColor,
              fillColor: widget.fillColor,
              checkColor: widget.checkColor,
              hoverColor: widget.hoverColor,
              overlayColor: widget.overlayColor,
              splashRadius: widget.splashRadius,
              materialTapTargetSize: widget.materialTapTargetSize,
              visualDensity: widget.visualDensity,
              focusNode: widget.focusNode,
              autofocus: widget.autofocus,
              shape: widget.shape,
              side: widget.side,
              isError: widget.isError,
              controlAffinity: material.ListTileControlAffinity.leading,
            ),
          ),
        );
      },
    );
  }
}
