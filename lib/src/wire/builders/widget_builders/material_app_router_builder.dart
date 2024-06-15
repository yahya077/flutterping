part of '../widget_builder.dart';

class MaterialAppBuilder extends WidgetBuilder {
  MaterialAppBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final homeEl = Element.fromJson(element.data["home"]);
    return material.MaterialApp(
      debugShowCheckedModeBanner: element.data["debugShowCheckedModeBanner"],
      home: application
          .make<WidgetBuilder>(homeEl.type)
          .build(homeEl),
    );
  }
}
