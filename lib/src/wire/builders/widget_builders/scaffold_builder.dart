part of '../widget_builder.dart';

class ScaffoldBuilder extends WidgetBuilder {
  ScaffoldBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Scaffold(
      appBar: element.data["appBar"] != null
          ? application
          .make<PreferredSizeWidgetBuilder>(element.data["appBar"]["type"])
          .build(Element.fromJson(element.data["appBar"]))
          : null,
      body: application
          .make<WidgetBuilder>(element.data["body"]["type"])
          .build(Element.fromJson(element.data["body"])),
      bottomNavigationBar: element.data["bottomNavigationBar"] != null
          ? application
          .make<WidgetBuilder>(element.data["bottomNavigationBar"]["type"])
          .build(Element.fromJson(element.data["bottomNavigationBar"]))
          : null,
    );
  }
}
