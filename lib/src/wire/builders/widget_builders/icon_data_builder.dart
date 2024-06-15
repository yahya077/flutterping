part of '../widget_builder.dart';

class IconDataBuilder extends WidgetBuilder {
  IconDataBuilder(Application application) : super(application);

  @override
  material.Widget build(Element element) {
    //TODO separate this into a new class
    return material.Icon(material.IconData(
      element.data['codePoint'],
      fontFamily: element.data['fontFamily'] ?? 'MaterialIcons',
    ));
  }
}
