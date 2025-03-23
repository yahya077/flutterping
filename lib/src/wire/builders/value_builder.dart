import 'package:flutter/material.dart' as material;

import '../../framework/framework.dart';
import '../definitions/json.dart';
import '../definitions/wire.dart';
import '../models/json.dart';
import '../state_manager.dart';
import '../value_provider.dart';
import 'json_builder.dart';

class ValueBuilder<T> extends JsonBuilder<T> {
  ValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return application
        .make<ValueBuilder>(json.type)
        .build(Json.fromJson(json.data), context);
  }
}

class ScopeValueBuilder<T> extends ValueBuilder<T> {
  ScopeValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    List<String> parts = json.data["key"].split(".");

    return application
        .make<StateManager>(WireDefinition.stateManager)
        .getScope(parts[0])
        .get(parts.sublist(1).join('.'));
  }
}

class StateValueBuilder<T> extends ValueBuilder<T> {
  StateValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return application
        .make<StateManager>(WireDefinition.stateManager)
        .dynamicGet(json.data["key"]);
  }
}

class NotifierValueBuilder<T> extends ValueBuilder<T> {
  NotifierValueBuilder(Application application) : super(application);

  @override
  T build(Json json, material.BuildContext? context) {
    return ValueProvider.of(context!).getValueNotifier(json.data["key"]) as T;
  }
}

class DynamicStringValueBuilder extends ValueBuilder {
  DynamicStringValueBuilder(Application application) : super(application);

  @override
  String build(Json json, material.BuildContext? context) {
    return application
          .make<StringValueBuilder>(JsonDefinition.stringValueBuilder)
          .build(json.data["key"], context: context);
  }
}

class StringValueBuilder {
  final Application application;

  StringValueBuilder(this.application);

  String build(String value, {material.BuildContext? context}) {
    RegExp exp = RegExp(r'\$\{(.*?)\}'); // Regular expression to match ${...}
    Iterable<RegExpMatch> matches = exp.allMatches(value);

    // Iterate over all matches
    for (var match in matches) {
      String matchStr = match.group(1)!; // Extract the content inside ${...}
      List<String> parts = matchStr.split('.'); // Split by '.'

      if (parts.length >= 2) {
        // Get the type and key
        String type = parts[0];
        String key = parts.sublist(1).join('.');

        // Get the corresponding value
        dynamic replaceValue = application.make(type).build(
            Json.fromJson({
              "type": type,
              "data": {"key": key}
            }),
            context);

        switch (replaceValue) {
          case int: // If the value is an integer
            replaceValue = replaceValue.toString();
            break;
          case double: // If the value is a double
            replaceValue = replaceValue.toString();
            break;
          case bool: // If the value is a boolean
            replaceValue = replaceValue.toString();
            break;
          case String: // If the value is a string
            break;
          default:
            replaceValue = replaceValue.toString();
        }

        // Replace ${...} with the obtained value in the original string
        value = value.replaceFirst(match.group(0)!, replaceValue);
      }
    }

    return value;
  }
}

class DynamicValueBuilder extends ValueBuilder<dynamic> {
  DynamicValueBuilder(Application application) : super(application);

  @override
  dynamic build(Json json, material.BuildContext? context) {
    return json.data["value"];
  }
}

class EvalValueBuilder extends ValueBuilder<dynamic> {
  EvalValueBuilder(Application application) : super(application);

  @override
  dynamic build(Json json, material.BuildContext? context) {
    String expressionStr = json.data["key"];
    expressionStr = _replacePlaceholders(expressionStr, context);

    final bool result = _evaluateExpression(expressionStr);
    return result;
  }

  String _replacePlaceholders(
      String expression, material.BuildContext? context) {
    RegExp exp = RegExp(r'\$\{(.*?)\}');
    Iterable<RegExpMatch> matches = exp.allMatches(expression);

    for (var match in matches) {
      String matchStr = match.group(1)!;
      List<String> parts = matchStr.split('.');

      if (parts.length >= 2) {
        String type = parts[0];
        String key = parts.sublist(1).join('.');

        dynamic replaceValue = application.make(type).build(
            Json.fromJson({
              "type": type,
              "data": {"key": key}
            }),
            context);

        switch (replaceValue.runtimeType) {
          case const (ValueNotifier<dynamic>):
            replaceValue = replaceValue.value.toString();
            break;
          default:
            replaceValue = replaceValue.toString();
        }

        expression = expression.replaceFirst(match.group(0)!, replaceValue);
      }
    }

    return expression;
  }

  //TODO complete math expression evaluation
  dynamic _evaluateExpression(String expression) {
    List<String> parts = expression.split(' ');
    if (parts[0].startsWith("!")) {
      String innerExpression = expression.substring(1);
      dynamic result = num.tryParse(innerExpression) ?? innerExpression;
      return !(innerExpression == "true" || result == 1);
    }

    if (parts.length != 3) {
      throw Exception("Invalid expression format");
    }

    dynamic leftOperand = num.tryParse(parts[0]) ?? parts[0];
    String operator = parts[1];
    dynamic rightOperand = num.tryParse(parts[2]) ?? parts[2];

    switch (operator) {
      case '>':
        return leftOperand > rightOperand;
      case '<':
        return leftOperand < rightOperand;
      case '==':
        return leftOperand == rightOperand;
      case '!=':
        return leftOperand != rightOperand;
      case '>=':
        return leftOperand >= rightOperand;
      case '<=':
        return leftOperand <= rightOperand;
      default:
        throw Exception("Unsupported operator $operator");
    }
  }
}
