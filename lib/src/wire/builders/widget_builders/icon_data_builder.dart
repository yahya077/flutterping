part of '../widget_builder.dart';

class IconDataBuilder extends JsonBuilder<material.IconData> {
  IconDataBuilder(Application application) : super(application);

  @override
  material.IconData build(Json json, material.BuildContext? context) {
    return material.IconData(
      json.data['codePoint'],
      fontFamily: json.data['fontFamily'] ?? 'MaterialIcons',
    );
  }
}
