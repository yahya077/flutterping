part of '../action_executor.dart';

class AlertActionExecutor extends ActionExecutor {
  AlertActionExecutor(Application application) : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    material.ScaffoldMessenger.of(context).showSnackBar(material.SnackBar(
      behavior: material.SnackBarBehavior.floating,
      content: application
          .make<WidgetBuilder>(element.data["content"]["type"])
          .build(Element.fromJson(element.data["content"])),
      backgroundColor: element.data["color"] == null
          ? null
          : Color.findColor(element.data["color"]).build(),
    ));
  }
}