part of 'flutter_svg.dart';

class FlutterSvgProvider extends Provider {
  FlutterSvgProvider();

  @override
  void register(Application app) {
    app.singleton(FlutterSvgDefinition.svgPictureAsset,
        () => SvgPictureAssetBuilder(app));
  }
}
