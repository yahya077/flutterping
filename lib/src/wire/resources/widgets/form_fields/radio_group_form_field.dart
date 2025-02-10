import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/wire/resources/widgets/form.dart';

class PingRadioGroupField extends material.StatefulWidget {
  final String name;
  final bool initialValue;
  final material.Widget? title;
  final material.Widget? subTitle;
  final material.InputDecoration? decoration;
  final material.ValueChanged<bool?>? onChanged;
  final String? Function(dynamic)? validator;
  final List<material.RadioListTile> options;

  const PingRadioGroupField({
    material.Key? key,
    required this.name,
    this.initialValue = false,
    this.decoration,
    this.onChanged,
    this.validator,
    this.title,
    this.subTitle,
    this.options = const [],
  }) : super(key: key);

  @override
  _PingRadioGroupFieldState createState() => _PingRadioGroupFieldState();
}

class _PingRadioGroupFieldState extends material.State<PingRadioGroupField> {
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
            child: material.Column(
              children: [
                if (widget.title != null) widget.title!,
                if (widget.subTitle != null) widget.subTitle!,
                for (var option in widget.options)
                  material.RadioListTile(
                    value: option.value,
                    groupValue: field.value ?? _value,
                    onChanged: (value) {
                      field.didChange(value);
                      if (widget.onChanged != null) {
                        widget.onChanged!(value);
                      }
                    },
                    title: option.title,
                    subtitle: option.subtitle,
                    secondary: option.secondary,
                    isThreeLine: option.isThreeLine,
                    dense: option.dense,
                    selected: option.value == _value || option.value == field.value,
                    contentPadding: option.contentPadding,
                    tileColor: option.tileColor,
                    selectedTileColor: option.selectedTileColor,
                    activeColor: option.activeColor,
                    hoverColor: option.hoverColor,
                    splashRadius: option.splashRadius,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}