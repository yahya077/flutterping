part of '../widget_builder.dart';

class ImageAssetBuilder extends WidgetBuilder {
  ImageAssetBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    return material.Image.asset(
      element.data["name"],
      width: DoubleFactory.fromDynamic(element.data["width"]),
      height: DoubleFactory.fromDynamic(element.data["height"]),
      fit: element.data["fit"] == null
          ? material.BoxFit.contain
          : BoxFit.fromJson(element.data["fit"]).build(),
      alignment: element.data["alignment"] == null
          ? material.Alignment.center
          : Alignment.fromJson(element.data["alignment"]).build(),
      repeat: element.data["repeat"] == null
          ? material.ImageRepeat.noRepeat
          : ImageRepeat.fromJson(element.data["repeat"]).build(),
      semanticLabel: element.data["semanticLabel"],
      excludeFromSemantics: element.data["excludeFromSemantics"] ?? false,
      filterQuality: element.data["filterQuality"] == null
          ? material.FilterQuality.low
          : FilterQuality.fromJson(element.data["filterQuality"]).build(),
      errorBuilder: null, //TODO errorBuilder
      frameBuilder: null, //TODO frameBuilder
      cacheWidth: element.data["cacheWidth"],
      cacheHeight: element.data["cacheHeight"],
      color: element.data["color"] == null
          ? null
          : Color.findColor(element.data["color"]).build(),
    );
  }
}