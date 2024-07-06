part of '../widget_builder.dart';

class MaterialAppRouterBuilder extends WidgetBuilder {
  MaterialAppRouterBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    final routerConfigEl = Json.fromJson(json.data["routerConfig"]);
    return material.MaterialApp.router(
      debugShowCheckedModeBanner: json.data["debugShowCheckedModeBanner"],
      routerConfig: application
          .make<RouterConfigBuilder>(routerConfigEl.type)
          .build(routerConfigEl, context),
    );
  }
}
