part of '../animated_bottom_navigation_bar.dart';

class AnimatedBottomNavigationBar extends material.StatefulWidget {
  final List<material.IconData> icons;
  final ValueNotifier<int> activeIndex;
  final void Function(int index) onTap;
  final material.Color? inactiveColor;
  final material.Color? activeColor;
  final double? leftCornerRadius;
  final double? rightCornerRadius;

  const AnimatedBottomNavigationBar({material.Key? key, required this.icons, required this.activeIndex, required this.onTap, this.inactiveColor, this.activeColor, this.leftCornerRadius, this.rightCornerRadius}) : super(key: key);

  @override
  NeedsValueNotifierState<AnimatedBottomNavigationBar> createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends NeedsValueNotifierState<AnimatedBottomNavigationBar> {
  @override
  void registerNotifiers() {
    notifiers = [widget.activeIndex];
  }

  @override
  material.Widget build(material.BuildContext context) {
    return animated_bottom_navigation_bar.AnimatedBottomNavigationBar(
      onTap: widget.onTap,
      icons: widget.icons,
      activeIndex: widget.activeIndex.value!,
      gapLocation: animated_bottom_navigation_bar.GapLocation.center,
      notchSmoothness: animated_bottom_navigation_bar.NotchSmoothness.smoothEdge,
      inactiveColor: widget.inactiveColor,
      activeColor: widget.inactiveColor,
    );
  }
}
