part of '../action_executor.dart';

class UpdateReactiveWidgetActionExecutor extends ActionExecutor {
  UpdateReactiveWidgetActionExecutor(Application application)
      : super(application);

  @override
  Future<void> execute(material.BuildContext context, Json json) async {
    final manager = ValueProvider.of(context);
    final widgetEl = Json.fromJson(json.data["widget"]);

    manager.getValueNotifier(json.data["reactiveWidgetId"])?.updateValue(
        application.make<WidgetBuilder>(widgetEl.type).build(widgetEl, context));
  }
}
