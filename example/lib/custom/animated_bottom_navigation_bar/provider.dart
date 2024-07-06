part of 'animated_bottom_navigation_bar.dart';

class AnimatedBottomNavigationBarProvider extends Provider {
  AnimatedBottomNavigationBarProvider();

  @override
  void register(Application app) {
    app.singleton(Definition.animatedBottomNavigationBar,
        () => AnimatedBottomNavigationBarBuilder(app));
  }
}
