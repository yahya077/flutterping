part of '../widget_builder.dart';

class MaterialAppBuilder extends WidgetBuilder {
  MaterialAppBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final homeEl = Json.fromJson(json.data["home"]);
    return material.MaterialApp(
      debugShowCheckedModeBanner: json.data["debugShowCheckedModeBanner"],
      home: application.make<WidgetBuilder>(homeEl.type).build(homeEl, context),
    );
  }
}
