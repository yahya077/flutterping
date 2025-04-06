part of 'animated_bottom_navigation_bar.dart';

class AnimatedBottomNavigationBarProvider extends ServiceProvider {
  @override
  int get priority => 30; // Set priority level for this provider
  
  AnimatedBottomNavigationBarProvider();

  @override
  void register(Application app) {
    try {
      app.singleton(Definition.animatedBottomNavigationBar,
          () => AnimatedBottomNavigationBarBuilder(app));
          
      if (foundation.kDebugMode) {
        print('AnimatedBottomNavigationBarProvider registered successfully');
      }
    } catch (e, stack) {
      if (foundation.kDebugMode) {
        print('Error registering AnimatedBottomNavigationBarProvider: $e');
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
        print('AnimatedBottomNavigationBarProvider booted successfully');
      }
    } catch (e, stack) {
      if (foundation.kDebugMode) {
        print('Error booting AnimatedBottomNavigationBarProvider: $e');
        print('Stack trace: $stack');
      }
      rethrow;
    }
  }
}
