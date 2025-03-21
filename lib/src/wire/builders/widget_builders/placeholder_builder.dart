part of '../widget_builder.dart';

class PlaceholderBuilder extends WidgetBuilder {
  PlaceholderBuilder(Application application) : super(application);

  @override
  material.Placeholder build(Json json, material.BuildContext? context) {
    return material.Placeholder(
      color: json.data["color"] == null
          ? const material.Color(0xFF455A64)
          : Color.findColor(json.data["color"]).build(),
      strokeWidth: DoubleFactory.fromDynamic(json.data["strokeWidth"]) ?? 2.0,
      fallbackHeight:
          DoubleFactory.fromDynamic(json.data["fallbackHeight"]) ?? 400.0,
      fallbackWidth:
          DoubleFactory.fromDynamic(json.data["fallbackWidth"]) ?? 400.0,
    );
  }
}
