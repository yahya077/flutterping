part of 'flutter_svg.dart';

class FlutterSvgProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  FlutterSvgProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(FlutterSvgDefinition.svgPictureAsset,
          () => SvgPictureAssetBuilder(app));
          
      if (foundation.kDebugMode) {
        print('FlutterSvgProvider registered successfully');
      }
    } catch (e, stack) {
      if (foundation.kDebugMode) {
        print('Error registering FlutterSvgProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
  
  @override
  Future<void> boot(Application app) async {
    try {
      // Any initialization that requires other services
      if (foundation.kDebugMode) {
        print('FlutterSvgProvider booted successfully');
      }
    } catch (e, stack) {
      if (foundation.kDebugMode) {
        print('Error booting FlutterSvgProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
