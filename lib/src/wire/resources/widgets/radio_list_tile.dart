import 'package:flutter/material.dart' as material;

import '../../value_provider.dart';

class RadioListTile<T> extends material.StatefulWidget {
  final T value;
  final ValueNotifier<T> selectedValue;
  final material.ValueChanged<T?>? onChanged;
  final material.Color? activeColor;
  // final MaterialStateProperty<Color?>? fillColor; TODO: Implement MaterialStateProperty
  // final MaterialTapTargetSize? materialTapTargetSize; TODO: Implement MaterialTapTargetSize
  final material.Color? hoverColor;
  // final MaterialStateProperty<Color?>? overlayColor; TODO: Implement MaterialStateProperty
  final double? splashRadius;
  final material.Widget title;
  final material.Widget? subtitle;
  final material.Widget? secondary;
  final bool isThreeLine;
  final bool dense;
  final bool selected;
  final material.EdgeInsetsGeometry? contentPadding;
  final material.Color? tileColor;
  final material.Color? selectedTileColor;

  const RadioListTile(
      {material.Key? key,
      required this.selectedValue,
      this.onChanged,
      required this.title,
      required this.subtitle,
      required this.secondary,
      required this.isThreeLine,
      required this.dense,
      required this.selected,
      this.contentPadding,
      this.tileColor,
      this.selectedTileColor,
      required this.value,
      this.activeColor,
      this.hoverColor,
      this.splashRadius})
      : super(key: key);

  @override
  NeedsValueNotifierState<RadioListTile<T>> createState() =>
      _RadioListTileWidgetState();
}

class _RadioListTileWidgetState<T> extends NeedsValueNotifierState<RadioListTile<T>> {
  @override
  material.Widget build(material.BuildContext context) {
    return material.RadioListTile<T>(
      value: widget.value,
      groupValue: widget.selectedValue.value,
      onChanged: widget.onChanged,
      title: widget.title,
      subtitle: widget.subtitle,
      secondary: widget.secondary,
      activeColor: widget.activeColor,
      hoverColor: widget.hoverColor,
      splashRadius: widget.splashRadius,
      isThreeLine: widget.isThreeLine,
      dense: widget.dense,
      selected: widget.selected,
      contentPadding: widget.contentPadding,
      tileColor: widget.tileColor,
      selectedTileColor: widget.selectedTileColor,
    );
  }

  @override
  void registerNotifiers() {
    notifiers = [
      widget.selectedValue,
    ];
  }
}
