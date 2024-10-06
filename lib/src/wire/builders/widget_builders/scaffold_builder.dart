part of '../widget_builder.dart';

class ScaffoldBuilder extends WidgetBuilder {
  ScaffoldBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Scaffold(
      appBar: json.data["appBar"] != null
          ? application
              .make<PreferredSizeWidgetBuilder>(json.data["appBar"]["type"])
              .build(Json.fromJson(json.data["appBar"]), context)
          : null,
      body: application
          .make<Builder>(json.data["body"]["type"])
          .build(Json.fromJson(json.data["body"]), context),
      backgroundColor: json.data["backgroundColor"] == null
          ? null
          : Color.findColor(json.data["backgroundColor"]).build(),
      floatingActionButtonLocation:
          json.data["floatingActionButtonLocation"] == null
              ? material.FloatingActionButtonLocation.centerDocked
              : FloatingActionButtonLocation.fromJson(
                      json.data["floatingActionButtonLocation"])
                  .build(),
      floatingActionButton: json.data["floatingActionButton"] != null
          ? application
              .make<WidgetBuilder>(json.data["floatingActionButton"]["type"])
              .build(Json.fromJson(json.data["floatingActionButton"]), context)
          : null,
      bottomNavigationBar: json.data["bottomNavigationBar"] != null
          ? application
              .make<WidgetBuilder>(json.data["bottomNavigationBar"]["type"])
              .build(Json.fromJson(json.data["bottomNavigationBar"]), context)
          : null,
    );
  }
}
