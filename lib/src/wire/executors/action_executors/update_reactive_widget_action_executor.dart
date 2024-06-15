part of '../action_executor.dart';

class UpdateReactiveWidgetActionExecutor extends ActionExecutor {
  UpdateReactiveWidgetActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Element element) async {
    final manager = ReactiveWidgetProvider.of(context);
    final widgetEl = Element.fromJson(element.data["widget"]);
    manager.getReactiveWidget(element.data["reactiveWidgetId"])?.updateWidget(
        application.make<WidgetBuilder>(widgetEl.type).build(widgetEl));
  }
}