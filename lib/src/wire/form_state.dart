import 'package:flutter/material.dart' as material;

import 'resources/widgets/form.dart';
import 'state.dart';

abstract class FormFieldState {
  void clear();

  void updateValue(dynamic text);

  void onChanged(dynamic value);

  void onSaved(dynamic value);

  dynamic getName();

  dynamic getValue();

  void dispose();

  void onEditingComplete();
}

class FormState extends State {
  FormState({required Map<String, dynamic> state}) : super(state: state);

  FormState.initial(String id,
      {material.GlobalKey<PingFormState>? formStateKey})
      : super(state: {}) {
    hydrate({
      'id': id,
      'formStateKey':
          formStateKey ?? material.GlobalKey<PingFormState>(debugLabel: id),
    });
  }

  material.GlobalKey<PingFormState> get formStateKey =>
      get<material.GlobalKey<PingFormState>>('formStateKey');

  List<FormFieldState> get formFields {
    final formFields = get('formFields');

    if (formFields is List<dynamic>) {
      return formFields.cast<FormFieldState>();
    } else {
      return formFields;
    }
  }

  @override
  String getId() {
    return get('id');
  }

  save() {
    formStateKey.currentState?.save();
  }

  reset() {
    formStateKey.currentState?.reset();
  }

  validate() {
    formStateKey.currentState?.validate();
  }

  activate() {
    // TODO: Implement activate
  }

  @override
  dispose() {
    // TODO: Implement dispose
  }

  Map<String, dynamic> getValues() {
    Map<String, dynamic> values = {};

    for (var formField in formFields) {
      values[formField.getName()] = formField.getValue();
    }

    return values;
  }

  addFormField(FormFieldState formField) {
    formFields.add(formField);
  }

  removeFormField(FormFieldState formField) {
    formFields.remove(formField);
  }

  String getParentStateId() {
    return get('parentStateId');
  }
}

abstract class TextFormFieldState implements FormFieldState {
  material.TextEditingController getController();
}

class TextFormField implements TextFormFieldState {
  String name;
  material.TextEditingController controller = material.TextEditingController();

  TextFormField(this.name);

  _simulateServerUpdate() async {
    await Future.delayed(const Duration(milliseconds: 300), () {});
  }

  @override
  dynamic getName() {
    return name;
  }

  @override
  void clear() async {
    controller.clear();
  }

  @override
  void updateValue(dynamic text) async {
    controller.text = text;
  }

  @override
  dynamic getValue() {
    return controller.text;
  }

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  void onChanged(value) async {
    await _simulateServerUpdate();
    controller.text = value;
  }

  @override
  void onSaved(value) async {
    await _simulateServerUpdate();
  }

  @override
  void onEditingComplete() async {}

  @override
  material.TextEditingController getController() {
    return controller;
  }
}
