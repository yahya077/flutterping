part of 'flutter_svg.dart';

class SvgPictureAssetBuilder extends WidgetBuilder {
  SvgPictureAssetBuilder(super.application);

  @override
  material.Widget build(Json json, material.BuildContext? context) {
    return flutter_svg.SvgPicture.asset(
      json.data["assetName"],
      width: DoubleFactory.fromDynamic(json.data["width"]),
      height: DoubleFactory.fromDynamic(json.data["height"]),
      alignment: json.data["alignment"] == null
          ? material.Alignment.center
          : Alignment.fromJson(json.data["alignment"]).build(),
      fit: json.data["fit"] == null
          ? material.BoxFit.contain
          : BoxFit.fromJson(json.data["fit"]).build(),
      matchTextDirection: json.data["matchTextDirection"] ?? false,
      allowDrawingOutsideViewBox:
          json.data["allowDrawingOutsideViewBox"] ?? false,
      excludeFromSemantics: json.data["excludeFromSemantics"] ?? false,
    );
  }
}
