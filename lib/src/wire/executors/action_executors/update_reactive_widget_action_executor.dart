part of '../action_executor.dart';

class UpdateReactiveWidgetActionExecutor extends ActionExecutor {
  UpdateReactiveWidgetActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final manager = ValueProvider.of(context);
    final widgetEl = Element.fromJson(element.data["widget"]);

    manager.getValueNotifier(element.data["reactiveWidgetId"])?.updateValue(
        application.make<WidgetBuilder>(widgetEl.type).build(widgetEl));
  }
}
