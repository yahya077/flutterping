part of '../widget_builder.dart';

class IconDataBuilder extends WidgetBuilder {
  IconDataBuilder(Application application) : super(application);

  @override
  material.Widget build(Json json) {
    //TODO separate this into a new class
    return material.Icon(material.IconData(
      json.data['codePoint'],
      fontFamily: json.data['fontFamily'] ?? 'MaterialIcons',
    ));
  }
}
