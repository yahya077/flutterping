import 'package:flutter/material.dart' as material;
import 'package:flutter_ping_wire/src/framework/app.dart';
import '../resources/core/double.dart';
import 'json_builder.dart';
import '../models/json.dart';

class ThemeDataBuilder<T> extends JsonBuilder<material.ThemeData> {
  ThemeDataBuilder(Application application) : super(application);

  @override
  material.ThemeData build(Json json, material.BuildContext? context) {
    return material.ThemeData(
      primaryColor: json.data["primaryColor"],
      primarySwatch: json.data["primarySwatch"],
      scaffoldBackgroundColor: json.data["scaffoldBackgroundColor"],
      dialogBackgroundColor: json.data["dialogBackgroundColor"],
      canvasColor: json.data["canvasColor"],
      cardColor: json.data["cardColor"],
      dividerColor: json.data["dividerColor"],
      focusColor: json.data["focusColor"],
      hoverColor: json.data["hoverColor"],
      highlightColor: json.data["highlightColor"],
      splashColor: json.data["splashColor"],
      unselectedWidgetColor: json.data["unselectedWidgetColor"],
      disabledColor: json.data["disabledColor"],
      secondaryHeaderColor: json.data["secondaryHeaderColor"],
      indicatorColor: json.data["indicatorColor"],
      shadowColor: json.data["shadowColor"],
      appBarTheme: json.data["appBarTheme"] != null
          ? material.AppBarTheme(
              backgroundColor: json.data["appBarTheme"]["backgroundColor"],
              foregroundColor: json.data["appBarTheme"]["foregroundColor"],
              centerTitle: json.data["appBarTheme"]["centerTitle"],
              elevation: DoubleFactory.fromDynamic(json.data["elevation"]),
              shadowColor: json.data["appBarTheme"]["shadowColor"],
            )
          : null,
      bottomNavigationBarTheme:
          json.data["bottomNavigationBarThemeData"] != null
              ? material.BottomNavigationBarThemeData(
                  backgroundColor: json.data["bottomNavigationBarThemeData"]
                      ["backgroundColor"],
                  selectedItemColor: json.data["bottomNavigationBarThemeData"]
                      ["selectedItemColor"],
                  unselectedItemColor: json.data["bottomNavigationBarThemeData"]
                      ["unselectedItemColor"],
                  elevation: DoubleFactory.fromDynamic(json.data["elevation"]),
                )
              : null,
    );
  }
}
