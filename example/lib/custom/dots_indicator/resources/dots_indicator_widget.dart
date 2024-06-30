part of '../dots_indicator.dart';

class DotsIndicator extends material.StatefulWidget {
  final int dotsCount;
  final bool reversed;
  final ValueNotifier<int> position;
  final void Function(int index)? onTap;

  const DotsIndicator({
    material.Key? key,
    required this.dotsCount,
    required this.reversed,
    required this.position,
    required this.onTap,
  }) : super(key: key);

  @override
  NeedsValueNotifierState<DotsIndicator> createState() => _DotsIndicatorState();
}

class _DotsIndicatorState extends NeedsValueNotifierState<DotsIndicator> {
  @override
  material.Widget build(material.BuildContext context) {
    return dots_indicator.DotsIndicator(
      dotsCount: widget.dotsCount,
      position: widget.position.value!,
      reversed: widget.reversed,
      onTap: widget.onTap,
    );
  }

  @override
  void registerNotifiers() {
    notifiers = [widget.position];
  }
}
