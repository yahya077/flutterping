part of '../widget_builder.dart';

class ImageNetworkBuilder extends WidgetBuilder {
  ImageNetworkBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return material.Image.network(
      json.data["url"],
      width: DoubleFactory.fromDynamic(json.data["width"]),
      height: DoubleFactory.fromDynamic(json.data["height"]),
      fit: json.data["fit"] == null
          ? material.BoxFit.contain
          : BoxFit.fromJson(json.data["fit"]).build(),
      alignment: json.data["alignment"] == null
          ? material.Alignment.center
          : Alignment.fromJson(json.data["alignment"]).build(),
      repeat: json.data["repeat"] == null
          ? material.ImageRepeat.noRepeat
          : ImageRepeat.fromJson(json.data["repeat"]).build(),
      semanticLabel: json.data["semanticLabel"],
      excludeFromSemantics: json.data["excludeFromSemantics"] ?? false,
      filterQuality: json.data["filterQuality"] == null
          ? material.FilterQuality.low
          : FilterQuality.fromJson(json.data["filterQuality"]).build(),
      loadingBuilder: null, //TODO loadingBuilder
      errorBuilder: null, //TODO errorBuilder
      frameBuilder: null, //TODO frameBuilder
      cacheWidth: json.data["cacheWidth"],
      cacheHeight: json.data["cacheHeight"],
      color: json.data["color"] == null
          ? null
          : Color.findColor(json.data["color"]).build(),
    );
  }
}