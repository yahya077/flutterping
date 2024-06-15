part of '../widget_builder.dart';
class MaterialAppRouterBuilder extends WidgetBuilder {
  MaterialAppRouterBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    final routerConfigEl = Element.fromJson(element.data["routerConfig"]);
    return material.MaterialApp.router(
      debugShowCheckedModeBanner: element.data["debugShowCheckedModeBanner"],
      routerConfig: application
          .make<RouterConfigBuilder>(routerConfigEl.type)
          .build(routerConfigEl),
    );
  }
}
