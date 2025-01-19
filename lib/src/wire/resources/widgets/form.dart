import 'package:flutter/material.dart' as material;

class PingForm extends material.Form {
  const PingForm({
    material.Key? key,
    required material.Widget child,
    required material.AutovalidateMode autovalidateMode,
  }) : super(key: key, child: child);

  @override
  PingFormState createState() => PingFormState();
}

class PingFormState extends material.FormState {
  final Map<String, dynamic> _fieldValues = {};

  void updateValue(String name, dynamic value) {
    _fieldValues[name] = value;
  }

  dynamic getValue(String name) => _fieldValues[name];

  Map<String, dynamic> get values => _fieldValues;

  @override
  bool validate() {
    bool isValid = true;

    for (var field in registeredFields) {
      final error =
      field.widget.validator?.call(_fieldValues[field.widget.name]);
      if (error != null) {
        isValid = false;
      }
      field.setError(error);
    }

    return isValid;
  }

  setFieldError(String field, String errorMessage) {
    for (var registeredField in registeredFields) {
      if (registeredField.widget.name == field) {
        registeredField.setError(errorMessage);
        break;
      }
    }
  }

  final List<PingFormFieldState> registeredFields = [];

  void registerField(PingFormFieldState field) {
    registeredFields.add(field);
  }

  void unregisterField(PingFormFieldState field) {
    registeredFields.remove(field);
  }
}

class PingFormField extends material.FormField<dynamic> {
  final String name;
  final String? Function(dynamic value)? validator;

  const PingFormField({
    material.Key? key,
    required this.name,
    required super.builder,
    this.validator,
  }) : super(
    key: key,
    validator: validator,
  );

  @override
  PingFormFieldState createState() => PingFormFieldState();
}

class PingFormFieldState extends material.FormFieldState<dynamic> {
  PingFormState? _formState;

  @override
  PingFormField get widget => super.widget as PingFormField;

  String? _error;

  @override
  void initState() {
    super.initState();
    _formState = context.findAncestorStateOfType<PingFormState>();
    _formState?.registerField(this);
    _formState?.updateValue(widget.name, value);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _formState = context.findAncestorStateOfType<PingFormState>();
  }

  @override
  void dispose() {
    _formState?.unregisterField(this);
    super.dispose();
  }

  void setError(String? error) {
    setState(() {
      _error = error;
    });
  }

  @override
  String? get errorText => _error;

  @override
  void didChange(dynamic value) {
    super.didChange(value);
    _formState?.updateValue(widget.name, value);

    final error = widget.validator?.call(value);
    setError(error);
  }

  @override
  void reset() {
    super.reset();
    _error = null;
  }

  @override
  void didUpdateWidget(PingFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _formState?.updateValue(widget.name, value);
  }

  @override
  void setValue(dynamic value) {
    super.setValue(value);
    _formState?.updateValue(widget.name, value);
  }

  @override
  void save() {
    super.save();
    _formState?.updateValue(widget.name, value);
  }

}

class AutovalidateMode {
  String value;
  static const String always = "always";
  static const String onUserInteraction = "onUserInteraction";
  static const String disabled = "disabled";

  AutovalidateMode(this.value);

  factory AutovalidateMode.fromJson(Map<String, dynamic> json) {
    return AutovalidateMode(json["value"]);
  }

  material.AutovalidateMode build() {
    switch (value) {
      case always:
        return material.AutovalidateMode.always;
      case onUserInteraction:
        return material.AutovalidateMode.onUserInteraction;
      case disabled:
        return material.AutovalidateMode.disabled;
      default:
        return material.AutovalidateMode.disabled;
    }
  }
}