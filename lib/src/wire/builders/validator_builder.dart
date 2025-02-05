import 'package:flutter/material.dart' as material;
import '../../../flutter_ping_wire.dart';

typedef FormFieldValidator<T> = String? Function(T? value);

class ComposerValidatorBuilder extends ValidatorBuilder {
  ComposerValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    List<FormFieldValidator> validators = [];

    for (final validator in json.data["validators"]) {
      final validatorJson = Json.fromJson(validator);
      validators.add(application
          .make<ValidatorBuilder>(validatorJson.type)
          .build(validatorJson, context));
    }

    return (dynamic value) {
      for (final FormFieldValidator validator in validators) {
        final String? validatorResult = validator(value);
        if (validatorResult != null) {
          return validatorResult;
        }
      }
      return null;
    };
  }
}

abstract class ValidatorBuilder<FormFieldValidator>
    extends JsonBuilder<FormFieldValidator> {
  ValidatorBuilder(Application application) : super(application);
}

abstract class PredefinedValidatorBuilder extends ValidatorBuilder {
  PredefinedValidatorBuilder(Application application) : super(application);

  bool hasMatch(String pattern, String input, {bool caseSensitive = true}) =>
      RegExp(pattern, caseSensitive: caseSensitive).hasMatch(input);
}

class RequiredValidatorBuilder extends PredefinedValidatorBuilder {
  RequiredValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    return (dynamic value) {
      if (value is bool) {
        return value ? null : json.data["errorMessage"];
      }

      return (value == null || value.isEmpty)
          ? json.data["errorMessage"]
          : null;
    };
  }
}

class EmailValidatorBuilder extends PredefinedValidatorBuilder {
  final Pattern _emailPattern =
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";

  EmailValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    return (dynamic value) {
      return hasMatch(_emailPattern.toString(), value!, caseSensitive: false)
          ? null
          : json.data["errorMessage"];
    };
  }
}

class LengthValidatorBuilder extends PredefinedValidatorBuilder {
  LengthValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    return (dynamic value) {
      return (value.length < json.data["min"] ||
              value.length > json.data["max"])
          ? json.data["errorMessage"]
          : null;
    };
  }
}

class MinLengthValidatorBuilder extends PredefinedValidatorBuilder {
  MinLengthValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    final withoutSpaces = json.data["withoutSpaces"] ?? false;

    return (dynamic value) {
      if (withoutSpaces) {
        value = value.replaceAll(" ", "");
      }
      return (value.length < json.data["min"])
          ? json.data["errorMessage"]
          : null;
    };
  }
}

class MaxLengthValidatorBuilder extends PredefinedValidatorBuilder {
  MaxLengthValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    final withoutSpaces = json.data["withoutSpaces"] ?? false;

    return (dynamic value) {
      if (withoutSpaces) {
        value = value.replaceAll(" ", "");
      }
      return (value.length > json.data["max"])
          ? json.data["errorMessage"]
          : null;
    };
  }
}

class RangeValidatorBuilder extends PredefinedValidatorBuilder {
  RangeValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    return (dynamic value) {
      final numValue = num.tryParse(value);
      if (numValue == null) {
        return json.data["errorMessage"];
      }
      if (numValue < json.data["min"] || numValue > json.data["max"]) {
        return json.data["errorMessage"];
      }
      return null;
    };
  }
}

class RegexValidatorBuilder extends PredefinedValidatorBuilder {
  RegexValidatorBuilder(Application application) : super(application);

  @override
  FormFieldValidator build(Json json, material.BuildContext? context) {
    final pattern = json.data["pattern"];
    final caseSensitive = json.data["caseSensitive"] ?? true;

    return (dynamic value) {
      return hasMatch(pattern, value, caseSensitive: caseSensitive)
          ? null
          : json.data["errorMessage"];
    };
  }
}