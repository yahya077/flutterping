part of '../widget_builder.dart';

class MaterialAppRouterBuilder extends WidgetBuilder {
  MaterialAppRouterBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.MaterialApp.router(
      debugShowCheckedModeBanner: json.data["debugShowCheckedModeBanner"],
      routerConfig: application
          .make<RouterConfigBuilder>(json.data["routerConfig"]["type"])
          .build(Json.fromJson(json.data["routerConfig"]), context),
      supportedLocales: json.data["supportedLocales"] != null ? json.data["supportedLocales"]
          .map((locale) => Locale.fromJson(locale).build())
          .toList() : const [material.Locale('tr', 'TR')],
      showPerformanceOverlay: json.data["showPerformanceOverlay"] ?? false,
      checkerboardOffscreenLayers: json.data["checkerboardOffscreenLayers"] ?? false,
      checkerboardRasterCacheImages: json.data["checkerboardRasterCacheImages"] ?? false,
      locale: json.data["locale"] == null
          ? null
          : Locale.fromJson(json.data["locale"]).build(),
      localizationsDelegates: json.data["localizationsDelegates"]
          .map((delegate) => application
              .make<LocalizationDelegateBuilder>(delegate["type"])
              .build(Json.fromJson(delegate), context))
          .toList(),
      theme: json.data["theme"] != null ? application
          .make<ThemeDataBuilder>(json.data["theme"]["type"])
          .build(Json.fromJson(json.data["theme"]), context) : null,
    );
  }
}
